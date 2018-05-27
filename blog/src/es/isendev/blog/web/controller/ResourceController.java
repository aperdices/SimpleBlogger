// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

// import org.springframework.ui.ModelMap;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import es.isendev.blog.dao.beans.Resource;
import es.isendev.blog.dao.beans.User;
import es.isendev.blog.dao.interfaces.FolderInterface;
import es.isendev.blog.dao.interfaces.ResourceInterface;
import es.isendev.blog.util.SimpleBloggerConfig;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

@Controller
@RequestMapping("/resource")
public class ResourceController {
	
	// Bean Interfaces	
	@Autowired
	private ResourceInterface resourceInterface;

	@Autowired
	private FolderInterface folderInterface;
	
	@Autowired
	private SimpleBloggerConfig simpleBloggerConfig;
	
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	@ResponseBody
	public List<Object> resourceUpload(@RequestParam("file") MultipartFile[] files, @RequestParam("folderId") int folderId) throws IOException {

		System.out.println("ResourceController.resourceUpload()");

		for (MultipartFile file : files) {
			if (!file.getOriginalFilename().isEmpty()) {

				Resource res = resourceInterface.createResource();

				// Pre-fill dates.    		   
				res.setCreationDate(new Date());
				res.setModificationDate(res.getCreationDate());

				// Pre-fill Resource User from Security Context logged User. getPrincipal() returns a UserDetails object.
				// This object can be cast to User as it extends UserDetails. Remember that we use a CustomUserDetailsService.
				res.setUser((User)((SecurityContext)SecurityContextHolder.getContext()).getAuthentication().getPrincipal());    		   

				res.setName(file.getOriginalFilename());
				res.setFolder(folderInterface.findFolder(folderId));
				res.setContentType(file.getContentType());
				res.setSize(file.getSize());

				String filePath = simpleBloggerConfig.getResourcesPath() + "/" + String.format("%08d", folderId) + "/" + res.getName();

				BufferedOutputStream outputStream = new BufferedOutputStream(
						new FileOutputStream(
								new File(filePath)));

				outputStream.write(file.getBytes());
				outputStream.flush();
				outputStream.close();

				res = resourceInterface.saveResource(res);

			}
		}

		return null;
	}    
	
}

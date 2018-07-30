// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import org.springframework.web.bind.annotation.PathVariable;

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
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
	
	class SuccessUploadMessage implements Serializable {

		private static final long serialVersionUID = 1L;

		private boolean success;
		private String message;
		
		public boolean isSuccess() {
			return success;
		}
		
		public void setSuccess(boolean success) {
			this.success = success;
		}
		
		public String getMessage() {
			return message;
		}
		
		public void setMessage(String message) {
			this.message = message;
		}		
		
	}
	
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	@ResponseBody
	public List<Object> resourceUpload(@RequestParam("file") MultipartFile[] files, @RequestParam("folderId") int folderId)  {

		System.out.println("ResourceController.resourceUpload()");
		
		ArrayList<Object> returnList = new ArrayList<Object>();

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
				
				File f = new File(filePath);
				
				if (f.exists()) { 
					
					SuccessUploadMessage successMessage = new SuccessUploadMessage();
					successMessage.success = false;
					successMessage.message = "File already exists";					
					returnList.add(successMessage);
					
				} else {
				
					System.out.println("ResourceController.resourceUpload(): Trying to save file <" + filePath +">.");
	
					try {
						
						BufferedOutputStream outputStream = new BufferedOutputStream(
								new FileOutputStream(
										new File(filePath)));
	
						outputStream.write(file.getBytes());
						outputStream.flush();
						outputStream.close();
						
						res = resourceInterface.saveResource(res);
						
						SuccessUploadMessage successMessage = new SuccessUploadMessage();
						successMessage.success = true;
						successMessage.message = "File successfully uploaded.";					
						returnList.add(successMessage);
						
					} catch (Exception e) {
						
						System.out.println("ResourceController.resourceUpload(): Error saving file: " + e.getMessage());
						e.printStackTrace();
						
						SuccessUploadMessage successMessage = new SuccessUploadMessage();
						successMessage.success = false;
						successMessage.message = e.getMessage();					
						returnList.add(successMessage);
					}
				}
			}
		}
		
		return returnList;
	}
	
	@RequestMapping(value = "/byfolder/{folderId}", method = RequestMethod.GET)
	@ResponseBody
	public List<Resource> listResourcesByFolder(@PathVariable("folderId") int folderId) throws Exception {		
		return resourceInterface.findResourceEntitiesByFolder(folderId);
	}
	
	@RequestMapping(value = "/delete", method = RequestMethod.GET, params={"resourceId"})
	@ResponseBody
	public int deleteResource(@RequestParam("resourceId") int resourceId) throws Exception {

		Resource res = resourceInterface.findResource(resourceId);
		int folderId = res.getFolder().getFolderId();
		String filePath = simpleBloggerConfig.getResourcesPath() + "/" + String.format("%08d", folderId) + "/" + res.getName();
			
		// Delete resource object.
		resourceInterface.deleteResource(resourceId);
		
		// Delete resource file.
		FileUtils.deleteQuietly(new File (filePath));
		
		return 0;
		
    }
	
	@RequestMapping(value="/getbyid/{resourceId}", method=RequestMethod.GET)
	public ResponseEntity<byte[]> getResource (@PathVariable("resourceId") int resourceId) throws Exception {

		Resource res = resourceInterface.findResource(resourceId);
		int folderId = res.getFolder().getFolderId();
		String filePath = simpleBloggerConfig.getResourcesPath() + "/" + String.format("%08d", folderId) + "/" + res.getName();

	    // Retrieve resource contents.
	    byte[] contents = FileUtils.readFileToByteArray(new File(filePath));

	    HttpHeaders headers = new HttpHeaders();
	    // headers.setContentType(MediaType.parseMediaType("application/pdf"));
	    headers.setContentDispositionFormData(res.getName(), res.getName());
	    headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
	    ResponseEntity<byte[]> response = new ResponseEntity<byte[]>(contents, headers, HttpStatus.OK);
	    return response;
	}
		
}

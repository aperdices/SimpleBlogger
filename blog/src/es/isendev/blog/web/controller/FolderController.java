// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

// import org.springframework.ui.ModelMap;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.beans.Folder;
import es.isendev.blog.dao.interfaces.FolderInterface;
import es.isendev.blog.util.SimpleBloggerConfig;

@Controller
@RequestMapping("/folder")
public class FolderController {
	
	// Bean Interfaces	
	@Autowired
	private FolderInterface folderInterface;
	
	@Autowired
	private SimpleBloggerConfig simpleBloggerConfig;
	
	@RequestMapping(value = "/all", method = RequestMethod.GET)
	@ResponseBody
	public List<Folder> listFolders() throws Exception {		

		return folderInterface.findFolderEntities();
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.GET, params={"folderId","foldername"})
	@ResponseBody
	public List<Object> saveFolder(@RequestParam("folderId") int folderId, @RequestParam("foldername") String foldername) throws Exception {
		
		Folder folder = null;
		
		ArrayList<Object> list = new ArrayList<Object>();
			
		// A negative value for folderId, means that we have to create a new Folder.
		if (folderId >= 0) {
			folder = folderInterface.findFolder(folderId);
			if (folder != null) {
				folder.setName(foldername);
				folder.setModificationDate(new Date());
			} else {				
				// We can not find the requested tag to be edited...
				list.add("Save failed... Can not find Folder with folderId <" + foldername + ">.");
				return list;
			}
		} else {
			folder = folderInterface.createFolder();
			folder.setName(foldername);
			folder.setCreationDate(new Date());
			folder.setModificationDate(new Date());
		}
		
		// TODO: Tag object field validation???
		
		folder = folderInterface.saveFolder(folder);
		
		list.add("Folder <" + folder.getName() + "> successfully saved.");
		return list; 
    }	
	
	
}

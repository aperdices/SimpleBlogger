// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.beans.Tag;
import es.isendev.blog.dao.interfaces.TagInterface;

@Controller
@RequestMapping("/tag")
public class TagController {
	
	@Autowired
	private TagInterface tagInterface;
	
	@RequestMapping(value = "/all", method = RequestMethod.GET)
	@ResponseBody
	public List<Tag> listTags() throws Exception {		

		return tagInterface.findTagEntities();
	}	
	
	@RequestMapping(value = "/count", method = RequestMethod.GET)
	@ResponseBody
	public List<Object[]> tagEntryCount() throws Exception {		

		return tagInterface.findTagEntitiesAndEntryCount();
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.GET, params={"tagId","tagname"})
	@ResponseBody
	public List<Object> saveTag(@RequestParam("tagId") int tagId, @RequestParam("tagname") String tagname) throws Exception {
		
		Tag tag = null;
		
		ArrayList<Object> list = new ArrayList<Object>();
			
		// A negative value for tagId, means that we have to create a new Tag.
		if (tagId >= 0) {
			tag = tagInterface.findTag(tagId);
			if (tag != null) {
				tag.setTagname(tagname);
				tag.setModificationDate(new Date());
			} else {				
				// We can not find the requested tag to be edited...
				list.add("Save failed... Can not find Tag with tagId <" + tagname + ">.");
				return list;
			}
		} else {
			tag = tagInterface.createTag();
			tag.setTagname(tagname);
			tag.setCreationDate(new Date());
			tag.setModificationDate(new Date());
		}
		
		// TODO: Tag object field validation???
		
		tag = tagInterface.saveTag(tag);
		
		list.add("Tag <" + tag.getTagname() + "> successfully saved.");
		return list; 
    }
	
	@RequestMapping(value = "/delete", method = RequestMethod.GET, params={"tagId"})
	@ResponseBody
	public List<Object> deleteTag(@RequestParam("tagId") int tagId) throws Exception {
				
		tagInterface.deleteTag(tagId);
		
		ArrayList<Object> list = new ArrayList<Object>();
		list.add("Tag successfully deleted.");
		return list;
    }
			
}

// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.ClassEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.interfaces.EntryInterface;
import es.isendev.blog.dao.interfaces.TagInterface;
import es.isendev.blog.dao.interfaces.UserInterface;
import es.isendev.blog.dao.beans.Entry;
import es.isendev.blog.dao.beans.User;
import es.isendev.blog.dao.beans.Tag;
import es.isendev.blog.validation.EntryValidator;

@Controller
@RequestMapping("/entry")
public class EntryController {
	
	// Bean Interfaces	
	@Autowired
	private EntryInterface entryInterface;
	
	@Autowired
	private TagInterface tagInterface;

	@Autowired
	private UserInterface userInterface;
	
	// Validators
	@Autowired	
	private EntryValidator entryValidator;
		
	// Init binder. Used to maps request string that can not be mapped directly to object by Spring.
	// Dates, multiple select fields, etc. 
	@InitBinder
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder dataBinder) throws Exception {
		
		// Register a custom date editor to parse "creationDate" field.
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		// df.setLenient(false);
		dataBinder.registerCustomEditor(Date.class, "creationDate", new CustomDateEditor(df, false));

		// Register a class editor to parse "user" field.
		dataBinder.registerCustomEditor(User.class, new ClassEditor() {			
			public void setAsText (String text) {
				setValue(userInterface.findUser(text));
			}
		});
		
		// Register a class editor to parse "tag" field.
		dataBinder.registerCustomEditor(Tag.class, new ClassEditor() {			
			public void setAsText (String text) {
				setValue(tagInterface.findTagByName(text));
			}			
		});	
	}	
	
    @RequestMapping(value = "/{entryid}/edit", method = RequestMethod.GET)
    public ModelAndView editEntry(@PathVariable("entryid") int entryid) {

    	// If entryid is 0, create a new entry.
    	if (entryid == 0) {
    		
    		Entry entry = entryInterface.createEntry();

        	// Pre-fill creation Date.
        	entry.setCreationDate(new Date());
        	
        	// Pre-fill Entry User from Security Context logged User. getPrincipal() returns a UserDetails object.
        	// This object can be cast to User as it extends UserDetails. Remember that we use a CustomUserDetailsService.
        	entry.setUser((User)((SecurityContext)SecurityContextHolder.getContext()).getAuthentication().getPrincipal());

    		return new ModelAndView("entryform", new ModelMap().addAttribute("entry", entry));
    	
   		// If entryid is not 0, edit and existing entry.
    	} else {    	
	    	
    		Entry entry = entryInterface.findEntry(entryid);  	
    		return new ModelAndView("entryform", new ModelMap().addAttribute("entry", entry));
    	}
    }
       
	// Path Variable entryid used only to mantain url coherence.
    @RequestMapping(value = "/{entryid}/save", method = RequestMethod.POST)
    public ModelAndView saveEntry(@PathVariable("entryid") int entryid, @ModelAttribute("entry") Entry entry, BindingResult result) {
    	
    	entry.setModificationDate(new Date());
    	entryValidator.validate(entry, result);
    	
    	if (result.hasErrors()) {
    		// On binding or validation errors, return to form.
    		return new ModelAndView("entryform");
    	} else {    		
    		entry = entryInterface.saveEntry(entry);
    		// Use the redirect-after-post pattern to reduce double-submits.
        	return new ModelAndView ("redirect:/app/entry/" + entry.getEntryId());
    	}
    }
    
    @RequestMapping(value = "/{entryid}/delete", method = RequestMethod.GET)
    public String deleteEntry(@PathVariable("entryid") int entryid) {

    	entryInterface.deleteEntry(entryid);
		return "redirect:/app/entries";
    }

    @RequestMapping(value = "/{entryid}/publish", method = RequestMethod.GET)
    public String publishEntry(@PathVariable("entryid") int entryid) {

    	Entry entry = entryInterface.findEntry(entryid);
    	entry.setPublished(true);
    	entryInterface.saveEntry(entry);
		
    	return "redirect:/app/entries/unpublished";
    }

    @RequestMapping(value = "/{entryid}/unpublish", method = RequestMethod.GET)
    public String unpublishEntry(@PathVariable("entryid") int entryid) {

    	Entry entry = entryInterface.findEntry(entryid);
    	entry.setPublished(false);
    	entryInterface.saveEntry(entry);
		
    	return "redirect:/app/entries";
    }
    
    @RequestMapping(value = "/{entryid}", method = RequestMethod.GET)
    public ModelAndView showEntry(@PathVariable("entryid") int entryid) {
    	
    	List<Entry> entries = new ArrayList<Entry>();
    	
    	if (entryInterface.findEntry(entryid) != null) {

        	// Check if we have ROLE_ADMIN
    		boolean admin_role = false;
    		
    		// getPrincipal() returns a String object with ("anonymousUser") if not authenticated.
    		// getPrincipal() returns a User object (UserDetails implementation) if authenticated.
    		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    		if (authentication != null
    				&& authentication.getPrincipal() != null
    				&& authentication.getPrincipal().getClass().equals(User.class)
    				&& ((User)authentication.getPrincipal()).getAuthorities() != null) {
    			for (int i = 0; i < ((User)authentication.getPrincipal()).getAuthorities().size(); i++) {
    				if (((User)authentication.getPrincipal()).getAuthorities().get(i).getAuthority().compareToIgnoreCase("ROLE_ADMIN") == 0) {
    					admin_role = true;
    					break;
    				}				
    			}
    		}    		    		
    		
    		// Show published Entry to all
    		// Show unpublished Entry to ROLE_ADMIN users
    		if (entryInterface.findEntry(entryid).isPublished() || (!entryInterface.findEntry(entryid).isPublished() && admin_role)) {
    			entries.add(entryInterface.findEntry(entryid));
    		}
    	}
    	
    	return new ModelAndView("entrylist", new ModelMap().addAttribute("entries", entries));
    }
    
    @ModelAttribute("tagList")
    public Collection<Tag> populateTags() {
        return tagInterface.findTagEntities();
    }
		
}

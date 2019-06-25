// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.ClassEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.beans.Page;
import es.isendev.blog.dao.beans.User;
import es.isendev.blog.dao.interfaces.PageInterface;
import es.isendev.blog.dao.interfaces.UserInterface;
import es.isendev.blog.validation.PageValidator;

@Controller
@RequestMapping("/page")
public class PageController {
	
	@Autowired
	private PageInterface pageInterface;
	
	@Autowired
	private UserInterface userInterface;
	
	// Validators
	@Autowired	
	private PageValidator pageValidator;
	
	// Init binder. Used to maps request string that can not be mapped directly to object by Spring
	// Dates, multiple select fields, etc. 
	@InitBinder
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder dataBinder) throws Exception {
		
		// Register a custom date editor to parse "creationDate" field
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy k:mm");
		df.setLenient(false);
		dataBinder.registerCustomEditor(Date.class, "creationDate", new CustomDateEditor(df, false));
		
		// Register a class editor to parse "user" field
		dataBinder.registerCustomEditor(User.class, "user", new ClassEditor() {			
			public void setAsText (String text) {
				setValue(userInterface.findUser(text));
			}
		});				

	}	
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView listPages() throws Exception {		
				
		return new ModelAndView("pagelist", new ModelMap().addAttribute("pages", pageInterface.findPageEntities()));
	}
	
    @RequestMapping(value = "/{pageId}/edit", method = RequestMethod.GET)
    public ModelAndView editPage(@PathVariable("pageId") int pageId) {

    	// If entryid is 0, create a new entry .
    	if (pageId == 0) {
    		
    		Page page = pageInterface.createPage();

        	// Pre-fill creation Date.
        	page.setCreationDate(new Date());
        	
        	// Pre-fill Entry User from Security Context logged User. getPrincipal() returns a UserDetails object.
        	// This object can be cast to User as it extends UserDetails. Remember that we use a CustomUserDetailsService.
        	page.setUser((User)((SecurityContext)SecurityContextHolder.getContext()).getAuthentication().getPrincipal());
        	
        	// Pre-fill Menu Order.
        	// 0 value means that the static page will not be shown in the menu.
        	page.setMenuOrder(0);
        	
    		return new ModelAndView("pageform", new ModelMap().addAttribute("page", page));
    	
    	} else {    	
	    	
    		Page page = pageInterface.findPage(pageId);  	
			
    		return new ModelAndView("pageform", new ModelMap().addAttribute("page", page));
			
    	}
    }
    
    @RequestMapping(value = "/{pageId}/save", method = RequestMethod.POST)
    public ModelAndView savePage(@PathVariable("pageId") int pageId, @ModelAttribute("page") Page page, BindingResult result) {
    	
    	// Path Variable {pageId} used only to mantain url coherence.
    	
    	page.setModificationDate(new Date());
    	pageValidator.validate(page, result);
    	
    	if (result.hasErrors()) {
    		// On binding or validation errors, return to form.
    		return new ModelAndView("pageform");
    	} else {    		
    		page = pageInterface.savePage(page);
    		// Use the redirect-after-post pattern to reduce double-submits.
        	return new ModelAndView ("redirect:/app/page/" + page.getPageId());
    		// return new ModelAndView ("redirect:/app/page/list");
    	}
    }
    
    @RequestMapping(value = "/{pageId}/delete", method = RequestMethod.GET)
    public ModelAndView deletePage(@PathVariable("pageId") int pageId) {
    	
    	pageInterface.deletePage(pageId);
    	
    	// Use the redirect-after-post pattern to reduce double-submits.
        // return new ModelAndView ("redirect:/app/page/" + page.getPageId());
    	return new ModelAndView ("redirect:/app/page/list");
    }
    
    @RequestMapping(value = "/{pageId}", method = RequestMethod.GET)
    public ModelAndView viewPage(@PathVariable("pageId") int pageId) {
    	
    	// Check if we have ROLE_ADMIN
		// boolean admin_role = false;
		
		// getPrincipal() returns a String object with ("anonymousUser") if not authenticated.
		// getPrincipal() returns a User object (UserDetails implementation) if authenticated.
		/*
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
		*/
		
		// Show listed Page to all
		// Show unlisted Page to ROLE_ADMIN users
		
		// if (pageInterface.findPage(pageId) != null && (pageInterface.findPage(pageId).getMenuOrder() > 0 || ((pageInterface.findPage(pageId).getMenuOrder() < 1) && admin_role))) {
		
		if (pageInterface.findPage(pageId) != null) {
			return new ModelAndView("pageview", new ModelMap().addAttribute("page", pageInterface.findPage(pageId)));
		}		
    	
    	return new ModelAndView("pageview", new ModelMap().addAttribute("page", null));
    }
    
	@RequestMapping(value = "/count", method = RequestMethod.GET)
	@ResponseBody
	public List<Object[]> pageCount() throws Exception {		

		return pageInterface.findPageTitles();
	}
    
	
}

// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import java.text.DateFormatSymbols;
import java.util.List;
import java.util.Locale;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.interfaces.EntryInterface;
import es.isendev.blog.dao.interfaces.TagInterface;
import es.isendev.blog.util.SimpleBloggerConfig;

@Controller
@RequestMapping("/entries")
public class EntriesController {
	
	// Bean Interfaces	
	@Autowired
	private EntryInterface entryInterface;
	
	@Autowired	
	private TagInterface tagInterface;
	
	@Autowired
	private SimpleBloggerConfig simpleBloggerConfig;
			
	// Default method to list entries.
	// No paging related parameters are passed.
	@RequestMapping(value = "", method = RequestMethod.GET)
	public ModelAndView listEntries() throws Exception {		
		return new ModelAndView ("redirect:/app/entries/1");		
	}
	
	// Method to list paged entries.
	// Paging related parameters are passed.
	@RequestMapping(value = "/{page}", method = RequestMethod.GET)
	public ModelAndView listEntries(@PathVariable("page") int page) throws Exception {
		
		// Calculate last page number
		int numresults = entryInterface.getEntryEntitiesCount(true);
		int lastpage = 1;
		ModelMap model = new ModelMap();
		
		if (numresults > 0) {
			if (numresults % simpleBloggerConfig.getEntriesPerPage() == 0) {
				lastpage = numresults / simpleBloggerConfig.getEntriesPerPage();
			} else {
				lastpage = (numresults / simpleBloggerConfig.getEntriesPerPage()) + 1;
			}
			
			// Check if page parameter has a valid value 
			if (page < 1) {
				// If not, set first page as default value
				page = 1;
			} else if (page > lastpage) {
				page = lastpage;
			}
			
			model.addAttribute("entries", entryInterface.findEntryEntities(page, simpleBloggerConfig.getEntriesPerPage(), true));
		}
		
    	model.addAttribute("page", page);
    	model.addAttribute("lastpage", lastpage);
    	
		return new ModelAndView("entrylist", model);	
	}
	
	// Default method to list unpublished entries.
	// No paging related parameters are passed.
	@RequestMapping(value = "/unpublished", method = RequestMethod.GET)
	public ModelAndView listUnpublishedEntries() throws Exception {
		
		return new ModelAndView ("redirect:/app/entries/unpublished/1");		
	}
	
	// Method to list paged unpublished entries.
	// Paging related parameters are passed.
	@RequestMapping(value = "/unpublished/{page}", method = RequestMethod.GET)
	public ModelAndView listUnpublishedEntries(@PathVariable("page") int page) throws Exception {
		
		// Calculate last page number
		int numresults = entryInterface.getEntryEntitiesCount(false);
		int lastpage = 1;
		ModelMap model = new ModelMap();
		
		if (numresults > 0) {
			if (numresults % simpleBloggerConfig.getEntriesPerPage() == 0) {
				lastpage = numresults / simpleBloggerConfig.getEntriesPerPage();
			} else {
				lastpage = (numresults / simpleBloggerConfig.getEntriesPerPage()) + 1;
			}
			
			// Check if page parameter has a valid value 
			if (page < 1) {
				// If not, set first page as default value
				page = 1;
			} else if (page > lastpage) {
				page = lastpage;
			}
			
			model.addAttribute("entries", entryInterface.findEntryEntities(page, simpleBloggerConfig.getEntriesPerPage(), false));
		}
		
    	model.addAttribute("page", page);
    	model.addAttribute("lastpage", lastpage);
    	model.addAttribute("unpublished", true);
    	
		return new ModelAndView("entrylist", model);	
	}
	
	// Default method to list entries by tag.
	// No paging related parameters are passed.
	@RequestMapping(value = "/bytag/{tagid}", method = RequestMethod.GET)
	public ModelAndView listEntriesByTag(@PathVariable("tagid") int tagid) throws Exception {
		
		return new ModelAndView ("redirect:/app/entries/bytag/" + tagid + "/1");		
	}
		
	// Method to list paged entries by tagname.
	// Paging related parameters are passed.
	@RequestMapping(value = "/bytag/{tagid}/{page}", method = RequestMethod.GET)
	public ModelAndView listEntriesByTag(@PathVariable("tagid") int tagid, @PathVariable("page") int page) throws Exception {
		
		// Calculate last page number
		int numresults = entryInterface.getEntryEntitiesCountByTag(tagid);
		int lastpage = 1;
		ModelMap model = new ModelMap();
		
		if (numresults > 0) {
			if (numresults % simpleBloggerConfig.getEntriesPerPage() == 0) {
				lastpage = numresults / simpleBloggerConfig.getEntriesPerPage();
			} else {
				lastpage = (numresults / simpleBloggerConfig.getEntriesPerPage()) + 1;
			}
			
			// Check if page parameter has a valid value 
			if (page < 1) {
				// If not, set first page as default value
				page = 1;
			} else if (page > lastpage) {
				page = lastpage;
			}
		
	    	model.addAttribute("entries", entryInterface.findEntryEntitiesByTag(page, simpleBloggerConfig.getEntriesPerPage(), tagid));
		}
		
    	model.addAttribute("page", page);
    	model.addAttribute("lastpage", lastpage);
    	model.addAttribute("tag", tagInterface.findTag(tagid));
    	
		return new ModelAndView("entrylist", model);	
	}
	
	
	// Default method to list entries by date. No paging related parameters are passed.
	@RequestMapping(value = "/bydate/{year}/{month}", method = RequestMethod.GET)
	public ModelAndView listEntriesByDate(@PathVariable("year") int year, @PathVariable("month") int month) throws Exception {
		
		return new ModelAndView ("redirect:/app/entries/bydate/" + year + "/" + month + "/1");		
	}
	
	// Method to list paged entries by date. Paging related parameters are passed.
	@RequestMapping(value = "/bydate/{year}/{month}/{page}", method = RequestMethod.GET)
	public ModelAndView listEntriesByDate(@PathVariable("year") int year, @PathVariable("month") int month, @PathVariable("page") int page) throws Exception {	
		
		// If we pass month number to 0, we will search entries for a full year!
		// See getEntryEntitiesCountByDate & findEntryEntitiesByDate implementation for more info.
		
		// Calculate last page number
		int numresults = entryInterface.getEntryEntitiesCountByDate(year, month);
		int lastpage = 1;
		ModelMap model = new ModelMap();
		
		if (numresults > 0) {
			if (numresults % simpleBloggerConfig.getEntriesPerPage() == 0) {
				lastpage = numresults / simpleBloggerConfig.getEntriesPerPage();
			} else {
				lastpage = (numresults / simpleBloggerConfig.getEntriesPerPage()) + 1;
			}
			
			// Check if page parameter has a valid value 
			if (page < 1) {
				// If not, set first page as default value
				page = 1;
			} else if (page > lastpage) {
				page = lastpage;
			}
				
	    	model.addAttribute("entries", entryInterface.findEntryEntitiesByDate(page, simpleBloggerConfig.getEntriesPerPage(), year, month));
		}

		model.addAttribute("page", page);
    	model.addAttribute("lastpage", lastpage);
    	model.addAttribute("year", year);
    	if (month > 0 & month <= 12) {
    		model.addAttribute("month", month);
    		model.addAttribute("month_name", new DateFormatSymbols().getMonths()[month-1]);
    		model.addAttribute("month_name", new DateFormatSymbols(Locale.ENGLISH).getMonths()[month-1]);
    	}
    	
    	return new ModelAndView("entrylist", model);
	}
	
	@RequestMapping(value = "/archives", method = RequestMethod.GET)
	@ResponseBody 
	public List<String[]> tagEntryCount() throws Exception {		

		return entryInterface.findArchivesEntries();
	}	
	
}

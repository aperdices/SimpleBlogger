// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import es.isendev.blog.dao.interfaces.EntryInterface;
import es.isendev.blog.util.SimpleBloggerConfig;

@Controller
@RequestMapping("/feed")
public class NewsFeedController {
	
	// Bean Interfaces	
	@Autowired
	private EntryInterface entryInterface;
	
	@Autowired
	private SimpleBloggerConfig simpleBloggerConfig;
	
	// Default method to get a RSS Feed
	@RequestMapping(value = "/news.rss", method = RequestMethod.GET)
	public ModelAndView buildRSS() throws Exception {
		
		// Populate model with data needed by <es.isendev.blog.util.RssNewsFeedView>
		ModelMap model = new ModelMap();

		// RSS Feed Metadata
		model.addAttribute("feedTitle", simpleBloggerConfig.getBlogTitle());
		model.addAttribute("feedDesc", simpleBloggerConfig.getRssFeedDescription());
		model.addAttribute("feedLink", simpleBloggerConfig.getBlogUrl());
		model.addAttribute("feedItemsBaseURI", simpleBloggerConfig.getBlogUrl() + "/app/entry/");
		
		// RSS Feed Items
		model.addAttribute("entryItems", entryInterface.findEntryEntities(1, 10, true));
		
		// We need to map rssNewsFeedView in web-mvc-config.xml
		return new ModelAndView("rssNewsFeedView", model);		
	}	
	
}

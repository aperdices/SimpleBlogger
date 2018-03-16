// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

// import org.springframework.ui.ModelMap;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.stereotype.Controller;

@Controller
@RequestMapping("/resource")
public class ResourceController {
	
	// Bean Interfaces	
//	@Autowired
//	private ResourceInterface resourceInterface;
	
//	@Autowired
//	private SimpleBloggerConfig simpleBloggerConfig;
	
	@RequestMapping(value = "", method = RequestMethod.POST)
	public ModelAndView resourceUpload() throws Exception {
		
		return null;		
	}	
	
}

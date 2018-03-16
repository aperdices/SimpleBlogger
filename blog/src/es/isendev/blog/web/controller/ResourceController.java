// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.web.controller;

// import org.springframework.ui.ModelMap;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
@RequestMapping("/resource")
public class ResourceController {
	
	// Bean Interfaces	
//	@Autowired
//	private ResourceInterface resourceInterface;
	
//	@Autowired
//	private SimpleBloggerConfig simpleBloggerConfig;
	
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public ModelAndView fileUpload(@RequestParam("file") MultipartFile[] files, Model model) throws IOException {

       for (MultipartFile file : files) {
    	   if (!file.getOriginalFilename().isEmpty()) {
             
    		   System.out.println(">>> Filename: " + file.getOriginalFilename());
    		   
//    		 BufferedOutputStream outputStream = new BufferedOutputStream(
//                   new FileOutputStream(
//                         new File("D:/MultipleFileUpload", file.getOriginalFilename())));
//
//             outputStream.write(file.getBytes());
//             outputStream.flush();
//             outputStream.close();
             
          }
       }
       
       return new ModelAndView("resourcelist");
    }    
	
}

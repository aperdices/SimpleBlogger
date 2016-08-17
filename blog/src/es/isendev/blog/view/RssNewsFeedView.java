// (c) 2015 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.view;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.feed.AbstractRssFeedView;

import com.rometools.rome.feed.rss.Channel;
import com.rometools.rome.feed.rss.Description;
import com.rometools.rome.feed.rss.Item;

import es.isendev.blog.dao.beans.Entry;

public class RssNewsFeedView extends AbstractRssFeedView {

	@Override
	@SuppressWarnings("rawtypes")
    protected void buildFeedMetadata(Map model, Channel feed, HttpServletRequest request) {
    	
        // Get basic metadata from model map
		// See es.isendev.blog.web.controller.NewsFeedController
		feed.setTitle((String)model.get("feedTitle"));
        feed.setDescription((String)model.get("feedDesc"));
        feed.setLink((String)model.get("feedLink"));
    }
		
	@Override
	protected List<Item> buildFeedItems (Map<String, Object> model, HttpServletRequest arg1, HttpServletResponse arg2) throws Exception {

		// Get entries and base URI from model map
		// See es.isendev.blog.web.controller.NewsFeedController		
        @SuppressWarnings("unchecked")
		List<Entry> entryItems = (List<Entry>) model.get("entryItems");        
        String feedItemsBaseURI = (String) model.get("feedItemsBaseURI");
        
        List<Item> feedItems = new ArrayList<Item>();

        for (Entry entry : entryItems) {
            
        	Item feedItem = new Item();
            
        	feedItem.setTitle(entry.getTitle());
            feedItem.setAuthor(entry.getUser().getUsername());
            feedItem.setPubDate(entry.getCreationDate());
            
            Description desc = new Description();
            desc.setType("text/html");
            desc.setValue(entry.getDescription());
            feedItem.setDescription(desc);
            
            feedItem.setLink(feedItemsBaseURI + entry.getEntryId());
            
            feedItems.add(feedItem);
        }
        
        return feedItems;		
	}

}

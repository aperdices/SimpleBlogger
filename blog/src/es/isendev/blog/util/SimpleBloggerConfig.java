// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.util;

public class SimpleBloggerConfig {
	
	private String blogTitle;	
	private String blogFootMessage;
	
	private String blogUrl;
	private String rssFeedDescription;
	
	private int entriesPerPage;
	
	private String myTwitterUrl;
	private String myInstagramUrl;
	
	public String getBlogTitle() {
		return blogTitle;
	}
	
	public void setBlogTitle(String blogTitle) {
		this.blogTitle = blogTitle;
	}
	
	public String getBlogFootMessage() {
		return blogFootMessage;
	}
	
	public void setBlogFootMessage(String blogFootMessage) {
		this.blogFootMessage = blogFootMessage;
	}
	
	public String getBlogUrl() {
		return blogUrl;
	}
	
	public void setBlogUrl(String blogUrl) {
		this.blogUrl = blogUrl;
	}
	
	public String getRssFeedDescription() {
		return rssFeedDescription;
	}
	
	public void setRssFeedDescription(String rssFeedDescription) {
		this.rssFeedDescription = rssFeedDescription;
	}

	public void setEntriesPerPage(int entriesPerPage) {
		this.entriesPerPage = entriesPerPage;
	}

	public int getEntriesPerPage() {
		return entriesPerPage;
	}

	public String getMyInstagramUrl() {
		return myInstagramUrl;
	}

	public void setMyInstagramUrl(String myInstagramUrl) {
		this.myInstagramUrl = myInstagramUrl;
	}

	public String getMyTwitterUrl() {
		return myTwitterUrl;
	}

	public void setMyTwitterUrl(String myTwitterUrl) {
		this.myTwitterUrl = myTwitterUrl;
	}
	
}

// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.beans;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.GeneratedValue;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import es.isendev.blog.util.ProcessBBCode;

@Entity
@Table(name="PAGE")
public class Page implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="PAGE_ID")
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int pageId;

	@ManyToOne(targetEntity=es.isendev.blog.dao.beans.User.class, optional = false)
	@JoinColumn(name="USERNAME", referencedColumnName = "USERNAME")
	private User user;

	@Column(name="TITLE")
	private String title;
	
	@Lob
	@Column(name="BODY")
	private String body;

	@Column(name="CREATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date creationDate;

	@Column(name="MODIFICATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date modificationDate;
	
	@Column(name="MENU_ORDER")
	private int menuOrder;
	
	@Column(name="MENU_TITLE")
	private String menuTitle;
	
	@ManyToMany(targetEntity=es.isendev.blog.dao.beans.Resource.class)
	@JoinTable(joinColumns = @JoinColumn(name="PAGE_ID", referencedColumnName = "PAGE_ID"),name = "REL_PAGE_RESOURCE", inverseJoinColumns = @JoinColumn(name="RESOURCE_ID", referencedColumnName = "RESOURCE_ID"))
	private List<Resource> resources;	

	public Page() {
		super();
	}
	
	// Get body string with embedded BBCode processed	
	public String getBodyProcessed() {
		ProcessBBCode bbCodeProcessor = new ProcessBBCode();
		bbCodeProcessor.setAcceptBBCode(true);
		bbCodeProcessor.setAcceptHTML(false);
		return bbCodeProcessor.prepareEntryText(body);
	}

	public int getPageId() {
		return pageId;
	}

	public void setPageId(int pageId) {
		this.pageId = pageId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getModificationDate() {
		return modificationDate;
	}

	public void setModificationDate(Date modificationDate) {
		this.modificationDate = modificationDate;
	}

	public int getMenuOrder() {
		return menuOrder;
	}

	public void setMenuOrder(int menuOrder) {
		this.menuOrder = menuOrder;
	}

	public String getMenuTitle() {
		return menuTitle;
	}

	public void setMenuTitle(String menuTitle) {
		this.menuTitle = menuTitle;
	}
	
	public List<Resource> getResources() {
		return resources;
	}

	public void setResources(List<Resource> resources) {
		this.resources = resources;
	}
	
}

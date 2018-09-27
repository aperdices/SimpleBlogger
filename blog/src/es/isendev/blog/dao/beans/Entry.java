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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.GeneratedValue;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import es.isendev.blog.util.ProcessBBCode;

@Entity
@Table(name="ENTRY")
public class Entry implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="ENTRY_ID")
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int entryId;

	@ManyToOne(targetEntity=es.isendev.blog.dao.beans.User.class, optional = false)
	@JoinColumn(name="USERNAME", referencedColumnName = "USERNAME")
	private User user;

	@Column(name="TITLE")
	private String title;
	
	@Column(name="DESCRIPTION")
	private String description;

	@Column(name="HEADER")
	private String header;	
	
	@Column(name="BODY")
	private String body;

	@Column(name="CREATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date creationDate;

	@Column(name="MODIFICATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date modificationDate;
	
	@ManyToMany(targetEntity=es.isendev.blog.dao.beans.Tag.class)
	@JoinTable(joinColumns = @JoinColumn(name="ENTRY_ID", referencedColumnName = "ENTRY_ID"),name = "REL_ENTRY_TAG", inverseJoinColumns = @JoinColumn(name="TAG_ID", referencedColumnName = "TAG_ID"))
	private List<Tag> tags;
	
	@Column(name="PUBLISHED")
	private boolean published;

	public Entry() {
		super();
	}
	
	// Get body string with embedded BBCode processed	
	public String getBodyProcessed() {
		ProcessBBCode bbCodeProcessor = new ProcessBBCode();
		bbCodeProcessor.setAcceptBBCode(true);
		bbCodeProcessor.setAcceptHTML(false);
		return bbCodeProcessor.prepareEntryText(body);
	}
	
	// Get header string with embedded BBCode processed	
	public String getHeaderProcessed() {
		ProcessBBCode bbCodeProcessor = new ProcessBBCode();
		bbCodeProcessor.setAcceptBBCode(true);
		bbCodeProcessor.setAcceptHTML(false);
		return bbCodeProcessor.prepareEntryText(header);
	}	
	
	public int getEntryId() {
		return entryId;
	}
	
	public void setEntryId(int entryId) {
		this.entryId = entryId;
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

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}
	
	public String getHeader() {
		return header;
	}

	public void setHeader(String header) {
		this.header = header;
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

	public List<Tag> getTags() {
		return tags;
	}

	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

	public void setPublished(boolean published) {
		this.published = published;
	}

	public boolean isPublished() {
		return published;
	}

}

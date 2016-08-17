// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.beans;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="TAG")
public class Tag implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="TAG_ID")
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int tagId;
	
	@Column(name="TAGNAME")
	private String tagname;

	@Column(name="CREATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date creationDate;

	@Column(name="MODIFICATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date modificationDate;
	
	public Tag() {
		super();
	}

	public void setTagId(int tagId) {
		this.tagId = tagId;
	}

	public int getTagId() {
		return tagId;
	}	
	
	public String getTagname() {
		return tagname;
	}

	public void setTagname(String tagname) {
		this.tagname = tagname;
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
	
}

// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.implementations;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.isendev.blog.dao.beans.Tag;
import es.isendev.blog.dao.interfaces.TagInterface;

@Service
public class TagImplementation implements TagInterface {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;

	public Tag createTag() {
		Tag tag = new Tag();
		return tag;
	}
	
	@Transactional
	public Tag saveTag(Tag tag) {
		return em.merge(tag);
	}

	@Transactional
	public void deleteTag(int tagId) {
		Tag tag = em.find(Tag.class, tagId);				
    	if (tag != null) {
    		em.remove(tag);
    	}    	
    	return;
    }

	public Tag findTag(int tagId) {
		return em.find(Tag.class, tagId);
	}

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
	public List<Tag> findTagEntities() {
		Query q = em.createQuery ("SELECT OBJECT(t) FROM Tag t ORDER BY t.tagname ASC");
		List<Tag> items = q.getResultList();
		return items;
	}

	@Transactional(readOnly = true)
	public int getTagCount() {
		Query q = em.createQuery ("SELECT COUNT(t) FROM Tag t");
		Long num_results = (Long)q.getSingleResult();
		return num_results.intValue();
	}
	
	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")	
	public List<Object[]> findTagEntitiesAndEntryCount() {
		Query q = em.createQuery ("SELECT t, count(e) FROM Entry e JOIN e.tags t WHERE e.published = true GROUP BY t ORDER BY t.tagname ASC");		
		List<Object[]> result = q.getResultList();		
		return result;
	}

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
	public Tag findTagByName(String tagname) {
		Query q = em.createQuery ("SELECT OBJECT(t) FROM Tag t WHERE t.tagname  = :tagname");
		q.setParameter("tagname", tagname);
		List<Tag> items = q.getResultList();
		if (items.size() > 0) {
			return items.get(0);
		} else {
			return null;
		}
		
	}	

}

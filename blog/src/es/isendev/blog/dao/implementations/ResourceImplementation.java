// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.implementations;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.isendev.blog.dao.beans.Resource;
import es.isendev.blog.dao.interfaces.ResourceInterface;

@Service
public class ResourceImplementation implements ResourceInterface {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;

	public Resource createResource() {
		Resource resource = new Resource();
		return resource;
	}
	
	@Transactional
	public Resource saveResource(Resource resource) {
		return em.merge(resource);
	}

	@Transactional
	public void deleteResource(int resourceId) {
		Resource resource = em.find(Resource.class, resourceId);				
    	if (resource != null) {
    		em.remove(resource);
    	}    	
    	return;
    }

	public Resource findResource(int resourceId) {
		return em.find(Resource.class, resourceId);
	}

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
	public List<Resource> findResourceEntities() {
		Query q = em.createQuery ("SELECT OBJECT(r) FROM Resource r ORDER BY r.creationDate DESC");
		List<Resource> items = q.getResultList();
		return items;
	}	

}

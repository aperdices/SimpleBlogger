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

import es.isendev.blog.dao.beans.Page;

@Service
public class PageImplementation implements
		es.isendev.blog.dao.interfaces.PageInterface {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;
	
	public Page createPage() {
		Page page = new Page();		
		return page;	}

	@Transactional
	public Page savePage(Page page) {
		return em.merge(page);	}

	@Transactional
	public void deletePage(int pageId) {
		Page page = em.find(Page.class, pageId);
    	if (page != null) {    		
    		em.remove(page);
    	}
    	return;
	}

	@Transactional(readOnly = true)
	public Page findPage(int pageId) {
		return em.find(Page.class, pageId);
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<Page> findPageEntities() {
		Query q = em.createQuery ("SELECT OBJECT(p) FROM Page p ORDER BY p.menuOrder ASC");
		List<Page> items = q.getResultList();
		return items;
	}

	@Override
	public int getPageEntitiesCount() {
		Query q = em.createQuery ("SELECT COUNT(p) FROM Page p");
		Long num_results = (Long)q.getSingleResult();
		return num_results.intValue();
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<Object[]> findPageTitles() {
		Query q = em.createQuery ("SELECT p.menuTitle, p.pageId FROM Page p WHERE p.menuOrder > 0 ORDER BY p.menuOrder ASC");		
		List<Object[]> result = q.getResultList();		
		return result;
	}

}

// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.implementations;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.isendev.blog.dao.beans.User;
import es.isendev.blog.dao.interfaces.UserInterface;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

@Service
public class UserImplementation implements UserInterface {
	
	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;

	public User createUser () {
		User usuario = new User();
		return usuario;
	}
	
	@Transactional
	public void saveUser (User user) {
	  	em.merge(user);
	  	return;
	}
	
	@Transactional
	public void deleteUser (String id) {
		User user = em.find(User.class, id);
    	if (user != null) {    		
    		em.remove(user);
    	}
    	return;
	}
	
    public User findUser (String id) {    	
		return em.find(User.class, id);
    }

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
    public List<User> findUserEntities() {
		Query q = em.createQuery ("SELECT object(o) FROM User as o ORDER BY username");
		List<User> items = q.getResultList();
		return items;
    }

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")	
    public int getUserCount() {
		Query q = em.createQuery ("SELECT object(o) FROM User as o");
		List<User> items = q.getResultList();
		return items.size();
    }
	
}

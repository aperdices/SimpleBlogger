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

import es.isendev.blog.dao.beans.Folder;
import es.isendev.blog.dao.interfaces.FolderInterface;

@Service
public class FolderImplementation implements FolderInterface {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;

	public Folder createFolder() {
		Folder folder = new Folder();
		return folder;
	}
	
	@Transactional
	public Folder saveFolder(Folder folder) {
		return em.merge(folder);
	}

	@Transactional
	public void deleteFolder(int folderId) {
		Folder folder = em.find(Folder.class, folderId);				
    	if (folder != null) {
    		em.remove(folder);
    	}    	
    	return;
    }

	public Folder findFolder(int folderId) {
		return em.find(Folder.class, folderId);
	}

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
	public List<Folder> findFolderEntities() {
		Query q = em.createQuery ("SELECT OBJECT(f) FROM Folder f ORDER BY f.name ASC");
		List<Folder> items = q.getResultList();
		return items;
	}	

}

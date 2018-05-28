// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.Resource;

public interface ResourceInterface extends Serializable {
	
	public Resource createResource();
	
	public Resource saveResource (Resource resource);
	
	public void deleteResource (int resourceId);
    
    public Resource findResource (int ResourceourceId);
    
    public List<Resource> findResourceEntities();
    
    public List<Resource> findResourceEntitiesByFolder(int folderId);
    
}

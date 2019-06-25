// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.Page;

public interface PageInterface extends Serializable {
	
	public Page createPage();
	
	public Page savePage (Page page);
	
	public void deletePage (int pageId);
    
    public Page findPage (int pageId);
    
    public List<Page> findPageEntities();

    public int getPageEntitiesCount();

	public List<Object[]> findPageTitles();

}

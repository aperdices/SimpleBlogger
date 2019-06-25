// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.Tag;

public interface TagInterface extends Serializable {
	
	public Tag createTag();
	
	public Tag saveTag (Tag tag);
	
	public void deleteTag (int tagId);
    
    public Tag findTag (int tagId);
    
    public Tag findTagByName (String tagname);

    public List<Tag> findTagEntities();

    public int getTagCount();
    
	public List<Object[]> findTagEntitiesAndEntryCount();
    
}

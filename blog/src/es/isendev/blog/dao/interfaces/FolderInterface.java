// (c) 2018 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.Folder;

public interface FolderInterface extends Serializable {
	
	public Folder createFolder();
	
	public Folder saveFolder (Folder Folder);
	
	public void deleteFolder (int folderId);
    
    public Folder findFolder (int folderId);
    
    public List<Folder> findFolderEntities();
    
}

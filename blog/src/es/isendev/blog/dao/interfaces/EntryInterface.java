// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.Entry;

public interface EntryInterface extends Serializable {
	
	public Entry createEntry();
	
	public Entry saveEntry (Entry entry);
	
	public void deleteEntry (int entryId);
    
    public Entry findEntry (int entryId);
    
    public List<Entry> findEntryEntities(int page, int maxresults, boolean published);

    public int getEntryEntitiesCount(boolean published);
          
    public List<Entry> findEntryEntitiesByTag(int page, int maxresults, int tagId);

    public int getEntryEntitiesCountByTag(int tagId);
    
    public List<String[]> findArchivesEntries();
    
    public List<Entry> findEntryEntitiesByDate(int page, int maxresults, int year, int month);
    
    public int getEntryEntitiesCountByDate(int year, int month);

}

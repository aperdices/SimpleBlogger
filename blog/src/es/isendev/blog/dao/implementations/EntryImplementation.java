// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.implementations;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.isendev.blog.dao.beans.Entry;
import es.isendev.blog.dao.interfaces.EntryInterface;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

@Service
public class EntryImplementation implements EntryInterface {
	
	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;

	public Entry createEntry () {
		Entry entry = new Entry();		
		return entry;
	}
	
	@Transactional
	public Entry saveEntry (Entry entry) {
	  	return em.merge(entry);
	}
	
	@Transactional
	public void deleteEntry (int entryId) {
		Entry entry = em.find(Entry.class, entryId);
    	if (entry != null) {    		
    		em.remove(entry);
    	}
    	return;
	}
	
    public Entry findEntry (int entryId) {    	
		return em.find(Entry.class, entryId);
    }

	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
    public List<Entry> findEntryEntities(int page, int maxresults, boolean published) {
		
		// Calculate the first result of the query.
		int firstresult = (page - 1) * maxresults;
	
		// Create the "paged" query.		
		Query q = em.createQuery ("SELECT OBJECT(e) FROM Entry e WHERE e.published = :published ORDER BY e.creationDate DESC");
		q.setParameter("published", published);
		q.setMaxResults(maxresults);
		q.setFirstResult(firstresult);
		List<Entry> items = q.getResultList();
		
		return items;
    }

	@Transactional(readOnly = true)
	public int getEntryEntitiesCount(boolean published) {		
		Query q = em.createQuery ("SELECT COUNT(e) FROM Entry e WHERE e.published = :published");
		q.setParameter("published", published);
		Long numresults = (Long)q.getSingleResult();		
		return numresults.intValue();
    }
	
	
	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
    public List<Entry> findEntryEntitiesByTag(int page, int maxresults, int tagId) {
		
		// Calculate the first result of the query.
		int firstresult = (page - 1) * maxresults;
	
		// Do the "paged" query
		Query q = em.createQuery ("SELECT OBJECT(e) FROM Entry e JOIN e.tags t WHERE t.tagId = :tId and e.published = true ORDER BY e.creationDate DESC");
		q.setParameter("tId", tagId);
		q.setMaxResults(maxresults);
		q.setFirstResult(firstresult);
		List<Entry> items = q.getResultList();
		
		return items;
    }

	@Transactional(readOnly = true)
	public int getEntryEntitiesCountByTag(int tagId) {
		Query q = em.createQuery ("SELECT COUNT(e) FROM Entry e JOIN e.tags t WHERE t.tagId = :tId and e.published = true");
		q.setParameter("tId", tagId);		
		Long numresults = (Long)q.getSingleResult();		
		return numresults.intValue();
    }
	
	@Transactional(readOnly = true)
	@SuppressWarnings({ "unchecked", "rawtypes" })	
	public List<String[]> findArchivesEntries() {
		
		// WARNING!!! NativeQuery (MySQL).
		Query q = em.createNativeQuery("SELECT DISTINCT DATE_FORMAT(CREATION_DATE,'%Y'), DATE_FORMAT(CREATION_DATE,'%M'), DATE_FORMAT(CREATION_DATE,'%m') FROM ENTRY WHERE PUBLISHED = TRUE ORDER BY CREATION_DATE DESC");
		// WARNING!!! NativeQuery (MySQL).
		
		List<Object[]> tmpresult = q.getResultList();
		
		ArrayList result = new ArrayList();
		
		for (int i = 0; i < tmpresult.size(); i++) {
			
			String[] archive_entry = new String[4];
			
			Object[] archive_entry_tmp = tmpresult.get(i);
			
			// WARNING!!! NativeQuery (MySQL).
			q = em.createNativeQuery("SELECT COUNT(*) FROM ENTRY WHERE DATE_FORMAT(CREATION_DATE,'%Y') = ? AND DATE_FORMAT(CREATION_DATE,'%M') = ? AND PUBLISHED = TRUE");
			// WARNING!!! NativeQuery (MySQL).
			
			q.setParameter(1, (String)archive_entry_tmp[0]);
			q.setParameter(2, (String)archive_entry_tmp[1]);
			
			archive_entry[0] = (String)archive_entry_tmp[0];
			archive_entry[1] = (String)archive_entry_tmp[1];
			// Substring month name (3 chars).
			archive_entry[1] = archive_entry[1].substring(0, 3);
			archive_entry[2] = (String)archive_entry_tmp[2];
			
			Long num_entries = (Long)q.getSingleResult();
			archive_entry[3] = num_entries.toString();
			
			result.add(archive_entry);

		}
		
		return result;
	}
	
	@Transactional(readOnly = true)
	@SuppressWarnings("unchecked")
    public List<Entry> findEntryEntitiesByDate(int page, int maxresults, int year, int month) {
		
		// Set query start and dates
		Calendar cal = Calendar.getInstance();
		Date startDate = null;
		Date endDate = null;

		// If month parameter is valid, then search entries for this month
		// If not, then search all entries of the year
		if (month >= 1 && month <= 12) {
			// Take care of Calendar class odd behaviour!
			// Months are numbered from 0 to 11 (days from 1 to 31).
			cal.set(year, (month - 1), 1, 0, 0, 0);
			startDate = cal.getTime();			
			cal.add(Calendar.MONTH, 1);
			cal.add(Calendar.DATE, -1);
			cal.set(Calendar.HOUR_OF_DAY, 23);
			cal.set(Calendar.MINUTE, 59);
			cal.set(Calendar.SECOND, 59);
			endDate = cal.getTime();
		} else {
			cal.set(year, Calendar.JANUARY, 1, 0, 0, 0);
			startDate = cal.getTime();
			cal.set(year, Calendar.DECEMBER, 31, 23, 59, 59);
			endDate = cal.getTime();		
		}
		
		// Calculate the first result of the query.
		int firstresult = (page - 1) * maxresults;
	
		// Do the "paged" query
		Query q = em.createQuery ("SELECT OBJECT(e) FROM Entry e WHERE e.creationDate >= :startDate and e.creationDate <= :endDate and e.published = true ORDER BY e.creationDate DESC");
		q.setParameter("startDate", startDate);
		q.setParameter("endDate", endDate);
		q.setMaxResults(maxresults);
		q.setFirstResult(firstresult);
		List<Entry> items = q.getResultList();
		
		return items;
    }

	@Transactional(readOnly = true)
	public int getEntryEntitiesCountByDate(int year, int month) {
		
		// Set query start and dates
		Calendar cal = Calendar.getInstance();
		Date startDate = null;
		Date endDate = null;

		// If month parameter is valid, then search entries for this month
		// If not, then search all entries of the year
		if (month >= 1 && month <= 12) {
			// Take care of Calendar class odd behaviour!
			// Months are numbered from 0 to 11 (days from 1 to 31).
			cal.set(year, (month - 1), 1, 0, 0, 0);
			startDate = cal.getTime();			
			cal.add(Calendar.MONTH, 1);
			cal.add(Calendar.DATE, -1);
			cal.set(Calendar.HOUR_OF_DAY, 23);
			cal.set(Calendar.MINUTE, 59);
			cal.set(Calendar.SECOND, 59);
			endDate = cal.getTime();
		} else {
			cal.set(year, Calendar.JANUARY, 1, 0, 0, 0);
			startDate = cal.getTime();
			cal.set(year, Calendar.DECEMBER, 31, 23, 59, 59);
			endDate = cal.getTime();		
		}
		
		Query q = em.createQuery ("SELECT COUNT(e) FROM Entry e WHERE e.published = true and e.creationDate >= :startDate and e.creationDate <= :endDate");
		q.setParameter("startDate", startDate);
		q.setParameter("endDate", endDate);
		Long num_results = (Long)q.getSingleResult();
		
		return num_results.intValue();
	
	}
	
}

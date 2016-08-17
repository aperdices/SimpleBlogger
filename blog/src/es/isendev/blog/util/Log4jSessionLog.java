// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.util;

import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.persistence.logging.AbstractSessionLog;
import org.eclipse.persistence.logging.SessionLog;
import org.eclipse.persistence.logging.SessionLogEntry;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

// Implements SessionLog for log4j that implements all the generic logging functions.
// It contains a singleton SessionLog that logs messages from outside any EclipseLink session.
// The singleton SessionLog can also be passed to an EclipseLink session when messages
// are logged through that session.

// The purpose of this class is allow EclipseLink be incorporated in a project which is already
// using log4j. This class enables EclipeLink to log within the already established log4j 
// framework, Appenders, etc.

// Usage of EclipseLink JPA Logging Extensions.
//
// Property: eclipselink.logging.logger
// Usage: Select the type of logger to use, this class.
//
// Property: eclipselink.logging.level 
// Usage: This property is ignored. Control the amount and detail of log output by configuring the log4j level.

public class Log4jSessionLog extends AbstractSessionLog  implements SessionLog {

	// Log4j Logger class to perform logging.
	// Must be static so only one Logger for Eclipselink is created.
	protected static Logger lg;
	
	// Map of SessionLog level ints to log4j Level objects.
	// Initialized with constant values which will not change.
	protected static  Map <Integer, Level> levelMap = new HashMap<Integer, Level>(); 

	static {
		levelMap.put(new Integer(ALL), Level.ALL);
		levelMap.put(new Integer(FINEST), Level.TRACE);
		levelMap.put(new Integer(FINER), Level.DEBUG);
		levelMap.put(new Integer(FINE), Level.DEBUG);
		levelMap.put(new Integer(CONFIG), Level.INFO);
		levelMap.put(new Integer(INFO), Level.INFO);
		levelMap.put(new Integer(WARNING), Level.WARN);
		levelMap.put(new Integer(SEVERE), Level.ERROR);
		levelMap.put(new Integer(OFF), Level.OFF);
	}
	
	// Represents the Map that stores log levels per the name space strings.
	// The keys are category names. The values are log levels.
    protected Map<String, Integer> categoryLogLevelMap = new HashMap<String, Integer>();
    
    // Log4Java Level
    Level log4jLevel;
	
	// Create a new Log4jSessionLog.
	public Log4jSessionLog () {
		
		// Instantiate Logger object for Eclipselink.
		if (lg == null) {
			lg = Logger.getLogger("eclipselink");
		}
		
		// Get log4j configured level and match it to an EclipseLink level.
		if (lg.getLevel().equals(Level.ALL)) {
			level = ALL;			
		} else if (lg.getLevel().equals(Level.TRACE)) {
			level = FINEST;			
		} else if (lg.getLevel().equals(Level.DEBUG)) {
			level = FINER;			
		} else if (lg.getLevel().equals(Level.INFO)) {
			level = INFO;			
		} else if (lg.getLevel().equals(Level.WARN)) {
			level = WARNING;			
		} else if (lg.getLevel().equals(Level.ERROR)) {
			level = SEVERE;			
		} else if (lg.getLevel().equals(Level.OFF)) {
			level = OFF;			
		} else {
			level = INFO;
		}
		
		// Create the Map of EclipseLink namespace/category and log level.
        for (int i = 0; i < loggerCatagories.length; i++) {
            String loggerCategory = loggerCatagories[i]; 
            categoryLogLevelMap.put(loggerCategory, new Integer(level));
        }        
    }

	// Return the singleton Log4jSessionLog which implements SessionLog.
	// If the singleton Log4jSessionLog does not exist a new one is created.
    public static SessionLog getLog() {
        if (defaultLog == null) {
           defaultLog = new Log4jSessionLog();
        }
        return defaultLog;
    }

	// Log a SessionLogEntry
	@Override
	public void log(SessionLogEntry entry) {		
        synchronized (this) {
			// String message = formatMessage(entry) + getSupplementDetailString(entry);
        	String message = formatMessage(entry);
			lg.log(getLog4jLevel(entry.getLevel()), message, entry.getException());
        }
	}

	// Return log4j Level for ecliselink SessionLog level integer.
	// See levelMap var for details.
	protected Level getLog4jLevel(int level) {
		Integer levelInt = new Integer(level);
		if ( levelMap.containsKey(levelInt)) {
			return levelMap.get(levelInt);
		} else {
			return Level.DEBUG;
		}
	}

	// Methods dealing with SessionLog level overridden to support
	// log level by Eclispelink category / SessionLogEntry name space
	// without referring to DefaultSessionLog.

	@Override
	public int getLevel() {
		return level;
	}
    
	@Override
	public int getLevel(String category) {
		if(categoryLogLevelMap.containsKey(category)) {
			Integer levelInteger = categoryLogLevelMap.get( category );
			return levelInteger.intValue();
		} else {
			return getLevel();
		}
	}
	
	@Override
	public void setLevel(int level) {
		this.level = level;
	}
	
	@Override
	public void setLevel(int level, String category) {
        if(category != null) {
        	if(categoryLogLevelMap.containsKey(category)) {
	            categoryLogLevelMap.put(category, level);
	        } 
        }
	}

	@Override
	public boolean shouldLog(int level) {
		return (this.level <= level);
	}

    @Override
    public boolean shouldLog(int level, String category) {
        return (getLevel(category) <= level);
    }

	// Log4j configuration and appenders control where log will be written.
	// This is dummy method for compatibility.
	@Override
	public Writer getWriter() {
		return null;
	}
	
	// Log4j appenders and configuration controls where and how
	// logs are written.  This is dummy method for compatibility.
	@Override
	public void setWriter(Writer log) {
	}

	// Log4j appender configuration determines whether date is printed, always returns false.
	@Override
	public boolean shouldPrintDate() {
		return false;
	}
	
	// Log4j configuration controls whether date is included.
	// Method has no effect, present to satisfy Abstract LogSession.
	@Override
	public void setShouldPrintDate(boolean flag) {
	}

	// Log4j appender configuration determines whether thread is printed, always returns false.
    @Override
    public boolean shouldPrintThread() {
    	return false;
    }

	// Log4j appender configuration determines whether thread is printed.
	// Method has no effect, present to satisy Abstract LogSession.
    @Override
    public void setShouldPrintThread(boolean shouldPrintThread) {
    }

}

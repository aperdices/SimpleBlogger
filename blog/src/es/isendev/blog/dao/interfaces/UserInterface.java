// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.interfaces;

import java.io.Serializable;
import java.util.List;

import es.isendev.blog.dao.beans.User;

public interface UserInterface extends Serializable {
	
	public User createUser();
	
	public void saveUser (User user);
	
	public void deleteUser (String id);
    
    public User findUser (String id);

    public List<User> findUserEntities();

    public int getUserCount();

}

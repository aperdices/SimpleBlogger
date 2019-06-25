// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.dao.beans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.ManyToMany;
import javax.persistence.JoinTable;
import javax.persistence.JoinColumn;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import static javax.persistence.FetchType.EAGER;

// We make this class to implement UserDetails interface to get Spring Security
// work with our User implementation (extends Spring Security User implementation attributes).

@Entity
@Table(name="USER")
public class User implements Serializable, UserDetails {

	private static final long serialVersionUID = 1L;
	
	// Required by Spring Security
	@Id
	@Column(name = "USERNAME")
	private String username;

	// Required by Spring Security
	@Column(name="PASSWORD")
	private String password;

	@Column(name="NAME")
	private String name;

	@Column(name="LASTNAME")
	private String lastname;
	
	@Column(name="EMAIL")
	private String email;

	@Column(name="CREATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date creationDate;

	@Column(name="MODIFICATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	private Date modificationDate;

	// We need to get the roles EAGERLY to make CustomUserDetailsService work properly.
	// When Spring Security calls getAuthorities() on this class,
	// there is not any active transaction to get lazily get the roles.
	@ManyToMany(targetEntity=es.isendev.blog.dao.beans.Role.class, fetch=EAGER)
	@JoinTable(name="REL_USER_ROLE", joinColumns = @JoinColumn(name="USERNAME", referencedColumnName = "USERNAME"), inverseJoinColumns = @JoinColumn(name="ROLE", referencedColumnName = "ROLE"))
	private List<Role> roles;
	
	// Required by Spring Security
	@Column(name="ENABLED")
	private boolean enabled;
	
	public User() {
		super();
	}

	public String getUsername() {
		return this.username;
	}

	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLastname() {
		return this.lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getModificationDate() {
		return modificationDate;
	}

	public void setModificationDate(Date modificationDate) {
		this.modificationDate = modificationDate;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public List<Role> getRoles() {
		return roles;
	}

	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	// Required by Spring Security 
	@Override
	public List<GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> list = new ArrayList<GrantedAuthority> ();
        for (Role r : this.roles) {
              list.add(new SimpleGrantedAuthority(r.getRole()));
        }
       return list;
	}

	// Required by Spring Security
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	// Required by Spring Security
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}
	
	// Required by Spring Security
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}
	
}
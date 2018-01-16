<%-- 	
	(c) 2016 Antonio Perdices.
	License: Public Domain.
	You can use this code freely and wisely in your applications.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL - Standard Tag Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- JSTL - Standard Format Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Spring Security Tag Library --%>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='security' %>

<!-- Navigation -->
<!-- <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation"> -->
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
       <div class="container">
           <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="<c:url value="/app/entries" />"><c:out value="${simpleBloggerConfig.blogTitle}" /></a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
				<li class="dropdown">
   					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><fmt:message key="blog.menu.pages"/>&nbsp;<span class="caret"></span></a>
					<ul id="pagesMenuBody" class="dropdown-menu">
						<li><a href="<c:url value="/app/entry/0/edit"/>"><fmt:message key="blog.menu.newentry"/></a></li>
						<li><a href="<c:url value="/app/page/list"/>"><fmt:message key="blog.menu.editpages"/></a></li>
						<li><a href="<c:url value="/app/tag/list"/>"><fmt:message key="blog.menu.edittags"/></a></li>
					</ul>
				</li>
                <li>
                    <a href="<c:url value="/app/page/1"/>"><fmt:message key="blog.menu.about"/></a>
                </li>
                <%--
				<security:authorize access="!hasAnyRole('ROLE_ADMIN')">
					<li>
						<a href="<c:url value="/app/login" />"><fmt:message key="blog.menu.login"/></a>
					</li>
				</security:authorize>
				--%>              
				<security:authorize access="hasAnyRole('ROLE_ADMIN')">
			        <li class="dropdown">
       					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><fmt:message key="blog.menu.edit"/>&nbsp;<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="<c:url value="/app/entry/0/edit"/>"><fmt:message key="blog.menu.newentry"/></a></li>
							<li><a href="<c:url value="/app/page/list"/>"><fmt:message key="blog.menu.editpages"/></a></li>
							<li><a href="<c:url value="/app/tag/list"/>"><fmt:message key="blog.menu.edittags"/></a></li>
							<li role="separator" class="divider"></li>
							<li><a href="<c:url value="/app/entries/unpublished"/>"><fmt:message key="blog.menu.unpublished"/></a></li>			
						</ul>
					</li>
					<%-- CRSF logout method --%>
					<li>						
						<form id="logout_form" action="<c:url value="/app/logout" />" method="post">
							<security:csrfInput />
						</form>
						<a id="logout_link" href="#"><fmt:message key="blog.menu.logout"/> (<security:authentication property="principal.name" />&nbsp;<security:authentication property="principal.lastname" />)</a>
					</li>
				</security:authorize>                
            </ul>
        </div>
        <!-- /.navbar-collapse -->
    </div>
    <!-- /.container -->
</nav>

<%--

<div class="menu">

	<ul>
	
		<li class="icon"><a href="<c:url value="/app/feed/news.rss" />"><img src="<c:url value='/imgs/feed.icon.png' />"/></a></li>

		<li class="icon"><a href="<c:out value="${simpleBloggerConfig.myInstagramUrl}" />" target="_blank"><img src="<c:url value='/imgs/instagram.icon.png' />"/></a></li>
		
		<li class="icon"><a href="<c:out value="${simpleBloggerConfig.myTwitterUrl}" />" target="_blank"><img src="<c:url value='/imgs/twitter.icon.png' />"/></a></li>

		<sec:authorize access="!hasAnyRole('ROLE_ADMIN')">
			<li><a href="<c:url value="/app/login" />"><fmt:message key="blog.menu.login"/></a></li>
		</security:authorize>
		
		<security:authorize access="hasAnyRole('ROLE_ADMIN')">
			<li>
				<a href="<c:url value="/app/logout" />"><fmt:message key="blog.menu.logout"/> (<security:authentication property="principal.name" />&nbsp;<security:authentication property="principal.lastname" />)</a>
			</li>
		</security:authorize>
		
		<li><a id="toggle_pages" href="#"><fmt:message key="blog.menu.pages"/></a></li>
		
		<li><a id="toggle_tags" href="#"><fmt:message key="blog.menu.tags"/></a></li>
		
		<li><a id="toggle_archives" href="#"><fmt:message key="blog.menu.archives"/></a></li>								
		
		<li><a href="<c:url value="/" />"><fmt:message key="blog.menu.home"/></a></li>
		
		<li class="load"><img id="load_icon" src="<c:url value='/imgs/load.icon.gif' />"/></li>
		
	</ul>
	
	<div class="clear">
	</div>	
		
</div>

<div id="expand_spacer" class="spacer"></div>

<div id="expand"><fmt:message key="blog.menu.loading"/></div>

<div id="banner">
</div>
-->

<%-- Authorized Ops DIV --%>
<%--
<security:authorize access="hasAnyRole('ROLE_ADMIN')">
	<div class="menu">
	
		<ul>
	
			<li><a href="<c:url value="/app/tag/list"/>"><fmt:message key="blog.menu.edittags"/></a></li>
			
			<li><a href="<c:url value="/app/page/list"/>"><fmt:message key="blog.menu.editpages"/></a></li>
			
			<li><a href="<c:url value="/app/entries/unpublished"/>"><fmt:message key="blog.menu.unpublished"/></a></li>			
			
			<li><a href="<c:url value="/app/entry/0/edit"/>"><fmt:message key="blog.menu.newentry"/></a></li>
			
		</ul>
		
		<div class="clear">
		</div>	
			
	</div>
</security:authorize>
--%>
<%-- 	
	(c) 2016 Antonio Perdices.
	License: Public Domain.
	You can use this code freely and wisely in your applications.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL - Standard Format Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="row">

	<div class="col-md-2"></div>

	<div class="col-md-8">
		<!-- Tag Panel -->
		
		<div class="panel panel-default">
		  <div class="panel-heading"><fmt:message key="blog.menu.tags"/></div>
		  <div id="tagsPanelBody" class="panel-body"></div>
		</div>
		
		<!-- Archive Panel -->
		
		<div class="panel panel-default">
		  <div class="panel-heading"><fmt:message key="blog.menu.archive"/></div>
		  <div id="archivesPanelBody" class="panel-body"></div>
		</div>
	</div>

	<div class="col-md-2"></div>

</div>
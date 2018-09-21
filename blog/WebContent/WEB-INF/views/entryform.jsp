<%-- 	
	(c) 2018 Antonio Perdices.
	License: Public Domain.
	You can use this code freely and wisely in your applications.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL - Standard Tag Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- JSTL - Standard Format Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Spring Security Form Tag Library --%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- Spring Security Tag Library --%>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='security' %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/templates/head.jsp" />

<body>

	<jsp:include page="/WEB-INF/views/templates/top.jsp" />
	
    <%--  Page Content --%>
    <div class="container">
    
        <div class="row">

            <%--  Blog Entries Column --%>
            <div class="col-md-2"></div>
            <div class="col-md-8">
            
	            <h2><fmt:message key="blog.entryform.title"/></h2>
	
				<div class="vertical-spacing-wrapper">
	
					<form:form name="entryForm" modelAttribute="entry" action="save">
		
				    	<form:hidden path="entryId" />
				    	
				    	<security:csrfInput />
				    
					    <%--
							The submitted username id string needs to be processed with a custom editor registered
							in the controller´s InitBinder method to be converted back to a User Object.
						--%>
					    <input type="hidden" name="user" value="${entry.user.username}">
				    	
				    	<div class="form-group">
					    	<form:label path="title"><fmt:message key="blog.entryform.label.title"/></form:label>
					    	<form:input class="form-control" path="title"/>
					    	<p><span class="label label-danger"><form:errors path="title"/></span></p>
				    	</div>
				    	
				    	<div class="form-group">
					    	<form:label path="description"><fmt:message key="blog.entryform.label.description"/></form:label>
					    	<form:textarea class="form-control" path="description"/>
					    	<p><span class="label label-danger"><form:errors path="description"/></span></p>
						</div>
	
						<div class="checkbox">
							<form:label path="published"><form:checkbox path="published"/>&nbsp;<fmt:message key="blog.entryform.label.published"/></form:label>
							<p><form:errors path="published"/></p>
						</div>
					        	
						<%--
							The submitted date formatted string needs to be processed with a custom editor registered
							in the controller´s InitBinder method to be converted back to a Date Object.
						--%>
						
						<div class="form-group">
					    	<form:label path="creationDate"><fmt:message key="blog.entryform.label.creationdate"/></form:label>
							<%-- HTML5 datetime-local field uses RFC3339 date formatting --%>
							<input class="form-control" type="datetime-local" name="creationDate" id="creationDate" value="<fmt:formatDate type="both" pattern="yyyy-MM-dd'T'HH:mm" value="${entry.creationDate}"/>" required="required">
					    	<p><span class="label label-danger"><form:errors path="creationDate"/></span></p>
						</div>
	
						<div class="form-group">
							<form:label path="body"><fmt:message key="blog.entryform.label.body"/></form:label>
							<p>
								<a href="javascript:insertAtCursor('body', '[b][/b]')"><span class="label label-info"><fmt:message key="blog.form.editor.bold"/></span></a>
								<a href="javascript:insertAtCursor('body', '[i][/i]')"><span class="label label-info"><fmt:message key="blog.form.editor.italic"/></span></a>
								<a href="javascript:insertAtCursor('body', '[u][/u]')"><span class="label label-info"><fmt:message key="blog.form.editor.underline"/></span></a>
								<a href="javascript:insertAtCursor('body', '[size=\'\'][/size]')"><span class="label label-info"><fmt:message key="blog.form.editor.size"/></span></a>
								<a href="javascript:insertAtCursor('body', '[color=\'blue\'][/color]')"><span class="label label-info"><fmt:message key="blog.form.editor.color"/></span></a>
								<a href="javascript:insertAtCursor('body', '[code][/code]')"><span class="label label-info"><fmt:message key="blog.form.editor.code"/></span></a>
								<a href="javascript:insertAtCursor('body', '[quote][/quote]')"><span class="label label-info"><fmt:message key="blog.form.editor.quote"/></span></a>
								<a href="javascript:insertAtCursor('body', '[quote=\'user\'][/quote]')"><span class="label label-info"><fmt:message key="blog.form.editor.quoteuser"/></span></a>
								<a href="javascript:insertAtCursor('body', '[url][/url]')"><span class="label label-info"><fmt:message key="blog.form.editor.url"/></span></a>
								<a href="javascript:insertAtCursor('body', '[url=\'http://\'][/url]')"><span class="label label-info"><fmt:message key="blog.form.editor.namedurl"/></span></a>
								<a href="javascript:insertAtCursor('body', '[list][*]\n[*]\n[*][/list]')"><span class="label label-info"><fmt:message key="blog.form.editor.list"/></span></a>
								<a href="javascript:insertAtCursor('body', '[list=\'1\'][*]\n[*]\n[*][/list]')"><span class="label label-info"><fmt:message key="blog.form.editor.numberedlist"/></span></a>
								<a href="javascript:insertAtCursor('body', '[img]http://[/img]')"><span class="label label-info"><fmt:message key="blog.form.editor.image"/></span></a>
								<a href="javascript:insertAtCursor('body', '[img=\'http://\']title[/img]')"><span class="label label-info"><fmt:message key="blog.form.editor.titledimage"/></span></a>
								<a href="javascript:insertAtCursor('body', '[carousel][*]\n[*]\n[*][/carousel]')"><span class="label label-info"><fmt:message key="blog.form.editor.carousel"/></span></a>
								<a href="javascript:insertAtCursor('body', '[youtube]videoId[/youtube]')"><span class="label label-info"><fmt:message key="blog.form.editor.youtube"/></span></a>
							</p>
							<form:textarea class="form-control textarea_bigger" path="body"/>
							<p><span class="label label-danger"><form:errors path="body"/></span></p>				
					 	</div>
					 				
						<%--
							The submitted tagname array string needs to be processed with a custom editor registered
							in the controller´s InitBinder method to be converted back to a Tag Object.
						--%>
						<div class="form-group">
							<form:label path="tags"><fmt:message key="blog.entryform.label.tags"/></form:label>
							<form:select class="form-control" path="tags" multiple="true" items="${tagList}" itemLabel="tagname" itemValue="tagname" />
							<p><span class="label label-danger"><form:errors path="tags"/></span></p>					
						</div>
						
						<div class="pull-right">
							<button id="cancelButton" type="button" class="btn btn-default" onclick="location.href='<c:url value="/app/entries" />';"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span> <fmt:message key="blog.form.button.cancel"/></button>
							<button id="saveButton" type="submit" class="btn btn-default"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> <fmt:message key="blog.form.button.save"/></button>
		 				</div>
		
					</form:form>            
	            
	            </div>
            
			</div>
			<div class="col-md-2"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
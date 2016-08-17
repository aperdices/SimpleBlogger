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
            <div class="col-md-1"></div>
            <div class="col-md-10">
            
            <h2><fmt:message key="blog.pageform.title"/></h2>
            
            <div class="vertical-spacing-wrapper">

				<form:form name="pageForm" modelAttribute="page" action="save">
				
		    		<form:hidden path="pageId" />
		    		
		    		<security:csrfInput />

				    <%--
						The submitted username id string needs to be processed with a custom editor registered
						in the controller´s InitBinder method to be converted back to a User Object.
					--%>
				    <input type="hidden" name="user" value="${page.user.username}">

				    <%--
						The submitted date formatted string needs to be processed with a custom editor registered
						in the controller´s InitBinder method to be converted back to a Date Object.
					--%>
					<%--
						Creation date will not be directly edited by the user.
					--%>
				    <input type="hidden" name="creationDate" value="<fmt:formatDate type="both" pattern="MM/dd/yyyy kk:mm" value="${page.creationDate}" />">

			    	<div class="form-group">
				    	<form:label path="title"><fmt:message key="blog.pageform.label.title"/></form:label>
				    	<form:input class="form-control" path="title"/>
				    	<p><span class="label label-danger"><form:errors path="title"/></span></p>
			    	</div>

			    	<div class="form-group">
				    	<form:label path="menuTitle"><fmt:message key="blog.pageform.label.menutitle"/></form:label>
				    	<form:input class="form-control" path="menuTitle"/>
				    	<p><span class="label label-danger"><form:errors path="menuTitle"/></span></p>
			    	</div>

			    	<div class="form-group">
				    	<form:label path="menuOrder"><fmt:message key="blog.pageform.label.menuorder"/></form:label>
				    	<form:input class="form-control" path="menuOrder"/>
				    	<p><span class="label label-danger"><form:errors path="menuOrder"/></span></p>
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
							<a href="javascript:insertAtCursor('body', '[youtube]videoId[/youtube]')"><span class="label label-info"><fmt:message key="blog.form.editor.youtube"/></span></a>
						</p>
						<form:textarea class="form-control textarea_bigger" path="body"/>
						<p><span class="label label-danger"><form:errors path="body"/></span></p>				
				 	</div>			    	

					<div class="pull-right">
						<button id="cancelButton" type="button" class="btn btn-default" onclick="location.href='<c:url value="/app/page/list" />';"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span> <fmt:message key="blog.form.button.cancel"/></button>
						<button id="saveButton" type="submit" class="btn btn-default"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> <fmt:message key="blog.form.button.save"/></button>
	 				</div>

				</form:form>
			
			</div>
			
			</div>
			<div class="col-md-1"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
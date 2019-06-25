<%-- 	
	(c) 2019 Antonio Perdices.
	License: Public Domain.
	You can use this code freely and wisely in your applications.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL - Standard Tag Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- JSTL - Standard Function Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- JSTL - Standard Format Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Spring Security Tag Library --%>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='security' %>

<%-- Spring Framework Tag Library --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

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
				
				<c:choose>
		
					<c:when test="${not empty page}">
					
						<%-- Title --%>
		                <h2><c:out value="${page.title}"/></h2>
		                
		                <%-- Last Update --%>
		                <p>
	        	        	<span class="glyphicon glyphicon-time"></span>&nbsp;<fmt:message key="blog.pages.label.lastupdated"/> <fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${page.modificationDate}" />.
		                </p>	                
	
						<%-- Content --%>
						<div class="vertical-spacing-wrapper">							
							<c:out value="${page.bodyProcessed}" escapeXml="false"/>
						</div>
						
						<%-- Commands --%>
						<p class="text-right">
							<security:authorize access="hasAnyRole('ROLE_ADMIN')">
								<a href="<c:url value="/app/page/" /><c:out value="${page.pageId}/edit"/>"><span class="glyphicon glyphicon-pencil"></span>&nbsp;<fmt:message key="blog.entry.edit"/></a>
								<a href="<c:url value="/app/page/" /><c:out value="${page.pageId}/delete"/>" onclick="return confirm('<fmt:message key="blog.pages.delete.confirm"/>')">&nbsp;<span class="glyphicon glyphicon-remove"></span>&nbsp;<fmt:message key="blog.pages.delete"/></a>
							</security:authorize>
							<c:choose>
								<c:when test="${page.menuOrder > 0}">
									<a href="#" class="twitter" onclick="return twitterShare ('<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/page/${page.pageId}"/>')">&nbsp;<span class="glyphicon glyphicon-share"></span>&nbsp;<fmt:message key="blog.pages.twitter"/></a>
									<a href="#" class="facebook" onclick="return facebookShare ('<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/page/${page.pageId}"/>', '<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/imgs/fblogo.gif"/>', '<spring:message text="${entry.title}" javaScriptEscape="true"/>', '<c:out value="${simpleBloggerConfig.blogTitle}" />', '<spring:message text="${page.title}" javaScriptEscape="true"/>', 'http://www.facebook.com')">&nbsp;<span class="glyphicon glyphicon-share"></span>&nbsp;<fmt:message key="blog.pages.facebook"/></a>
									<a href="<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/page/${page.pageId}"/>" class="permalink"  rel="bookmark" title="<spring:message text="${page.title}" javaScriptEscape="true"/>">&nbsp;<span class="glyphicon glyphicon-link"></span>&nbsp;<fmt:message key="blog.pages.permalink"/></a>
								</c:when>
							</c:choose>							
						</p>					
					
					</c:when>
					<c:otherwise>
					
						<h4><span class="label label-warning"><fmt:message key="blog.pages.nopages"/>.</span></h4>
						
					</c:otherwise>
			
				</c:choose>
		
			</div>
			<div class="col-md-2"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
<%-- 	
	(c) 2018 Antonio Perdices.
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
            
               	<%-- Tag Filter DIV --%>
				<c:if test="${not empty tag}">		
					<h4><span class="label label-primary"><fmt:message key="blog.entries.bytag"/> <c:out value="${tag.tagname}" /></span></h4>
				</c:if>
				
				<%-- Unpublished Filter DIV --%>
				<c:if test="${not empty unpublished}">
					<h4><span class="label label-primary"><fmt:message key="blog.entries.onlyunpublished"/></span></h4>
				</c:if>
				
				<%-- Date Filter DIV --%>
				<c:if test="${not empty year and not empty month_name}">
					<h4><span class="label label-primary"><fmt:message key="blog.entries.bydate"/> <c:out value="${year}" /> / <c:out value="${month_name}" /></span></h4>
				</c:if>
	 
				<%-- ENTRIES Loop --%>
				<c:choose>		
					<c:when test="${fn:length(entries) > 0}">
						<c:forEach items="${entries}" var="entry">
							
							<%-- Title --%>
			                <h2>
			                    <c:out value="${entry.title}"/>
			                </h2>
			                
			                <%-- Author --%>
			                
	            				<c:choose>
									<c:when test="${entry.published}">
										<p class="lead">
											<fmt:message key="blog.entry.username"/> <c:out value="${entry.user.username}"/>.
										<p>
									</c:when>
									<c:otherwise>
										<p><span class="label label-info">
											<fmt:message key="blog.entry.notpublished"/>
										</span></p>
									</c:otherwise>
								</c:choose>
			                
			                <%-- Date --%>
			                <p>
			                	<span class="glyphicon glyphicon-time"></span>&nbsp;<fmt:message key="blog.entry.creationDate"/> <fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${entry.creationDate}" />.
			                </p>
			                
			                <%-- Tags --%>
			                <c:if test="${not empty entry.tags}">
				                <p>
				                	<span class="glyphicon glyphicon-tags"></span>&nbsp;<fmt:message key="blog.entry.tags"/>
									<c:forEach items="${entry.tags}" var="current_tag" varStatus="status">
										<a href="<c:url value="/app/entries/bytag/"/><c:out value="${current_tag.tagId}"/>"><c:out value="${current_tag.tagname}"/></a><c:choose><c:when test='${status.last}'>.</c:when><c:otherwise>,</c:otherwise></c:choose>									
									</c:forEach>
				                </p>
			                </c:if>
			                
			                <%-- <hr> --%>
							
							<%-- Content --%>
							<div class="vertical-spacing-wrapper">							
								<c:out value="${entry.bodyProcessed}" escapeXml="false"/>
								<%-- <a class="btn btn-primary" href="#">Read More <span class="glyphicon glyphicon-chevron-right"></span></a> --%>
							</div>
			                
							<%-- Commands --%>
							<p class="text-right">
								<security:authorize access="hasAnyRole('ROLE_ADMIN')">
									<a href="<c:url value="/app/entry/" /><c:out value="${entry.entryId}/edit"/>"><span class="glyphicon glyphicon-pencil"></span>&nbsp;<fmt:message key="blog.entry.edit"/></a>
									<a href="<c:url value="/app/entry/" /><c:out value="${entry.entryId}/delete"/>" onclick="return confirm('<fmt:message key="blog.entry.delete.confirm"/>')">&nbsp;<span class="glyphicon glyphicon-remove"></span>&nbsp;<fmt:message key="blog.entry.delete"/></a>
									<c:choose>
										<c:when test="${entry.published}">
											<a href="<c:url value="/app/entry/" /><c:out value="${entry.entryId}/unpublish"/>" onclick="return confirm('<fmt:message key="blog.entry.unpublish.confirm"/>')">&nbsp;<span class="glyphicon glyphicon-eye-close"></span>&nbsp;<fmt:message key="blog.entry.unpublish"/></a>
										</c:when>
										<c:otherwise>
											<a href="<c:url value="/app/entry/" /><c:out value="${entry.entryId}/publish"/>" onclick="return confirm('<fmt:message key="blog.entry.publish.confirm"/>')">&nbsp;<span class="glyphicon glyphicon-eye-open"></span>&nbsp;<fmt:message key="blog.entry.publish"/></a>
										</c:otherwise>
									</c:choose>
								</security:authorize>
								<c:choose>
									<c:when test="${entry.published}">
										<!-- <a href="#" class="twitter" onclick="return twitterShare ('<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/entry/${entry.entryId}"/>')">&nbsp;<span class="glyphicon glyphicon-share"></span>&nbsp;<fmt:message key="blog.entry.twitter"/></a> -->
										<!-- <a href="#" class="facebook" onclick="return facebookShare ('<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/entry/${entry.entryId}"/>', '<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/imgs/fblogo.gif"/>', '<spring:message text="${entry.title}" javaScriptEscape="true"/>', '<c:out value="${simpleBloggerConfig.blogTitle}" />', '<spring:message text="${entry.description}" javaScriptEscape="true"/>', 'http://www.facebook.com')">&nbsp;<span class="glyphicon glyphicon-share"></span>&nbsp;<fmt:message key="blog.entry.facebook"/></a> -->
										<a href="<c:out value="${simpleBloggerConfig.blogUrl}" /><c:url value="/app/entry/${entry.entryId}"/>" class="permalink"  rel="bookmark" title="<spring:message text="${entry.title}" javaScriptEscape="true"/>">&nbsp;<span class="glyphicon glyphicon-link"></span>&nbsp;<fmt:message key="blog.entry.permalink"/></a>
									</c:when>
								</c:choose>							
							</p>
							
			                <hr>
			                
						</c:forEach>
					</c:when>
					<c:otherwise>
					
						<h4><span class="label label-warning"><fmt:message key="blog.entries.noentries"/></span></h4>
						
					</c:otherwise>
				</c:choose>
				
			<%-- Paging --%>
            <ul class="pager">
                <li class="previous">
					<c:choose>
				   		<c:when test="${not empty tag and page > 1}">
				   			<a href="<c:url value="/app/entries/bytag/"/><c:out value="${tag.tagId}/"/><c:out value="${page - 1}"/>"><fmt:message key="blog.paging.prev"/></a>
				   		</c:when>
				   		<c:when test="${not empty unpublished and page > 1}">
				   			<a href="<c:url value="/app/entries/unpublished/"/><c:out value="${page - 1}"/>"><fmt:message key="blog.paging.prev"/></a>
				   		</c:when>
						<c:when test="${not empty month and not empty year and page > 1}">
				   			<a href="<c:url value="/app/entries/bydate/"/><c:out value="${year}"/>/<c:out value="${month}"/>/<c:out value="${page - 1}"/>"><fmt:message key="blog.paging.prev"/></a>
				   		</c:when>		   		
				   		<c:when test="${empty tag and empty unpublished and empty year and empty month and page > 1}">
				   			<a href="<c:url value="/app/entries/"/><c:out value="${page - 1}"/>"><fmt:message key="blog.paging.prev"/></a>
				   		</c:when>		   		
					</c:choose>
                </li>
				<%--
				<c:if test="${lastpage > 1}">						
					<fmt:message key="blog.paging.page"/> <c:out value="${page}" />
				</c:if>			
				--%>                
                <li class="next">
					<c:choose>
					   		<c:when test="${not empty tag and page < lastpage}">
					   			<a href="<c:url value="/app/entries/bytag/"/><c:out value="${tag.tagId}/"/><c:out value="${page + 1}"/>"><fmt:message key="blog.paging.next"/></a>
					   		</c:when>			
					   		<c:when test="${not empty unpublished and page < lastpage}">
					   			<a href="<c:url value="/app/entries/unpublished/"/><c:out value="${page + 1}"/>"><fmt:message key="blog.paging.next"/></a>
					   		</c:when>
					   		<c:when test="${not empty year and not empty month and page < lastpage}">
					   			<a href="<c:url value="/app/entries/bydate/"/><c:out value="${year}"/>/<c:out value="${month}"/>/<c:out value="${page + 1}"/>"><fmt:message key="blog.paging.next"/></a>
					   		</c:when>
					   		<c:when test="${empty tag and empty unpublished and empty year and empty month and page < lastpage}">
					   			<a href="<c:url value="/app/entries/"/><c:out value="${page + 1}"/>"><fmt:message key="blog.paging.next"/></a>
					   		</c:when>
					</c:choose>
                </li>
            </ul>			
			
			</div>
			<div class="col-md-2"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/panels.jsp" />
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
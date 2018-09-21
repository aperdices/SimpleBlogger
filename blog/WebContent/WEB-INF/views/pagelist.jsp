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

<%-- JSTL - Standard Function Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
		
				<h2><fmt:message key="blog.pages.title"/></h2>
				
				<div class="pull-right">
					<button id="submit" type="submit" class="btn btn-default pull-right" onclick="location.href='<c:url value="/app/page/0/edit" />';"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <fmt:message key="blog.pages.addpage"/></button>
				</div>
		
				<table class="table table-hover table-striped">
				    <thead>
				    	<tr>
				        	<th class="text-center"><fmt:message key="blog.pages.label.title"/></th>
				        	<th class="text-center"><fmt:message key="blog.pages.label.order"/></th>
				            <th class="text-center"><fmt:message key="blog.pages.label.created"/></th>
				            <th class="text-center"><fmt:message key="blog.pages.label.modified"/></th>
				            <th>&nbsp;</th>
				        </tr>
				    </thead>
				    <tbody>
						<c:choose>		
							<c:when test="${fn:length(pages) > 0}">
								<c:forEach items="${pages}" var="page" varStatus="rowNumber">
									<tr>
										<td>
											<a href="<c:url value="/app/page/" /><c:out value="${page.pageId}"/>"><c:out value="${page.title}"/></a>
										</td>
										<td class="text-center"><c:out value="${page.menuOrder}"/></td>
										<td class="text-center"><fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${page.creationDate}" /></td>
										<td class="text-center"><fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${page.modificationDate}" /></td>
										<td class="text-right">									
											<button id="submit" type="submit" class="btn btn-default" onclick="if (window.confirm('<fmt:message key="blog.pages.delete.confirm"/>')) {location.href='<c:url value="/app/page/" /><c:out value="${page.pageId}/delete"/>'}"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> <fmt:message key="blog.pages.delete"/></button>
											<button id="submit" type="submit" class="btn btn-default" onclick="location.href='<c:url value="/app/page/" /><c:out value="${page.pageId}/edit"/>'"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> <fmt:message key="blog.pages.edit"/></button>
										</td>
									</tr>								
								</c:forEach>
							</c:when>				
							<c:otherwise>
								<tr>
									<td><fmt:message key="blog.pages.nopages"/></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>							
							</c:otherwise>
						</c:choose>				    
				    </tbody>
				</table>
	
			</div>
			<div class="col-md-2"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
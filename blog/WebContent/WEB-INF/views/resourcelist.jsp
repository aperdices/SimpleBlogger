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

	<script type="text/javascript">
	
	var back_to_folderlist = function () {
		newUrl = '<c:url value="/app/folder/list"/>';
		window.location.href = newUrl;
	}	
	
// 	var open_modal_edit = function (folderId, name) {
// 		$('#modalerrormsg').hide();
// 		$("#foldernameInputText").val(name);
// 		$("#folderIdInputHidden").val(folderId);
// 		$('#addFolderModal').modal('show');
// 	};

// 	$(document).ready(function() {
// 		$('#addFolderModalForm').submit(function(event) {
// 			event.preventDefault();
// 			save_folder();
// 		});	
// 		$('#modalerrormsg').hide();
// 		loadRemoteData();
// 	});
	
	</script>
	
	<jsp:include page="/WEB-INF/views/templates/top.jsp" />
	
    <%--  Page Content --%>
    <div class="container">
    
        <div class="row">

            <%--  Blog Entries Column --%>
            <div class="col-md-1"></div>

            <div class="col-md-10">	

				<h2><fmt:message key="blog.resources.title"/> &lt;<c:out value="${folder.name}" />&gt;</h2>

				<div class="pull-right">
					<button id="submit" type="button" class="btn btn-default" onClick="back_to_folderlist();"><span class="glyphicon glyphicon-level-up" aria-hidden="true"></span>&nbsp;<fmt:message key="blog.resources.back"/></button>
				</div>
				
				<table class="table table-hover table-striped">
				    <thead>
				    	<tr>
				        	<th class="text-center"><fmt:message key="blog.resources.label.resourcename"/></th>
				        	<th class="text-center"><fmt:message key="blog.resources.label.created"/></th>
				            <th>&nbsp;</th>
				        </tr>
				    </thead>
				    <tbody>
						<c:choose>		
							<c:when test="${fn:length(folder.resources) > 0}">
								<c:forEach items="${folder.resources}" var="resource" varStatus="rowNumber">
									<tr>
<!-- 										<td> -->
<%-- 											<a href="<c:url value="/app/page/" /><c:out value="${page.pageId}"/>"><c:out value="${page.title}"/></a> --%>
<!-- 										</td> -->
<%-- 										<td class="text-center"><c:out value="${page.menuOrder}"/></td> --%>
<%-- 										<td class="text-center"><fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${page.creationDate}" /></td> --%>
<%-- 										<td class="text-center"><fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${page.modificationDate}" /></td> --%>
<!-- 										<td class="text-right">									 -->
<%-- 											<button id="submit" type="submit" class="btn btn-default" onclick="if (window.confirm('<fmt:message key="blog.pages.delete.confirm"/>')) {location.href='<c:url value="/app/page/" /><c:out value="${page.pageId}/delete"/>'}"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> <fmt:message key="blog.pages.delete"/></button> --%>
<%-- 											<button id="submit" type="submit" class="btn btn-default" onclick="location.href='<c:url value="/app/page/" /><c:out value="${page.pageId}/edit"/>'"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> <fmt:message key="blog.pages.edit"/></button> --%>
<!-- 										</td> -->
									</tr>								
								</c:forEach>
							</c:when>				
							<c:otherwise>
								<tr>
									<td><fmt:message key="blog.resources.noresources"/></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>							
							</c:otherwise>
						</c:choose>						    				    
				    </tbody>
				</table>
				
				<div>
<!-- 					<div id="uploads"></div> -->
<!-- 					<div id="filename"></div> -->
<!-- 					<div id="progress"></div> -->
<!-- 					<div id="progressBar"></div>					 -->
					<label class="btn btn-default">
    					<span class="glyphicon glyphicon-open-file" aria-hidden="true"></span>&nbsp;<fmt:message key="blog.resources.upload"/><input type="file" name="file" multiple hidden>
					</label>
					
				</div>				
				
			</div>
			
			<div class="col-md-1"></div>
				
		</div>
				
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
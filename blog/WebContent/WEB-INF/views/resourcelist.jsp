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
	
		$(document).ready(function() {

			$.ajaxSetup({
	            headers: {
	                "X-CSRF-TOKEN": '<c:out value="${_csrf.token}"/>'
	            }
			});
			
			$('input[type=file]').change(function(){

				$(this).simpleUpload('<c:url value="/app/resource/upload"/>', {
					
					allowedExts: ["jpg", "jpeg", "png", "gif"],
					allowedTypes: ["image/pjpeg", "image/jpeg", "image/png", "image/x-png", "image/gif", "image/x-gif"],
					maxFileSize: 5242880,
					data: {
			            'folderId': '<c:out value="${folder.folderId}"/>'
			        },
					
					/*
					 * Each of these callbacks are executed for each file.
					 * To add callbacks that are executed only once, see init() and finish().
					 *
					 * "this" is an object that can carry data between callbacks for each file.
					 * Data related to the upload is stored in this.upload.
					 */

					start: function(file) {
						$('.progress-bar').css('width', '0%').attr('aria-valuenow', 0);

						
						// 						//upload started
// 						this.block = $('<div class="block"></div>');
// 						this.progressBar = $('<div class="progressBar"></div>');
// 						this.block.append(this.progressBar);
// 						$('#uploads').append(this.block);
					},

					progress: function(progress){
						$('.progress-bar').css('width', progress + "%").attr('aria-valuenow', progress);
						
// 						//received progress
// 						this.progressBar.width(progress + "%");
					}

// 					success: function(data){
// 						//upload successful

// 						this.progressBar.remove();

// 						/*
// 						 * Just because the success callback is called doesn't mean your
// 						 * application logic was successful, so check application success.
// 						 *
// 						 * Data as returned by the server on...
// 						 * success:	{"success":true,"format":"..."}
// 						 * error:	{"success":false,"error":{"code":1,"message":"..."}}
// 						 */

// 						if (data.success) {
// 							//now fill the block with the format of the uploaded file
// 							var format = data.format;
// 							var formatDiv = $('<div class="format"></div>').text(format);
// 							this.block.append(formatDiv);
// 						} else {
// 							//our application returned an error
// 							var error = data.error.message;
// 							var errorDiv = $('<div class="error"></div>').text(error);
// 							this.block.append(errorDiv);
// 						}

// 					},

// 					error: function(error){
// 						//upload failed
// 						this.progressBar.remove();
// 						var error = error.message;
// 						var errorDiv = $('<div class="error"></div>').text(error);
// 						this.block.append(errorDiv);
// 					}

				});

			});

		});	
	
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
					
					<div class="progress">
					  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
					    <span class="sr-only">0% Complete</span>
					  </div>
					</div>

					<form:form name="pageForm" modelAttribute="page" action="save">						    		
		    			<security:csrfInput />
						<label class="btn btn-default">
	    					<span class="glyphicon glyphicon-open-file" aria-hidden="true"></span>&nbsp;<fmt:message key="blog.resources.upload"/><input type="file" name="file" multiple hidden>
						</label>
					</form:form>
					
				</div>				
				
			</div>
			
			<div class="col-md-1"></div>
				
		</div>
				
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
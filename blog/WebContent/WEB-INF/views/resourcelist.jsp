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

		var delete_resource = function () {
			deleteUrl = '<c:url value="/app/resource/delete"/>',
			deleteParams = {
			    resourceId: $("#resourceIdInputHidden").val()
		  	};
			$.getJSON(deleteUrl, deleteParams, function(data) {
				console.log("JSON data query success.");
				location.reload();
			});
		};
		
		var open_modal_delete = function (resourceId, name) {
			$("#resourceIdInputHidden").val(resourceId);
			$("#deleteResourceModalTitle").text('<fmt:message key="blog.resources.modal.delete"/>' + ' "' + name + '"')
			$('#deleteResourceModal').modal('show');
		};		
		
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
					
					// init: function (total_uploads)
					// Called when an upload instance is initialized. It is only called once. Returning
					// false in this callback will cancel all uploads for the instance. Returning an
					// integer will define a new limit for the max number of files to upload. All uploads
					// after the new limit will be considered cancelled. However, the cancel callback will
					// not be called.
					
					// total_uploads: (int) The total number of files that are going to be uploaded. 
					
			        init: function (total_uploads) {
						$("#uploadmsgs").empty();
						console.log("Uploading " + total_uploads + " file/s.");
					},
										
					// finish: function ()
					// Called after all file uploads for this instance have completed. It is only called once.
					// This callback may be useful if, for example, you want to re-enable the original file
					// input after it was disabled in the init callback to prevent more files from being
					// uploaded simultaneously.
					
					finish: function () {
						setTimeout(function(){
						    location.reload();
						},2500);
					},

					// Each of these callbacks are executed for each file.
					// To add callbacks that are executed only once, see init() and finish().
					
					// "this" is an object that can carry data between callbacks for each file.
					// Data related to the upload is stored in this.upload.
					
					// start: function (file) {}					
					// Called for each file at the start of each upload. Returning false in this
					// callback will cancel the current upload. However, the cancel callback will
					// not be called. The upload process is not actually started until this
					// callback has completed.
					
					// file: (obj) The file which is going to be uploaded. Included in file is:
					// name: filename of the file
					// size: the size of the file in bytes (only if HTML5)
					// type: the MIME type of the file or "" if it cannot be determined (only if HTML5)					
					
					start: function (file) {
						console.log("Starting upload of file <" + file.name + ">");
						$("#uploadpb").css('width', '0%').attr('aria-valuenow', 0);
					},

					// progress: function (progress)
					// Called for each file when its upload progress has been updated. Note that this
					// callback will not be called during an upload for pre-HTML5 browsers, since
					// client-side upload progress can only be achieved in HTML5 browsers. When an upload
					// is successful, however, this callback will be called with a value of 100 just
					// before the success callback, for older browsers.

					// progress: (float) The current progress of an upload, from 0-100. 
					
					progress: function (progress)  {
						$("#uploadpb").css('width', progress + "%").attr('aria-valuenow', progress);
					},
					
					// success: function (data)
					// Called for each file after it has uploaded successfully. For newer browsers, a successful
					// upload is triggered only when the server returns with an HTTP status code of 200
					// and the outputted data can be parsed in accordance with the expect setting. In older
					// browsers, the HTTP status code is ignored. A successful upload is only triggered by
					// valid output that can be parsed. Given this, it is recommended that you pass application
					// errors resulting from your backend script through your output instead of using HTTP status
					// codes. In your success callback, you would simply check for those errors upon completion.
					// This will ensure your application is completely backwards-compatible.
					
					// data: (varied) The data returned from the server, either as an object or string, as
					// determined by the expect setting. 

					success: function (data) {						
						$("#uploadpb").css('width', '0%').attr('aria-valuenow', 0);
						console.log(data);
						
						if (data[0].success) {
							$("#uploadmsgs").append('<h4><span class="label label-success"><fmt:message key="blog.resources.uploadsuccess"/></span></h4>').delay(1500).fadeOut();
							console.log("File successfully uploaded.");
						} else {
							$("#uploadmsgs").append('<h4><span class="label label-danger"><fmt:message key="blog.resources.uploaderror"/></span></h4>');
							console.log("ERROR uploading file: " + data[0].message);
						}
					},
					
					// error: function (error)
					// Called for each file that has encountered an error. A list of possible errors and
					// their types can be found here. For newer browsers, this callback will only be called
					// if the server cannot be reached, an HTTP status code other than 200 was returned, or
					// the output returned by the server could not be parsed in accordance with the expect setting.
					// In older browsers, this callback will be called only if the server's output cannot be
					// parsed. This is just because of the nature of how uploads are handled in older browsers.
					
					// error: (obj) An object containing information related to an error. Properties include:
					// name: the type of error that occurred; See error types
					// message: the error message for the specific error that occurred
					// xhr: the jqXHR object that contains the response returned by the server (only exists if
					// AJAX request was made)

					error: function (error) {
						// General upload fail.
						var error = error.message;
						$("#uploadmsgs").append('<h4><span class="label label-danger">File upload error:' + error + '</span></h4>');
					}

				});
				
				$(this).simpleUpload.maxSimultaneousUploads(1);

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

				<div class="center-block">
					<div class="pull-right">					
						<form:form name="pageForm" modelAttribute="page" action="save">						    		
			    			<security:csrfInput />
							<label class="btn btn-default">
		    					<span class="glyphicon glyphicon-open-file" aria-hidden="true"></span>&nbsp;<fmt:message key="blog.resources.upload"/><input type="file" name="file" multiple hidden="true">
							</label>
						</form:form>
					</div>				
					<div class="pull-right">	
						<button id="submit" type="button" class="btn btn-default" onClick="back_to_folderlist();"><span class="glyphicon glyphicon-level-up" aria-hidden="true"></span>&nbsp;<fmt:message key="blog.resources.back"/></button>&nbsp;
					</div>
				</div>

				<div class="clearfix"></div>
				
				<div>&nbsp;</div>
				
				<div class="center-block">
					<div class="progress">
					  <div id="uploadpb" class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
					    <span class="sr-only">0% Complete</span>
					  </div>
					</div>
				</div>
				
				<div class="center-block" id="uploadmsgs"></div>
				
				<table class="table table-hover table-striped">
				    <thead>
				    	<tr>
				        	<th class="text-center"><fmt:message key="blog.resources.label.resourcename"/></th>
				        	<th class="text-center"><fmt:message key="blog.resources.label.created"/></th>
				        	<th class="text-center"><fmt:message key="blog.resources.label.size"/></th>
				            <th>&nbsp;</th>
				        </tr>
				    </thead>
				    <tbody>
						<c:choose>		
							<c:when test="${fn:length(folder.resources) > 0}">
								<c:forEach items="${folder.resources}" var="resource" varStatus="rowNumber">
									<tr>
										<td>
											<c:out value="${resource.name}"/>
										</td>
										<td class="text-center"><fmt:formatDate type="both" pattern="yyyy/MM/dd HH:mm" value="${resource.creationDate}" /></td>
										<td class="text-center"><fmt:formatNumber type="number" value="${resource.size}" />&nbsp;bytes</td>
										<td class="text-right">
											<button id="submit" type="button" class="btn btn-default" onclick="open_modal_delete('${resource.resourceId}', '${resource.name}');"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> <fmt:message key="blog.resources.delete"/></button>							
										</td>
									</tr>								
								</c:forEach>
							</c:when>				
							<c:otherwise>
								<tr>
									<td colspan="4"><fmt:message key="blog.resources.noresources"/></td>
								</tr>							
							</c:otherwise>
						</c:choose>						    				    
				    </tbody>
				</table>
				
			</div>
			
			<div class="col-md-1"></div>
				
		</div>
		
		<!-- Delete resource modal -->
		<div class="modal fade" id="deleteResourceModal" tabindex="-1" role="dialog">
		  	<div class="modal-dialog">
		    	<div class="modal-content">
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="<fmt:message key="blog.resources.close"/>"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="deleteResourceModalTitle"><fmt:message key="blog.resources.modal.delete"/></h4>
		      		</div>
			      	<div class="modal-body">
			      		<input type="hidden" class="form-control" id="resourceIdInputHidden">
						<fmt:message key="blog.resources.delete.confirm"/>						
				    </div>
		      		<div class="modal-footer">
		        		<button type="button" class="btn btn-default" data-dismiss="modal"><fmt:message key="blog.resources.cancel"/></button>
		        		<button type="submit" class="btn btn-primary" onclick="delete_resource();" data-dismiss="modal"><fmt:message key="blog.folders.delete"/></button>
		      		</div>
		    	</div>
		  	</div>
		</div>		
				
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
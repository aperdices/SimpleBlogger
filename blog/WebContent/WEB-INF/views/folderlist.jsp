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
	
	var loadRemoteData = function() {	
		remoteDataURL = '<c:url value="/app/folder/all"/>';
		$.getJSON(remoteDataURL, function(data) {
			console.log("JSON data query success.");
			// Remove rows.
			$(".folderRow").remove();
			// Parse JSON response.
		    $.each(data, function(idx, folder){
		    	inject_row ($("#folderTBody"), folder, idx);
		   	});
		})
		.done(function() {
			console.log("JSON data query completed.");
		})
		.fail(function() {
			console.log("JSON data query failed.");
		})
		.always(function() {
		    console.log("loadRemoteData JS function called.");
		});				
	};
	
	var inject_row = function (table_body, folder, index) {
		
		// Create a table row as a string
		var row_str = '<tr class="folderRow" id="tr_' + index + '">';
		row_str += '<td>';
		row_str += '<input type="hidden" id="folderId_' + index + '"  value="' + folder.folderId + '">';
		row_str += '<input type="hidden" id="foldername_orig_' + index + '"  value="' + folder.name + '">';
		// row_str += '<input id="foldername_' + index + '" name="foldername_' + index + '" type="text" value="' + folder.foldername + '" class="nofocus" />';
		row_str += folder.name;
		row_str += '</td>';
		var cdate = new Date(folder.creationDate);
		var mdate = new Date(folder.modificationDate);
		row_str += '<td class="text-center">' + $.format.date(cdate, 'yyyy/MM/dd HH:mm:ss') + '</td>';
		row_str += '<td class="text-center">' + $.format.date(mdate, 'yyyy/MM/dd HH:mm:ss') + '</td>';
		row_str += '<td class="text-right">';
		row_str += '<button id="submit" type="submit" class="btn btn-default" onclick="open_modal_edit(' + folder.folderId + ', \'' + folder.name + '\');"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> <fmt:message key="blog.folders.edit"/></button> ';
		row_str += '<button id="submit" type="submit" class="btn btn-default" onclick="open_modal_delete(' + folder.folderId + ', \'' + folder.name + '\');"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> <fmt:message key="blog.folders.delete"/></button>';
		row_str += '</td>';
		row_str += '</tr>';

		// Inject the new row into the body.
		table_body.append(row_str);
	};
	
	var open_modal_edit = function (folderId, name) {
		$('#modalerrormsg').hide();
		$("#foldernameInputText").val(name);
		$("#folderIdInputHidden").val(folderId);
		$('#addFolderModal').modal('show');
	};
	
	var open_modal_delete = function (folderId, name) {
		$("#folderIdInputHidden").val(folderId);
		$("#deleteFolderModalTitle").text('<fmt:message key="blog.folders.modal.delete"/>' + ' "' + name + '"')
		$('#deleteFolderModal').modal('show');
	};
	
	var save_folder = function () {
		
		var pattern = new RegExp("^[a-zA-Z0-9_ ]+$");
		
		if (!pattern.test($("#foldernameInputText").val())) {
			$('#modalerrormsg').show();
		} else {
			saveUrl = '<c:url value="/app/folder/save"/>';
			saveParams = {
			    foldername: $("#foldernameInputText").val(),
			    folderId: $("#folderIdInputHidden").val()
		  	};
			$.getJSON(saveUrl, saveParams, function(data) {
				console.log("JSON data query success.");
				$('#addFolderModal').modal('hide');
				loadRemoteData();
			});		
		}
		
		return;
	};
	
	var delete_folder = function (fId) {
		deleteUrl = '<c:url value="/app/folder/delete"/>',
		deleteParams = {
		    folderId: $("#folderIdInputHidden").val()
	  	};
		$.getJSON(deleteUrl, deleteParams, function(data) {
			console.log("JSON data query success.");
			loadRemoteData();
		});
	};

	$(document).ready(function() {
		$('#addFolderModalForm').submit(function(event) {
			event.preventDefault();
			save_folder();
		});	
		$('#modalerrormsg').hide();
		loadRemoteData();
	});
	
	</script>
	
	<jsp:include page="/WEB-INF/views/templates/top.jsp" />
	
    <%--  Page Content --%>
    <div class="container">
    
        <div class="row">

            <%--  Blog Entries Column --%>
            <div class="col-md-1"></div>
            <div class="col-md-10">
		
				<h2><fmt:message key="blog.folders.title"/></h2>
				
				<div class="pull-right">
					<button id="submit" type="submit" class="btn btn-default pull-right" onClick="open_modal_edit(-1, '');"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <fmt:message key="blog.folders.add"/></button>
				</div>				
				
				<table class="table table-hover table-striped">
				    <thead>
				    	<tr>
				        	<th class="text-center"><fmt:message key="blog.folders.label.foldername"/></th>
				        	<th class="text-center"><fmt:message key="blog.folders.label.created"/></th>
				            <th class="text-center"><fmt:message key="blog.folders.label.modified"/></th>
				            <th>&nbsp;</th>
				        </tr>
				    </thead>
				    <tbody id="folderTBody">
						<tr class="folderRow">							
							<td class="text-center"></td>
							<td class="text-center"></td>
							<td class="text-right"></td>
							<td></td>
						</tr>				    				    
				    </tbody>
				</table>
				
			</div>
			<div class="col-md-1"></div>
			
		</div>
		
		<!-- Edit folder modal -->
		<div class="modal fade" id="addFolderModal" tabindex="-1" role="dialog">
		  	<div class="modal-dialog" role="document">
		    	<div class="modal-content">		      		
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="<fmt:message key="blog.folders.close"/>"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title"><fmt:message key="blog.folders.modal.edit"/></h4>
		      		</div>
		      		<form id="addFolderModalForm">      		
				      	<div class="modal-body">				        
							<div class="form-group">
								<h4 id="modalerrormsg"><span class="label label-danger"><fmt:message key="blog.folders.add.notvalid"/></span></h4>
								<input type="hidden" class="form-control" id="folderIdInputHidden">
								<label><fmt:message key="blog.folders.label.foldername"/></label>
								<input type="text" class="form-control" id="foldernameInputText">								
							</div>				        
					    </div>
			      		<div class="modal-footer">
			        		<button type="button" class="btn btn-default" data-dismiss="modal"><fmt:message key="blog.folders.cancel"/></button>
			        		<button type="submit" class="btn btn-primary"><fmt:message key="blog.folders.save"/></button>
			      		</div>
			      	</form>
		    	</div>
		  	</div>
		</div>
		
		<!-- Delete folder modal -->
		<div class="modal fade" id="deleteFolderModal" tabindex="-1" role="dialog">
		  	<div class="modal-dialog">
		    	<div class="modal-content">
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="<fmt:message key="blog.folders.close"/>"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="deleteFolderModalTitle"><fmt:message key="blog.folders.modal.delete"/></h4>
		      		</div>
			      	<div class="modal-body">
						<fmt:message key="blog.folders.delete.confirm"/>						
				    </div>
		      		<div class="modal-footer">
		        		<button type="button" class="btn btn-default" data-dismiss="modal"><fmt:message key="blog.folders.cancel"/></button>
		        		<button type="submit" class="btn btn-primary" onclick="delete_folder();" data-dismiss="modal"><fmt:message key="blog.folders.delete"/></button>
		      		</div>
		    	</div>
		  	</div>
		</div>	
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
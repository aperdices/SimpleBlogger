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
		remoteDataURL = '<c:url value="/app/tag/all"/>';
		$.getJSON(remoteDataURL, function(data) {
			console.log("JSON data query success.");
			// Remove rows.
			$(".tagRow").remove();
			// Parse JSON response.
		    $.each(data, function(idx, tag){
		    	inject_row ($("#tagTBody"), tag, idx);
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
	
	var inject_row = function (table_body, tag, index) {
		
		// Create a table row as a string
		var row_str = '<tr class="tagRow" id="tr_' + index + '">';
		row_str += '<td>';
		row_str += '<input type="hidden" id="tagId_' + index + '"  value="' + tag.tagId + '">';
		row_str += '<input type="hidden" id="tagname_orig_' + index + '"  value="' + tag.tagname + '">';
		// row_str += '<input id="tagname_' + index + '" name="tagname_' + index + '" type="text" value="' + tag.tagname + '" class="nofocus" />';
		row_str += tag.tagname;
		row_str += '</td>';
		var cdate = new Date(tag.creationDate);
		var mdate = new Date(tag.modificationDate);
		row_str += '<td class="text-center">' + $.format.date(cdate, 'yyyy/MM/dd HH:mm:ss') + '</td>';
		row_str += '<td class="text-center">' + $.format.date(mdate, 'yyyy/MM/dd HH:mm:ss') + '</td>';
		row_str += '<td class="text-right">';
		row_str += '<button id="submit" type="submit" class="btn btn-default" onclick="open_modal_edit(' + tag.tagId + ', \'' + tag.tagname + '\');"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> <fmt:message key="blog.tags.edit"/></button> ';
		row_str += '<button id="submit" type="submit" class="btn btn-default" onclick="open_modal_delete(' + tag.tagId + ', \'' + tag.tagname + '\');"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> <fmt:message key="blog.tags.delete"/></button>';
		row_str += '</td>';
		row_str += '</tr>';

		// Inject the new row into the body.
		table_body.append(row_str);
	};
	
	var open_modal_edit = function (tagId, tagname) {
		$('#modalerrormsg').hide();
		$("#tagnameInputText").val(tagname);
		$("#tagIdInputHidden").val(tagId);
		$('#addTagModal').modal('show');
	};
	
	var open_modal_delete = function (tagId, tagname) {
		$("#tagIdInputHidden").val(tagId);
		$("#deleteTagModalTitle").text('<fmt:message key="blog.tags.modal.delete"/>' + ' "' + tagname + '"')
		$('#deleteTagModal').modal('show');
	};	
	
	
	var save_tag = function () {
		
		var pattern = new RegExp("^[a-zA-Z0-9]+$");
		
		if (!pattern.test($("#tagnameInputText").val())) {
			$('#modalerrormsg').show();
		} else {
			saveUrl = '<c:url value="/app/tag/save"/>';
			saveParams = {
			    tagname: $("#tagnameInputText").val(),
			    tagId: $("#tagIdInputHidden").val()
		  	};
			$.getJSON(saveUrl, saveParams, function(data) {
				console.log("JSON data query success.");
				$('#addTagModal').modal('hide');
				loadRemoteData();
			});		
		}
		
		return;
	};
	
	var delete_tag = function () {
		deleteUrl = '<c:url value="/app/tag/delete"/>',
		deleteParams = {
		    tagId: $("#tagIdInputHidden").val()
	  	};
		$.getJSON(deleteUrl, deleteParams, function(data) {
			console.log("JSON data query success.");
			loadRemoteData();
		});
	};
	
	$(document).ready(function() {
		$('#addTagModalForm').submit(function(event) {
			event.preventDefault();
			save_tag();
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
            <div class="col-md-2"></div>
            <div class="col-md-8">
		
				<h2><fmt:message key="blog.tags.title"/></h2>
				
				<div class="pull-right">
					<button id="submit" type="submit" class="btn btn-default pull-right" onClick="open_modal_edit(-1, '');"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <fmt:message key="blog.tags.add"/></button>
				</div>				
				
				<table class="table table-hover table-striped">
				    <thead>
				    	<tr>
				        	<th class="text-center"><fmt:message key="blog.tags.label.tagname"/></th>
				        	<th class="text-center"><fmt:message key="blog.tags.label.created"/></th>
				            <th class="text-center"><fmt:message key="blog.tags.label.modified"/></th>
				            <th>&nbsp;</th>
				        </tr>
				    </thead>
				    <tbody id="tagTBody">
						<tr class="tagRow">							
							<td class="text-center"></td>
							<td class="text-center"></td>
							<td class="text-right"></td>
							<td></td>
						</tr>				    				    
				    </tbody>
				</table>
				
			</div>
			<div class="col-md-2"></div>
			
		</div>
		
		<!-- Edit tag modal -->
		<div class="modal fade" id="addTagModal" tabindex="-1" role="dialog">
		  	<div class="modal-dialog" role="document">
		    	<div class="modal-content">
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="<fmt:message key="blog.tags.close"/>"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title"><fmt:message key="blog.tags.modal.title"/></h4>
		      		</div>
					<form id="addTagModalForm">
				      	<div class="modal-body">				        
								<div class="form-group">
									<h4 id="modalerrormsg"><span class="label label-danger"><fmt:message key="blog.tags.add.notvalid"/></span></h4>
									<input type="hidden" class="form-control" id="tagIdInputHidden">
									<label><fmt:message key="blog.tags.label.tagname"/></label>
									<input type="text" class="form-control" id="tagnameInputText">
								</div>
					    </div>
			      		<div class="modal-footer">
			        		<button type="button" class="btn btn-default" data-dismiss="modal"><fmt:message key="blog.tags.cancel"/></button>
			        		<button type="submit" class="btn btn-primary"><fmt:message key="blog.tags.save"/></button>
			      		</div>
			      	</form>
		    	</div>
		  	</div>
		</div>
		
		<!-- Delete tag modal -->
		<div class="modal fade" id="deleteTagModal" tabindex="-1" role="dialog">
		  	<div class="modal-dialog">
		    	<div class="modal-content">
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="<fmt:message key="blog.tags.close"/>"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="deleteTagModalTitle"><fmt:message key="blog.tags.modal.delete"/></h4>
		      		</div>
			      	<div class="modal-body">
						<fmt:message key="blog.tags.delete.confirm"/>						
				    </div>
		      		<div class="modal-footer">
		        		<button type="button" class="btn btn-default" data-dismiss="modal"><fmt:message key="blog.tags.cancel"/></button>
		        		<button type="submit" class="btn btn-primary" onclick="delete_tag();" data-dismiss="modal"><fmt:message key="blog.tags.delete"/></button>
		      		</div>
		    	</div>
		  	</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
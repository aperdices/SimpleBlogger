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

<head>
	
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Isendev blog by SimpleBlogger Engine">
    <meta name="author" content="Antonio Perdices">
	
	<title><c:out value="${simpleBloggerConfig.blogTitle}" /></title>
	
	<link rel="alternate" type="application/rss+xml" title="<c:out value="${simpleBloggerConfig.blogTitle}" />" href="<c:url value="/app/feed/news.rss"/>" />
	
	<link rel="icon" type="image/ico" href="<c:url value="/imgs/favicon.ico" />"/>

	<!-- Adding Droid Sans font -->
	<link href='https://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>
	
    <!-- Bootstrap Core CSS -->
    <link href="<c:url value="/css/bootstrap.min.css" />" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value="/css/blog.css" />" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    <!-- jQuery -->
	<script src="<c:url value='/js/jquery.js' />"></script>

    <!-- jQuery Date Format plugin -->
	<script src="<c:url value='/js/jquery-dateFormat.min.js' />"></script>
	
	<script>
    	
		// Facebook sharing.
		function facebookShare (url, imageUrl, name, caption, description, redirectUrl) {
			var fbsUrl = "http://www.facebook.com/dialog/feed";
			fbsUrl += "?app_id=" + '<c:out value="${simpleBloggerConfig.facebookAppId}" />';
			fbsUrl += "&link=" + encodeURIComponent(url);
			fbsUrl += "&picture=" + encodeURIComponent(imageUrl);
			fbsUrl += "&name=" + encodeURIComponent(name);
			fbsUrl += "&caption=" + encodeURIComponent(caption);
			if (description != undefined && description != '') {
				fbsUrl += "&description=" + encodeURIComponent(description);
			}
			fbsUrl += "&redirect_uri=" + encodeURIComponent(redirectUrl);
			// window.open(fbsUrl, 'Facebook', 'toolbar=0,status=0,width=1024,height=535');
			window.open(fbsUrl, 'Facebook', 'toolbar=0,status=0');
			return false;
		};
		
		// Twitter sharing.
		function twitterShare (url) {
			var twsUrl = "https://twitter.com/intent/tweet?text=" + encodeURIComponent(url);
			// window.open(twsUrl, 'Twitter', 'toolbar=0,status=0,width=800,height=450');
			window.open(twsUrl, 'Twitter', 'toolbar=0,status=0');
			return false;
		}
		
		// Insert at cursor.
		function insertAtCursor (fieldName, textToInsert) {
			
			var targetField = document.getElementById(fieldName);

			// IE support.
			// Uses IE text range funcion.
			if (document.selection) {
				targetField.focus();
				sel = document.selection.createRange();
				sel.text = textToInsert;
			}

			// MOZILLA/NETSCAPE support.
			else if (targetField.selectionStart || targetField.selectionStart == '0') {
				var startPos = targetField.selectionStart;
				var endPos = targetField.selectionEnd;
				targetField.value = targetField.value.substring(0, startPos) + textToInsert + targetField.value.substring(endPos, targetField.value.length);

			// None of the above.
			} else {
				targetField.value += textToInsert;
			}

		}
		
		// Load tag data to panel.
		function loadTagsData () {	
			remoteDataURL = '<c:url value="/app/tag/count"/>';
			$.getJSON(remoteDataURL, function(data) {
				console.log("JSON data query success.");
				$('#tagsPanelBody').empty();
				tagDivContent = '';
				rootURL = '<c:url value="/app/entries/bytag/"/>';
			    $.each(data, function(idx, tag){
			    	tagDivContent += '<a href="' + rootURL + tag[0].tagId + '"><b>' + tag[0].tagname + '</b></a>&nbsp;(' + tag[1] + ') ';
			   	});
			    $('#tagsPanelBody').html(tagDivContent);
			})
			.done(function() {
				console.log("JSON data query completed.");
			})
			.fail(function() {
				console.log("JSON data query failed.");
			})
			.always(function() {
			    console.log("loadTagsData JS function called.");
			});
		};
		
		// Load archives data to panel.
		function loadArchivesData () {
			remoteDataURL = '<c:url value="/app/entries/archives"/>';
			$.getJSON(remoteDataURL, function(data) {
				console.log("JSON data query success.");
				$('#archivesPanelBody').empty();
				archivesDivContent = '';
				rootURL = '<c:url value="/app/entries/bydate/"/>';
			    $.each(data, function(idx, entries){
			    	archivesDivContent += '<a href="' + rootURL + entries[0] + '/' + entries[2] +  '"><b>' + entries[0] + '/' + entries[1] +  '</b></a>&nbsp;(' + entries[3] + ') ';
			   	});
			    $('#archivesPanelBody').html(archivesDivContent);
			})
			.done(function() {
				console.log("JSON data query completed.");
			})
			.fail(function() {
				console.log("JSON data query failed.");
			})
			.always(function() {
			    console.log("loadArchivesData JS function called.");
			});
		};
		
		// Load pages data to menu entries.
		function loadPagesData () {
			remoteDataURL = '<c:url value="/app/page/count"/>';
			$.getJSON(remoteDataURL, function(data) {
				console.log("JSON data query success.");
				$('#pagesMenuBody').empty();
				menuUlContent = '';
				rootURL = '<c:url value="/app/page/"/>';
			    $.each(data, function(idx, entries){
			    	menuUlContent += '<li><a href="' + rootURL + entries[1] + '">' + entries[0] + '</a></li>';
			   	});
			    $('#pagesMenuBody').html(menuUlContent);
			})
			.done(function() {
				console.log("JSON data query completed.");
			})
			.fail(function() {
				console.log("JSON data query failed.");
			})
			.always(function() {
			    console.log("loadPagesData JS function called.");
			});
		};		
		
		$(document).ready(function() {
    		
			$("#logout_link").click(function() {
    			  $("#logout_form").submit();
   			});
    		
			// Check for Tags and Archives panel and load data.
			
			if ($('#tagsPanelBody').length) {
				loadTagsData();
			};
			
			if ($('#archivesPanelBody').length) {
				loadArchivesData();
			};
			
			if ($('#pagesMenuBody').length) {
				loadPagesData();
			};
    		
    	});
		
	</script>
    
	<%--
	<script type="text/javascript" src="<c:url value="/js/calendar.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/calendar-en.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/calendar-setup.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/tools.js" />"></script>
	--%>
	
</head>
<%-- 	
	(c) 2019 Antonio Perdices.
	License: Public Domain.
	You can use this code freely and wisely in your applications.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL - Standard Format Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- JSTL - Standard Tag Library --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Footer -->
<footer>
    <div class="row">
        <div class="col-lg-12">
            <p class="text-center">
	            <a href="<c:out value="${simpleBloggerConfig.myTwitterUrl}" />" class="twitter_color"><span class="glyphicon glyphicon-bullhorn"></span>&nbsp;Twitter&nbsp;&nbsp;</a>
	            <a href="<c:out value="${simpleBloggerConfig.myInstagramUrl}" />" class="instagram_color"><span class="glyphicon glyphicon-camera"></span>&nbsp;Instagram&nbsp;&nbsp;</a>
	            <a href="<c:url value="/app/feed/news.rss"/>" class="rss_color"><span class="glyphicon glyphicon-globe"></span>&nbsp;RSS Feed</a>
            </p>
            <p class="text-center"><small><c:out value="${simpleBloggerConfig.blogFootMessage}" /></small></p>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
</footer>

<!-- Bootstrap Core JavaScript -->
<script src="<c:url value='/js/bootstrap.min.js' />"></script>
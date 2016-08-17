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
            <div class="col-md-4"></div>
            <div class="col-md-4">
            
            	<h2><fmt:message key="blog.login.title" /></h2>
            	
            	<%-- 
					This form-login-page form is also used as the
				    form-error-page to ask for a login again.		        
				    Is called on login error from Spring Security Controller
				    using authentication-failure-url parameter.
				       
				    authentication-failure-url="/app/login?login_error=1" 
				--%>
				 <c:if test="${param.login_error != null}">        
        			<h4><span class="label label-danger"><fmt:message key="blog.login.error" /></span></h4>
    			</c:if>
				
				<div class="vertical-spacing-wrapper">				
					<form role="form" name="loginform" action="<c:url value="/app/loginProcess" />" method="post">
					
						<div class="form-group">
						   	<label for="j_username"><fmt:message key="blog.login.username" /></label>
							<%-- <input type="text" class="form-control" id="j_username" value='<c:if test="${not empty param.login_error}"><c:out value="${SPRING_SECURITY_LAST_EXCEPTION.authentication.principal}"/></c:if>'> --%>
							<input type="text" class="form-control" id="username" name="username">
						</div>
						
						<div class="form-group">
							<label for="j_password"><fmt:message key="blog.login.password" /></label>
							<input type="password" class="form-control" id="password" name="password">
						</div>
						
						<security:csrfInput />
						
						<div class="pull-right"><button id="submit" type="submit" class="btn btn-default pull-right"><fmt:message key="blog.login.submit" /></button></div>
									
					</form>
				</div>
	
			</div>
			<div class="col-md-4"></div>
			
		</div>
		
		<jsp:include page="/WEB-INF/views/templates/foot.jsp" />

    </div>
    <%--  /.container --%>
		
</body>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" session="false" import="java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<c:set var="title" scope="request">IDFC Echoheaders Page - <%=request.getServerName() %></c:set>

<jsp:include page="/parts/header.jsp" />

<body>

	<div id="header" class="wrap">
		<table class="headerTable">
			<tr>
				<td align="left"><a href="<%=request.getContextPath() %>"><img src="<%=request.getContextPath()%>/style/idfclogo.png" /></a></td>
				<td align="right">
				<%
			    	String sessionIdHeader = request.getServletContext().getInitParameter("sessionIdHeaderName");
					if (sessionIdHeader != null && request.getHeader(sessionIdHeader) != null) {
				%>
					<a href="<%=request.getContextPath() %>/logout.jsp">Log Out</a>
				<%
					} else {
				%>
					<a href="<%=request.getContextPath() %>/protected/echoheaders.jsp">Log In</a>
				<%
					}
				%>
				</td>
			</tr>
		</table>

		<div id="title">
			<p class="note">
				Contains all of the headers, cookies, session variables, and attributes associated with the 
				<strong>EchoHeaders Test page in Java Web App </strong> request. 
				You can view differences in the headers between this and the protected pages.
			</p>
			<p>
				<em>Click here to return to <a href="<%= request.getServletContext().getContextPath()%>">the test app root</a></em>
			</p>
			<p>
				<em>Click here to return to <a href="https://www.idfconnect.net">wwww.idfconnect.net</a></em>
			</p>
		</div>
	</div>

	<div id="main" class="wrap">

		<h1>Basic Request Info</h1>
		<br/>
		<jsp:include page="/parts/basicInfo.jsp" />

		<hr />

		<h1>Headers</h1>
		<br/>
		<jsp:include page="/parts/requestHeaders.jsp" />

		<hr />

		<h1>Cookies</h1>
		<br/>
		<jsp:include page="/parts/requestCookies.jsp" />

		<hr />

		<h1>Request parameters</h1>
		<br/>
		<jsp:include page="/parts/requestParameters.jsp" />

		<hr />

		<h1>Request attributes</h1>
		<br/>
		<jsp:include page="/parts/requestAttributes.jsp" />

		<hr />

		<h1>Session variables</h1>
		<br/>
		<jsp:include page="/parts/sessionAttributes.jsp" />

		<hr />

		<h1>JNDI resources</h1>
		<br/>
		<jsp:include page="/parts/requestJndiResources.jsp" />

		<hr />

		<h1>System properties</h1>
		<br/>
		<jsp:include page="/parts/systemProps.jsp" />

		<hr />

		<jsp:include page="/parts/footer.jsp" />

	</div>
</body>
</html>
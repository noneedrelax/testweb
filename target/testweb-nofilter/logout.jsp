<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires"
	content="Tuesday, January 1, 1980 00:00:00 GMT" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IDFC - Echoheaders Test Application - Logout Page</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/style.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/normalize.css" type="text/css" />
</head>

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

	<br/>
		<b>Logout Test Web App</b>
		<div id="title">
			<br/>
			<p class="note">You have successfully logged out. Your SM_USER should be null. All your cookies should have been removed and you will need login again to access to protected resource. </p>
		</div>
	</div>

	<div id="main" class="wrap">

		<%
		    String userprincipal = null;
		    if (request.getUserPrincipal() != null)
		        userprincipal = request.getUserPrincipal().getName();
		%>
		
		Click here to <a href="https://www.idfconnect.net">Go to Home</a>
		<br/>
		<br/>
		<b>Request Info</b>

		<ul>

			<li><b><u>SM_USER:</u></b> <i><%=request.getHeader("SM_USER")%></i></li>
			<li><b><u>Remote user:</u></b> <i><%=request.getRemoteUser()%></i></li>
			<li><b><u>User principal:</u></b> <i><%=userprincipal%></i></li>
			<li><b><u>Query string:</u></b> <i><%=request.getQueryString()%></i></li>
		</ul>

		<hr />

		<b>Headers</b>

		<ul>
			<%
			    for (Enumeration<?> headers = request.getHeaderNames(); headers.hasMoreElements();) {
			        String headername = (String) headers.nextElement();
			%>
			<li><b><u><%=headername%></u></b> <i><%=request.getHeader(headername)%>&nbsp;</i></li>
			<%
			    }
			%>

		</ul>

		<hr />

		<b>Cookies</b>

		<ul>
			<%
			    Cookie[] cookies = request.getCookies();
			    if (cookies != null) {
			        for (int i = 0; i < cookies.length; i++) {
			%>
			<li><b><u><%=cookies[i].getName()%></u></b> <i> <%=cookies[i].getValue()%></i></li>
			<%
			    }
			    }
			%>
		</ul>

		<hr />

		<b>Session variables</b>

		<ul>
			<%
			    HttpSession session = request.getSession(false);
			    if (session != null) {
			        Enumeration<?> attributenames = session.getAttributeNames();
			        if (attributenames != null) {
			%>

			<%
			    while (attributenames.hasMoreElements()) {
			                String nextattrname = attributenames.nextElement().toString();
			%>

			<li>
				
					<b>Attribute: <u><%=nextattrname%></u></b>

					<%
                        Object o = session.getAttribute(nextattrname);
                        if (o != null) {
%>

					<i><%=o.getClass().getName()%></i>,
					<%=o.toString()%>
			</li>

			<%
			    }
			            }
			        }
			    }
			%>

		</ul>
		<b>Parameters</b>

		<ul>
			<%
			    for (Enumeration<?> parameters = request.getParameterNames(); parameters.hasMoreElements();) {
			        String parameter = (String) parameters.nextElement();
			%>
			<li><b><u><%=parameter%></u></b> <i><%=request.getParameter(parameter)%>&nbsp;</i></li>
			<%
			    }
			%>
		</ul>
	</div>
</body>
</html>
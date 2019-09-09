<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires"
	content="Tuesday, January 1, 1980 00:00:00 GMT" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IDFC - Post Test Application</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/style.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/normalize.css" type="text/css" />
</head>

<body>

	<div id="header" class="wrap">
	<table class="headerTable">
		<tr>
			<td align="left"> 
			<a href="/"><img src="<%=request.getContextPath() %>/style/idfclogo.png" /></a></td>
		</tr>
	</table>
	<br/>
		<b>POST Test Page</b>
		<div id="title">
			<br/>
			<p class="note">This page shows the headers, cookies and session variables when POST data to a protected resource triggers the POST-preservation mechanism maintaining data.</p>
		</div>
	</div>

	<div id="main" class="wrap">

		
		Click here to <a href="https://www.idfconnect.net">Go to Home</a>
		<br/>
		<br/>
	<form method="post" action="protected/echoheaders.jsp">
		Message: <input type="text" name="message"/>
		<br/><br/>
		E-Mail: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="email"/>
		<br/><br/>
		<input type="submit" value="submit"/>
	</form>
			
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
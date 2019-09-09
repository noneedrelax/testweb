<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    for (Enumeration<?> parameters = request.getParameterNames(); parameters.hasMoreElements();) {
	        String parameter = (String) parameters.nextElement();
	%>
	<li><b><span style="text-decoration: underline;"><%=parameter%></span></b> <i><%=request.getParameter(parameter)%>&nbsp;</i></li>
	<%
	    }
	%>
</ul>

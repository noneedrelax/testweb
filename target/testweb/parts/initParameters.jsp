<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    for (Enumeration<?> parameters = request.getServletContext().getInitParameterNames(); parameters.hasMoreElements();) {
	        String parameter = (String) parameters.nextElement();
	%>
	<li><b><span style="text-decoration: underline;"><%=parameter%></span></b> <i><%=request.getServletContext().getInitParameter(parameter)%>&nbsp;</i></li>
	<%
	    }
	%>
</ul>

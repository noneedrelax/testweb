<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (int i = 0; i < cookies.length; i++) {
	%>
	<li><b><span style="text-decoration: underline;"><%=cookies[i].getName()%></span></b> <i> <%=cookies[i].getValue()%></i></li>
	<%
	    	}
	    }
	%>
</ul>

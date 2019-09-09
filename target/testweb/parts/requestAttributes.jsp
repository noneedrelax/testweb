<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    for (Enumeration<?> attributes = request.getAttributeNames(); attributes.hasMoreElements();) {
	        String attrname = (String) attributes.nextElement();
	%>
	<li><b><span style="text-decoration: underline;"><%=attrname%></span></b> <i><%=request.getAttribute(attrname)%>&nbsp;</i></li>
	<%
	    }
	%>
</ul>

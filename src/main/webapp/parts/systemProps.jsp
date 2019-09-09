<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    for (Enumeration<?> propnames = System.getProperties().keys(); propnames.hasMoreElements();) {
	        String propname = (String) propnames.nextElement();
	%>
	<li><b><span style="text-decoration: underline;"><%=propname%></span></b> <i><%=System.getProperty(propname)%>&nbsp;</i></li>
	<%
	    }
	%>

</ul>

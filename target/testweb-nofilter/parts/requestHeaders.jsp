<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" import="java.util.*"%>
<ul>
	<%
	    for (Enumeration<?> headers = request.getHeaderNames(); headers.hasMoreElements();) {
	        String headername = (String) headers.nextElement();
	%>
	<li><b><span style="text-decoration: underline;" class="attrName"><%=headername%></span></b> <i class="attrValue"><%=request.getHeader(headername)%></i></li>
	<%
	    }
	%>

</ul>

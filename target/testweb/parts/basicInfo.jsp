<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%
    boolean legacyHeaderNames = "true".equalsIgnoreCase(request.getServletContext().getInitParameter("legacyHeaderNames"));
    String useridheader = request.getServletContext().getInitParameter("userIdHeaderName");
    if (useridheader == null)
        useridheader = (legacyHeaderNames) ? "SM_USER" : "SMUSER";
    String userprincipal = null;
    if (request.getUserPrincipal() != null)
        userprincipal = request.getUserPrincipal().getName();
%>

<ul>
	<li><b><span style="text-decoration: underline;"><%=useridheader%>:</span></b> <i><%=request.getHeader(useridheader)%></i></li>
	<li><b><span style="text-decoration: underline;">Remote user:</span></b> <i><%=request.getRemoteUser()%></i></li>
	<li><b><span style="text-decoration: underline;">User principal:</span></b> <i><%=userprincipal%></i></li>
	<li><b><span style="text-decoration: underline;">Query string:</span></b> <i><%=request.getQueryString()%></i></li>
</ul>

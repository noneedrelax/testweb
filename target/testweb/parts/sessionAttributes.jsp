<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" import="java.util.*"%>
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
		<p>
			<b>Attribute: <span style="text-decoration: underline;"><%=nextattrname%></span></b>

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
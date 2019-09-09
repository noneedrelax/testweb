<%@page import="com.idfconnect.ssorest.common.utils.SmEncodingUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
        pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Login Test Application</TITLE>
<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>
<META content=no-cache http-equiv=Pragma>
<META content="Tuesday, January 1, 1980 00:00:00 GMT" http-equiv=Expires>
<META content=no-cache http-equiv=Cache-control>
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/style.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/normalize.css" type="text/css"/>
</HEAD>
<%
    // Get the target
    String targetURL = request.getParameter("TARGET");
    if ((targetURL != null) && (targetURL.startsWith("$SM$") || targetURL.startsWith("-SM-")))
        targetURL = SmEncodingUtil.undoSiteMinderEncoding(targetURL);

    // Get the other query-string parameters
    String smagentname = request.getParameter("SMAGENTNAME");
    if ((smagentname != null) && (smagentname.startsWith("$SM$") || smagentname.startsWith("-SM-")))
        smagentname = SmEncodingUtil.undoSiteMinderEncoding(smagentname);
    if (smagentname == null)
        smagentname = "";
    String smauthreason = request.getParameter("SMAUTHREASON");
    if (smauthreason == null)
        smauthreason = "";
    String smquerydata = request.getParameter("SMQUERYDATA");
    if (smquerydata == null)
        smquerydata = "";
    //String postpreservation = request.getParameter("POSTPRESERVATIONDATA");
    String postpreservation = request.getParameter("SMPostPreserve");
    if (postpreservation == null)
        postpreservation = "";

    // modify these for your environment
    String fccURL = "/login/totp.fcc";
    String forgottenUserURL = "/";
    String forgottenPwdURL = "/testweb/forgotpw.jsp";
    String selfRegURL = "/iam/im/public/ui7/index.jsp?task.tag=SelfRegistration&task.redirecturl=/";
%>

<BODY>
        <div id="header" class="wrap">
                <div id="logo">
                        <a href="/"><img src="<%=request.getContextPath() %>/style/idfclogo.png"></a>
                </div>
                <h3>Login with user name, password and one time pin</h3>
        </div>
        <div id="main" class="wrap">
                <div id="login">
                        <form name="logonForm" action="<%=fccURL%>" method="POST">
                                <input type=hidden name=target value="<%=targetURL%>">
                                <input type=hidden name=smagentname value="<%=smagentname%>">
                                <input type=hidden name=smauthreason value="<%=smauthreason%>">
                                <input type=hidden name=smquerydata value="<%=smquerydata%>">
                                <input type=hidden name=postpreservationdata value="<%=postpreservation%>">

                                <table class="loginTable">
                                        <tr>
                                                <td>
                                                        <label for="username">Username:</label>
                                                </td>
                                                <td>
                                                        <input type="text" name="username" id="username">
                                                </td>
                                        </tr>
                                        <tr>
                                                <td>
                                                        <label for="password">Password:</label>
                                                </td>
                                                <td>
                                                        <input type="password" name="password" id="password">
                                                </td>
                                        </tr>
                                        <tr>
                                                <td>
                                                        <label for="pin code">Pin code:</label>
                                                </td>
                                                <td>
                                                        <input type="password" name="pincode" id="password">
                                                </td>
                                        </tr>
                                        <tr><td colspan=2>&nbsp;</td></tr>
                                        <tr>
                                                <td colspan=2 align=center>
                                                        <input type="submit" value="Submit"  style="padding-right: 6px">
                                                        <input type="Button" value="New Account" onclick="window.location.href='<%=selfRegURL %>'" style="padding-right: 6px">
                                                        <input type="Button" value="Forgot Password" onclick="window.location.href='<%=forgottenPwdURL %>'">
                                                </td>
                                        <tr>
                                </table>
                        </form>
                </div>
        </div>

        <%
            /** Start Error message ***************************/
            int tries = 0;
            javax.servlet.http.Cookie cookies[] = request.getCookies();
            if (cookies != null)
                for (int c = 0; c < cookies.length; c++)
                    if (cookies[c].getName().equals("SMTRYNO"))
                        tries = new Integer(cookies[c].getValue()).intValue();
            if (tries > 0) {
        %>
        <font color="RED"><em>Error: Invalid login attempt, Please
                        try again...</em></font>
        <br>
        <br>
        <%
            }
            /** End Error message *****************************/
        %>

</BODY>
</HTML>

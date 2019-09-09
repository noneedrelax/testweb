<%@page import="com.idfconnect.ssorest.common.utils.SmEncodingUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	String smtoken = request.getParameter("SMTOKEN");
	if (smtoken == null)
	    smtoken = "";
	smtoken = smtoken.replace(' ', '+');
			
	int smauthreason = 0;
	try {
		smauthreason = Integer.parseInt(request.getParameter("SMAUTHREASON"));
	}
	catch (Exception e) {}

	String smquerydata = request.getParameter("SMQUERYDATA");
	if (smquerydata == null)
		smquerydata = "";
	String postpreservation = request.getParameter("POSTPRESERVATIONDATA");
	if (postpreservation == null)
		postpreservation = request.getParameter("SMPostPreserve");
	if (postpreservation == null)
		postpreservation = "";
	String usermsg = request.getParameter("SMPWUSRMSG");
	if (usermsg == null)
	    usermsg = "";
	String username = request.getParameter("USERNAME");
	if (username == null)
	    username = "";

	// modify these for your environment
	String fccURL = request.getContextPath() + "/login/smpwservices.fcc";
	String forgottenUserURL = "/";
	String forgottenPwdURL = "/testweb/forgotpw.jsp";
	String selfRegURL = "/iam/im/public/ui7/index.jsp?task.tag=SelfRegistration&task.redirecturl=/";

 	// Determine page settings
 	String pageLabel = null;
	String instructions = null;
 	boolean showUserField = false;
 	boolean showPasswordField = false;
 	boolean showNewPasswordField = false;
 	switch (smauthreason) {
 		case 0: //Auth Reason 0 - Reason none
 		    pageLabel = "Login Required";
			instructions = "Please enter your username and passcode.";
			showUserField = true;
			showPasswordField = true;
			break;
 		case 1: //Auth Reason 1 - Password must change
 		    pageLabel = "Please change your password";
 		    instructions = "<B>" + username + "</B> please change your current password before continuing.";
 		    showPasswordField = true;
			showNewPasswordField = true;
			break;
 		case 4: //Auth Reason 4 - Session Expired
 		    pageLabel = "Session Expired";
 		    instructions = "Your session has expired. Please enter your username and passcode.";
			showUserField = true;
			showPasswordField = true;
			break;
 		case 5: //Auth Reason 5 - AuthLevelTooLow
 		    pageLabel = "Login Required";
 		    instructions = "A higher authentication level is needed. Please enter your username and passcode.";
			showUserField = true;
			showPasswordField = true;
			break;
 		case 7: //Auth Reason 7 - Account disabled
 		    instructions = "<B>" + username + "</B>: you cannot access your account at this time.<p>Please contact your Security Administrator or Help Desk.";
			break;
 		case 18: //Auth Reason 18 - Optional password change
 		    pageLabel = "Change Password";
			instructions = "<B>" + username + "</B> <p> " + usermsg + " <p>Please change your current password before continuing.";
 			showPasswordField = true;
 			showNewPasswordField = true;
			break;
 		case 19: //Auth Reason 19 - Account locked due to password expired
 		    pageLabel = "Password Expired";
 		    instructions = "<B>" + username + "</B> you cannot access your account because your password has expired.<p>Please contact your Security Administrator or Help Desk.";
			break;
 		case 20: //Auth Reason 20 - Password change immediately
 		    pageLabel = "Change Password";
 		    instructions = "<B>" + username + "</B> please change your current password before continuing.";
 		    showPasswordField = true;
			showNewPasswordField = true;
			break;
 		case 21: //Auth Reason 21 - Password change failed
 		    pageLabel = "Change Password";
			instructions = "<B>$$username$$</B> your password change request was not processed correctly. <p> Please try again.";
 		    showPasswordField = true;
			showNewPasswordField = true;
			break;
 		case 22: //Auth Reason 22 - Bad Password
 		    pageLabel = "Change Password";
 		    instructions = "<B>$$username$$</B> your password change was not accepted. <p> $$SMPWUSRMSG$$ <p> Please try again.";
 		    showPasswordField = true;
			showNewPasswordField = true;
			break;
 		case 23: //Auth Reason 23 - Password Change Accepted
 		    pageLabel = "Password Changed Successfully";
 		    instructions = "<b>$$username$$</b> your new password has been set. <p> Use this new password the next time you log into your account.";
			break;
 		case 24: //Auth Reason 24 - Account disabled due to excess login attempts
 		    pageLabel = "Account Locked";
 		    instructions = "<B>$$username$$</B> you cannot access your account because you have exceeded the limit of login attempts. <p>Please contact your Security Administrator or Help Desk.";
			break;
 		case 25: //Auth Reason 25 - Account disabled due to inactivity
 		    pageLabel = "Account Disabled";
 		    instructions = "<B>$$username$$</B> your account has been disabled due to inactivity. <p> Please contact your Security Administrator or Help Desk.";
			break;
 		default:
 		    pageLabel = "Unsupported AUTHREASON";
 	}
%>

<HTML>
<HEAD>
<TITLE><%=pageLabel %></TITLE>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<META content=no-cache http-equiv=Pragma>
<META content="Tuesday, January 1, 1980 00:00:00 GMT" http-equiv=Expires>
<META content=no-cache http-equiv=Cache-control>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/style.css" type="text/css" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/normalize.css"
	type="text/css" />
<!-- Cross-frame scripting prevention: This code will prevent this page from being encapsulated within HTML frames. Remove, or comment out, this code if the functionality that is contained in this SiteMinder page is to be included within HTML frames. -->
<STYLE>
html {
	display: none;
	visibility: hidden;
}
</STYLE>

<SCRIPT>
	if (self == top) {
		document.documentElement.style.display = 'block';
		document.documentElement.style.visibility = 'visible';
	} else {
		top.location = self.location;
	}
	
	var smauthreason = <%= smauthreason %>;
</SCRIPT>
</HEAD>
               

<script>
	function searchKeyPress(e) {
		// look for window.event in case event isn't passed in
		if (typeof e == 'undefined' && window.event) {
			e = window.event;
		}
		if (e.which || e.keyCode) {
			if ((e.which == 13) || (e.keyCode == 13)) {
				document.getElementById('Enter').click();
			}
		}
	}

	function resetCredFields() {
<% if (showPasswordField) { %>
		document.PWChange.PASSWORD.value = '';
<% } %>
<% if (showNewPasswordField) { %>
		document.PWChange.NEWPASSWORD.value = '';
		document.PWChange.CONFIRMATION.value = '';
<% } %>
	}
	
	// Function for Validating Forms
	function CheckForm(form) {
<% if (showPasswordField) { %>
		if (form.PASSWORD.value == "") {
			alert("Please enter your current Password.")
			form.PASSWORD.focus()
			return false
		} 
<% } %>
<% if (showPasswordField) { %>
		if (form.NEWPASSWORD.value == "") {
			alert("Please enter a new Password.")
			form.NEWPASSWORD.focus()
			return false
		} else if (form.CONFIRMATION.value == "") {
			alert("Please confirm your new Password.")
			form.CONFIRMATION.focus()
			return false
		} else if (form.NEWPASSWORD.value != form.CONFIRMATION.value) {
			alert("Please match your New Password and Confirmation.")
			form.NEWPASSWORD.focus()
			return false
		} else if (form.PASSWORD.value == form.NEWPASSWORD.value) {
			alert("Please make your New Password different from your Old Password.")
			form.NEWPASSWORD.focus()
			return false
		}
<% } %>
		form.submit()
		return true
	}

	function submitform() {
		if (smauthreason == 18) {
			document.forms['PWChange'].elements['SMAUTHREASON'].value = 23
			document.PWChange.submit();
		} else if (smauthreason == 23 || smauthreason == 32) {
			document.PWChange.submit()
		}
	}

	function clearSubmit() {
		document.PWChange.PASSWORD.value = '';
		document.PWChange.NEWPASSWORD.value = '';
		document.PWChange.CONFIRMATION.value = '';
		submitform();
	}
</SCRIPT>

</HEAD>

<BODY onLoad='resetCredFields();'>
    <div id="header" class="wrap">
        <div id="logo">
            <a href="/"><img src="<%=request.getContextPath() %>/style/idfclogo.png"></a>
        </div>
        <div id="menu">
        </div>
    </div>
        
    <div id="main"  class="wrap">
        <div id="login">
        
        <%=instructions %>
        
            <form name="PWChange" action="<%=fccURL%>" method="POST">
<% if (!("".equals(username)) && !showUserField) { %>
            	<INPUT type="hidden" name="USERNAME" value="<%= username%>">
<% } %>
            	<INPUT type="hidden" name="SMENC" value="UTF-8">
                <input type="hidden" name="TARGET" value="<%=targetURL%>">
                <input type="hidden" name="SMAGENTNAME" value="<%=smagentname%>">
                <input type="hidden" name="SMAUTHREASON" value="<%=smauthreason%>">
                <input type="hidden" name="SMQUERYDATA" value="<%=smquerydata%>">
                <input type="hidden" name="POSTPRESERVATIONDATA" value="<%=postpreservation%>">
            	<INPUT type="hidden" name="SMTOKEN" value="<%= smtoken %>"> 

                <table class="loginTable">

<% if (showUserField) { %>
                    <tr>
                        <td>
                            <label for="username">Username:</label>
                        </td>
                        <td>
                            <input type="text" name="USERNAME" onkeydown='searchKeyPress(event);'>
                        </td>
                    </tr>
<% } %>
<% if (showPasswordField) { %>
                    <tr>
                        <td>
                            <label for="password"><% if (showNewPasswordField) {%>Old <%}%>Password:</label>
                        </td>
                        <td>
                            <input type="password" name="PASSWORD" onkeydown='searchKeyPress(event);'>
                        </td>
                    </tr>
<% } %>
<% if (showNewPasswordField) { %>
                    <tr>
                        <td>
                            <label for="password">New Password:</label>
                        </td>
                        <td>
                            <input type="password" name="NEWPASSWORD" onkeydown='searchKeyPress(event);'>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="password">Confirm New Password:</label>
                        </td>
                        <td>
                            <input type="password" name="CONFIRMATION" onkeydown='searchKeyPress(event);'>
                        </td>
                    </tr>
<% } %>
                    <tr><td colspan=2>&nbsp;</td></tr>
                    <tr>
                        <td colspan=2 align=center>
                            <input type="Button" value="Submit" id='Enter' onClick='CheckForm(this.form)'>
                            <input type="Reset" value="Reset">
 <% if (smauthreason == 18) { %>
            	<INPUT type="button" value='Remind me later' onClick='clearSubmit()'>
<% } %>
                        </td>
                    <tr>
                </table>
	        </form>
        </div>
    </div>

</BODY>

</HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="Tuesday, January 1, 1980 00:00:00 GMT"/>
<meta http-equiv="Cache-control" content="no-cache"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IDFC - Retrieve Password Options</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/style.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/normalize.css" type="text/css"/>
</head>

<body>

<div id="header" class="wrap">
        <div id="logo">
                <a href="/"><img src="<%=request.getContextPath() %>/style/idfclogo.png"/></a>
        </div>
<br/>
        <div id="title">
                <b>Please choose the following options to retrieve your password</b>
        </div>
</div>


<div id="main" class="wrap">

	
	<ul>
		<li>
			<a href="/iam/im/public/index.jsp?task.tag=ForgottenPassword&task.redirecturl=/"><u>Use My Security Questions</u></a> <br/>(Answer 3 security questions you've defined earlier. Such option will not be available if you haven't set security questions)<br/><br/>
		</li>
		<li>
			<a href="/iam/im/public/index.jsp?task.tag=ForgottenPasswordTOTP&task.redirecturl=/"><u>Use TOTP</u></a> <br/>(Key in TOTP from Google Authenticator. Such option will not be availble if you haven't registered MFA wtih Google Authenticator)<br/><br/>
		</li>
		<li>
			<a href="/iam/im/public/index.jsp?task.tag=ForgottenPasswordQTOTP&task.redirecturl=/"><u>Use both Security Questions and TOTP</u></a> <br/>(Retrieve password by answering 2 security questions and providing TOTP)<br/><br/>
		</li>
	</ul>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="/"><u>Back</u></a>
</div>

</body>
</html>
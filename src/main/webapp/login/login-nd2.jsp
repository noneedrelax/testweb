<%@ page
        language="java"
        contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"
%><!DOCTYPE html>
<html xml:lang="en" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no" />
    <meta name="robots" content="noindex, nofollow">
    <meta content="no-cache" http-equiv="Pragma">
    <meta content="Tuesday, January 1, 1980 00:00:00 GMT" http-equiv="Expires">
    <meta content="no-cache" http-equiv="Cache-control">

    <title>Login Test Application</title>

    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/dist/main.css" />

    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/dist/main.js"></script>
    <%
        // Get SSO/Rest base from context
        String ssorestBase = request.getServletContext().getInitParameter("ssorest-base");
        if (ssorestBase == null || "".equals(ssorestBase))
        ssorestBase = "/ssorest";
    %>
    <script type="text/javascript">
        var loginForm;

        $('document').ready(function() {
            loginForm = new window.LoginLib.LoginForm({
                //gwBaseUrl: 'https://www.idfconnect.net/ssorest3',
                gwBaseUrl: '<%=ssorestBase%>',
                loginSuccess: loginSuccess,
                debug: true,
            });
            loginForm.init();
        });

        function loginSuccess(data) {
            $('#formResult').show().html('<p>Login successful</p>');
            var urlParams = loginForm.getUrlParams();
            if (urlParams.TARGET) {
                console.log('Redir to', loginForm.undoSiteMinderEncoding(urlParams.TARGET));
                window.location.href = loginForm.undoSiteMinderEncoding(urlParams.TARGET);
            }
        }
    </script>
</head>
<body>
<div class="body-cont">
    <div class="header">
        <div class="header-logo-cont"><a tabIndex="0" class="header-logo" href="/"><span class="header-logo-img"></span><span class="header-logo-title">IDF Connect</span></a></div>
        <div class="header-bottom"></div>
        <div class="header-title-cont">
            <div class="header-title text"></div>
        </div>
    </div>

    <div class="main">
        <div class='main-center'>
            <form name="loginForm" class="form-centered" method="post">
                <input type="hidden" name="formType" value="login"/>
                <div class="form__block">
                    <div class="form-row">
                        <div class="form-control form-control-floating">
                            <label class="label floating-animate floating-initial">Username</label>
                            <input id="username" type="text" class="input" name="username" required="1" autocomplete="username" value=""/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-control form-control-floating">
                            <label class="label floating-animate floating-initial">Password</label>
                            <input id="password" type="password" class="input" name="password" required="1" autocomplete="current-password" value=""/>
                        </div>
                    </div>
                    <div class="form-row form-row-newpassword hidden">
                        <div class="form-control form-control-floating">
                            <label class="label floating-animate floating-initial">New Password</label>
                            <input type="password" class="input" name="newpassword" autocomplete="new-password" value=""/>
                        </div>
                    </div>
                    <div class="form-row form-row-newpassword2 hidden">
                        <div class="form-control form-control-floating">
                            <label class="label floating-animate floating-initial">Confirm New Password</label>
                            <input type="password" class="input" name="newpassword2" autocomplete="new-password" value=""/>
                        </div>
                    </div>
                </div>
                <div id="statusCont" class="form-row" style="display: none">
                    <div id="status" style="padding-top: 20px">

                    </div>
                </div>
                <div class="form-row">
                    <button class="btn large btn solid large btn-100 btn-submit clickable">Log In</button>
                </div>
            </form>
            <div id="formResult" class="form-result"></div>
        </div>
    </div>

    <div class="footer">
        <div class="footer-line text">
            © 2012-<script type="text/javascript">document.write(new Date().getFullYear());</script> IDF Connect, Inc. All Rights Reserved.
        </div>
    </div>
</div>
</body>
</html>

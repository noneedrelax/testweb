<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="com.idfconnect.ssorest.common.utils.SmEncodingUtil"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Login Test Application</TITLE>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<META content=no-cache http-equiv=Pragma>
<META content="Tuesday, January 1, 1980 00:00:00 GMT" http-equiv=Expires>
<META content=no-cache http-equiv=Cache-control>
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/style.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/st.dist.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/style/normalize.css" type="text/css"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js" crossorigin="anonymous"></script>
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
    String postpreservation = request.getParameter("POSTPRESERVATIONDATA");
    if (postpreservation == null)
      postpreservation = request.getParameter("SMPostPreserve");
    if (postpreservation == null)
        postpreservation = "";

    // NUDATA PARAMETERS
    int placementPage = 1; // change as needed for other pages
    String ndApiBaseUrl = request.getParameter("NDAPIBASEURL");
    if ((ndApiBaseUrl != null) && (ndApiBaseUrl.startsWith("$SM$") || ndApiBaseUrl.startsWith("-SM-")))
        ndApiBaseUrl = SmEncodingUtil.undoSiteMinderEncoding(ndApiBaseUrl);
    if (ndApiBaseUrl == null)
        ndApiBaseUrl = "";
    String ndClientKey = request.getParameter("CLIENTKEY");
    if ((ndClientKey != null) && (ndClientKey.startsWith("$SM$") || ndClientKey.startsWith("-SM-")))
        ndClientKey = SmEncodingUtil.undoSiteMinderEncoding(ndClientKey);
    if (ndClientKey == null)
        ndClientKey = "";
    String ndClientId = request.getParameter("CLIENTID");
    if ((ndClientId != null) && (ndClientId.startsWith("$SM$") || ndClientId.startsWith("-SM-")))
        ndClientId = SmEncodingUtil.undoSiteMinderEncoding(ndClientId);
    if (ndClientId == null)
        ndClientId = "";
	String placementField = request.getParameter("PLACEMENTFIELD");
    String placement = request.getParameter("PLACEMENT");
	String ppField = request.getParameter("PPFIELD");
	String rsField = request.getParameter("RSFIELD");
	String reportSegment = request.getParameter("RS");
	String nsidField = request.getParameter("NSIDFIELD");

	// modify these for your environment
	String ssorestScoreEndpoint = "/ssorest/service/public/score";
    String fccURL = request.getContextPath()+"/login/login.fcc";
    String forgottenUserURL = "/";
    String forgottenPwdURL = "/testweb/forgotpw.jsp";
    String selfRegURL = "/iam/im/public/ui7/index.jsp?task.tag=SelfRegistration&task.redirecturl=/";
%>
<script type="text/javascript">
(function() {
	var ndClientId = "<%=ndClientId %>";
	var baseUrl = "<%=ndApiBaseUrl%>/2.2/w/<%=ndClientId %>/sync/js/";
	(function(w,d,s,u,q,js,fjs,nds){
		nds=w.ndsapi||(w.ndsapi={});nds.config={q:[],ready:function(cb){
		this.q.push(cb)}};js=d.createElement(s);fjs=d.getElementsByTagName(s)[0];
		js.src=u;fjs.parentNode.insertBefore(js,fjs);js.onload=function(){
		nds.load(u);}
	}(window,document,"script",baseUrl));

	var nds = window.ndsapi;
	nds.config.ready(function() {
		nds.setSessionId('<%= session.getId() %>');
		<%-- The placement configuration starts here --%>
		<%-- Set for a multi-page purchase/checkout flow --%>
		<% if (placement != null) { %>
			nds.setPlacement(<%=placement%>);
			nds.setPlacementPage(1);
		<% } %>
	});
} ());

var checkScoreSubmitted = false;// True, if form is submitted already

function checkScore(form) {
    if (checkScoreSubmitted) {
        console.log('Form is submitted already');
        return false;
    }

    $(form).find('.btn-submit').addClass('loading');
    checkScoreSubmitted = true;

    var data = getFormData(form, ['username', 'password']);
    //console.log('postForm', data);
    if ($('#nucaptcha-answer').length) {
        console.log('Have captcha input already');
        return true;
    }

    $.ajax({
        method: 'post',
        url: '<%= ssorestScoreEndpoint %>',
        //url: 'https://www.idfconnect.net/ssorest3/service/public/score',
        dataType: 'json',
        data: data,
        timeout: 15000,
        error: function(r, status) {
            console.log('Error: ', status, r.responseText);
            $('#statusCont').show();
            $('#status').text('Error loading captcha');
        },
        success: function(data) {
            //console.log('ok', data);
            if (data.parameters.requiredAction == 'Interdiction') {
                $('#status').html(data.parameters.html);
                var player = $('#nucaptcha-player');
                player.addClass('login-row-floating');
                player.children('label').addClass('floating-animate');
                player.children('input[type="text"]')
                        .addClass('input')
                        .bind('blur', function(e) { onInputBlur(e.currentTarget); })
                        .bind('focus', function(e) { onInputFocus(e.currentTarget); });
            }
            $('#statusCont').show();
        },
        complete: function () {
            $(form).find('.btn-submit').removeClass('loading');
            checkScoreSubmitted = false;
        },
    });

    return false;
}

function getFormData(form, fields) {
    var formData = {};
    for (var i = 0; i < form.elements.length; i++) {
        if (! fields || fields.indexOf(form.elements[i].name) !== -1) {
            formData[form.elements[i].name] = form.elements[i].value;
        }
    }

    return formData;
}

function onInputFocus(obj) {
    $(obj).siblings('label').addClass('floating-initial');
}

function onInputBlur(obj) {
    if (! $(obj).val().length) {
        $(obj).siblings('label').removeClass('floating-initial');
    }
}

$('document').ready(function() {
    setTimeout(function() {
        // Webkit autofill workaround
        try {
            if (!$('#username:-webkit-autofill').length) {
                onInputBlur(document.getElementById('username'));
            }
            if (!$('#password:-webkit-autofill').length) {
                onInputBlur(document.getElementById('password'));
            }
        } catch(e) {
            // Not webkit
            onInputBlur(document.getElementById('username'));
            onInputBlur(document.getElementById('password'));
        }
    }, 25);
});

</script>
</HEAD>

<BODY>
        <div id="header" class="wrap">
                <div id="logo">
                        <a href="/"><img src="<%=request.getContextPath() %>/style/idfclogo.png"/></a>
                </div>
                <div id="menu">
                </div>
        </div>

        <div id="main"  class="wrap">
                <div id="login">
                        <form name="logonForm" action="<%=fccURL%>" method="POST" onsubmit="return checkScore(this)">
                                <input type=hidden name=target value="<%=targetURL%>">
                                <input type=hidden name=smagentname value="<%=smagentname%>">
                                <input type=hidden name=smauthreason value="<%=smauthreason%>">
                                <input type=hidden name=smquerydata value="<%=smquerydata%>">
                                <input type=hidden name=postpreservationdata value="<%=postpreservation%>">
<%
	if (placementField != null && placement != null) {
%>
                                <input type=hidden name="<%= placementField %>" value="<%=placement%>">
<%  } %>
<%
	if (ppField != null && placementPage > 1) {
%>
                                <input type=hidden name="<%= ppField %>" value="<%=placementPage%>">
<%  } %>
<%
	if (rsField != null && reportSegment != null) {
%>
                                <input type=hidden name="<%= rsField %>" value="<%=reportSegment%>">
<%  } %>
                                <input type=hidden name="<%= nsidField %>" value="<%=session.getId()%>">

                                <table class="loginTable">
                                        <tr>
                                                <td colspan=2>
                                                    <div class="login-row-floating">
                                                        <label class="floating-animate floating-initial" for="username">Username</label>
                                                        <input onfocus="onInputFocus(this);" onblur="onInputBlur(this)" class="input-text-borderless" type="text" name="username" id="username">
                                                    </div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td colspan=2 class="login-row-floating">
                                                    <div class="login-row-floating">
                                                        <label class="floating-animate floating-initial" for="password">Password</label>
                                                        <input onfocus="onInputFocus(this);" onblur="onInputBlur(this)" class="input-text-borderless" type="password" name="password" id="password">
                                                    </div>
                                                </td>
                                        </tr>
                                        <tr><td colspan=2>
                                            <div id="statusCont" style="display: none">
                                            <div id="status" style="padding-top: 20px">
                                                </div>
                                            </div>
                                        </td></tr>
                                        <tr><td colspan=2>&nbsp;</td></tr>
                                        <tr>
                                                <td colspan=2 align=center>
                                                        <input type="submit" class="btn btn-submit" value="Submit" style="padding-right: 6px">
                                                        <input type="button" value="New Account" onclick="window.location.href='<%=selfRegURL %>'" style="padding-right: 6px">
                                                        <input type="button" value="Forgot Password" onclick="window.location.href='<%=forgottenPwdURL %>'">
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

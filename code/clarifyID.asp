<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  clarifyID.asp
//
// Description    :  Find a form based on the Clarify Form ID
//
// Author         :  Dovetail Software, Inc.
//                   4807 Spicewood Springs Rd, Bldg 4 Suite 200
//                   Austin, TX 78759
//                   (512) 610-5400
//                   EMAIL: support@dovetailsoftware.com
//                   www.dovetailsoftware.com
//
// Platforms      :  This version supports Clarify 9.0 and later
//
// Copyright (C) 2001-2012 Dovetail Software, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////
-->
<html>
<head>
<title></title>
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<style>
	body{font-size:12px;}
	#homeContainer{width:100%;}
	#homeContainer h4{text-align:left;}
	.nav{display:none !important;}
	a.brand{padding-left:25px !important;}
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "ClarifyID";
var sPageType = "Forms";

function DisplayConceptInfo(){
	rw("<h4>Sorry, I couldn't determine the form that got you here.</h4>");
	rw("<p>It appears you came here via a general help request, as opposed to from a form.</p>");
	rw("<p>This can happen if you click Help (or F1) while not having focus on a form.</p>");
	rw("<p>Try clicking Help (or F1) while your cursor has focus on a form or form element/control.</p>");
	rw("<hr/>");
	rw("<p>Additional Info:</p>");
	rw("<ul>");
	rw("<li>last part of uri:" + uriFile+ "	</li>");
	rw("<li>Request.QueryString:" + Request.QueryString + "</li>");
	rw("</ul>");
}

function DisplayNoFormInfo(){
	rw("<h4>Sorry, I couldn't figure out the form ID.</h4>");
	rw("<p>If you believe you received this message in error, please contact our support team at <a href='http://www.dovetailsoftware.com'>www.dovetailsoftware.com</a></p>");
	rw("<p>Be sure to include this information in your support request:</p>");
	rw("<ul>");
	rw("<li>Application: BOLT</li>");
	rw("<li>Page: clarifyID.asp</li>");
	rw("<li>Request.QueryString: " + Request.QueryString + "</li>");
	rw("</ul>");
}
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/parseuri.js"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row-fluid bottomMargin">
		<div class="span2"></div>
		<div id="homeContainer" class="span8">
<%
			var uriFile = parseUri(Request.QueryString).file;
			var formId = uriFile.replace(".html", "") + "";
			var noError = true;
				
			if(formId.length <= 1) {
				DisplayNoFormInfo();
				noError = false;
			}

			if(noError && formId.slice(0,6) == "concpt") {
				DisplayConceptInfo();
				noError = false;
			}

			if(noError) {
%>
			<h4>Clarify Form Identifier</h4>
			<hr/>
			<h4>It looks like you got here from <a href="#"  onclick="$('#formsonline').submit();">form <%=formId%></a>.</h4>

			<form method="POST" id="formsonline" name="formsonline" action="forms.asp" >
				<input type="hidden" name="attribute" value="id" />
				<input type="hidden" name="operator" value="equals" />
				<input type="hidden" name="filter" value="<%=formId%>" />
				<input type="hidden" name="which" value="all" />
			</form>
<%
			}
%>
		</div>
		<div class="span2"></div>
	</div>

</div>
</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
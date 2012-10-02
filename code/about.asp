<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  index.asp
//
// Description    :  Home page with links to Version History and Admin
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
.topMargin { margin-top: 40px; }
iframe.theme {
	width: 204px;
	height: 120px;
	margin: 1em;
	scrolling: no;
}
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "About";
var sPageType = "Master";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span12">
			<a href=http://www.dovetailsoftware.com><img src="img/dovetail.png" alt="Dovetail Software"></a>
		</div>
	</div>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 well well-small topMargin">
			<h2>About BOLT</h2>
    		<p>BOLT is a set of <u>B</u>rowser <u>O</u>n<u>L</u>ine <u>T</u>ools for the Clarify<sup>&reg;</sup> system.</p>
    		<p>View the <a href="version.asp">BOLT Version History</a>.</p>
		</div>
		<div class="span2"></div>
	</div>

	<%if (!(udl_file.Attributes & 1) ){%>
	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 well well-small topMargin">
			<h2>Administration</h2>
			<p>Configure the database connection using the <a href="admin.asp">Administration page</a>.</p>
		</div>
		<div class="span2"></div>
	</div>
	<%}%>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 well well-small topMargin">
			<h2>Change Theme</h2>
			<p>Click on a theme below to change the theme used for Dovetail Bolt.</p>

			<iframe class="theme" src="themes/baseline.asp" scrolling="no"></iframe>
			<iframe class="theme" src="themes/cyborg.asp" scrolling="no"></iframe>
			<br/>
			<iframe class="theme" src="themes/cerulean.asp" scrolling="no"></iframe>
			<iframe class="theme" src="themes/readable.asp" scrolling="no"></iframe>

			<input type="hidden" id="newTheme" />
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 well well-small topMargin">
			<h2>Clarify Form Identifier</h2>
    		<p>A secret little feature you just might find useful: <a href="clarifyID_help.asp">Clarify Form Identifier</a>.</p>
		</div>
		<div class="span2"></div>
	</div>


<!--#include file="inc/footer.inc"-->
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#newTheme").click(function() {
		var themePath = $(this).val() + "";
		if(themePath > "") themePath = themePath + "/";
		$.cookie("boltTheme", themePath, { expires: 365 });
		window.location.href = path;
	});
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>

<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  clarifyID_help.asp
//
// Description    :  Help page for the Clarify Form Identifier
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
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.css" rel="stylesheet">
<style>
#headerContainer { margin-top: 20px;margin-bottom: 40px; }
h1, h2, h4 { margin-top: 20px;margin-bottom: 20px; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Child Forms/Tabs";
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<%
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">

			<h1>Help page for the Clarify Form Identifier</h1>

			<h2>Background</h2>

			<p>On occasion, while working in the Clarify Classic Client, we come across a form that's not familiar to us, but we need
			to do some work on. It could be a baseline or a custom form. Trying to find this form in UI Editor is not always easy. It's
			common that the form name and/or title aren't very descriptive (this even happens on baseline forms). </p>

			<p>The <strong>Clarify Form Identifier</strong> can help. It uses the HTML Help feature built into the Clarify Client to
			help you determine the exact form ID number. </p>

			<h2>Usage</h2>

	 		<p>From within the Clarify Client, press the F1 key on a form (or use the Help menu option). <br/>
			You should see a browser window open that looks like this:</p>

			<img src="img/bolt_help.jpg" alt="form identifier" />

			<h2>Requirements</h2>

	 			<ul> <li>This feature requires IIS7 (Support for IIS6 may be added in the future, depending
				on customer demand)</li> <li>HTTP Redirection component of IIS</li> </ul>

			<p>In IIS Manager, you should see the HTTP Redirection component:</p>

			<img src="img/iis.png" alt="IIS Redirection component" />

			<h4>If the HTTP Redirection component is not installed</h4>

		 	<p>In Windows Server, open Server Manager -> Roles -> Web Server -> Add Role Services -> Common HTTP Features -> HTTP
		 	Redirection. Check the box, click Next, click Install.</p>

			<p>In Windows 7, Start -> Control Panel -> Programs and Features -> Turn Windows Features on or off. Expand Internet
			Information Services, then World Wide Web Services, then Common Http Features. Select HTTP Redirection, and then click
			OK.</p>

			<p>You can also use the <a href="http://www.microsoft.com/web/downloads/platform.aspx">Web Platform Installer</a> to
			install HTTP Redirection. Click the Web Platform tab and under the Web Server heading click Customize. In the Common HTTP
			Features section, check HTTP Redirection and click Install.</p>

			<h2>Setup</h2>

			<h4>Help enable your database</h4>

	 		<p>Import the $bolt/files/help.dat file using dataex, DIET, or UI Editor </p>

			<h4>Configure your Clarify Client</h4>

	 		<ul> <li>In clarify.exe: Desktop --> My setup --> My preferences <li>set the web server to: http://server/bolt/ClarifyID
	 		(where server is the web server running BOLT)</li> <li>set the help file location to be blank</li> <li>set the on-line help
	 		drop down to be HTML Help</li> </ul>

			<img src="img/preferences.jpg" alt="preferences" />

			<h2>Need more help?</h2>

			<p>Contact us at <a href=http://support.dovetailsoftware.com>support.dovetailsoftware.com</a>.</p>

		</div>
		<div class="span2"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
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
<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  formsonline.asp
//
// Description    :  Filter for Forms
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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="bs4/css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style4.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Forms";
var sPageType = "Forms";

//Set the Default control for focus
var sDefaultControl = "filter";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar4.inc"-->
<div class="container-fluid">
		<div class="col-8 offset-2">
			<h3>Search for Forms where</h3>
			<form method="POST" name="formsonline" id="formsonline" action="forms.asp" class="mt-3">
				<div class="row">
					<div class="input-group input-group-sm">
						<select id="attribute" name="attribute" class="form-control col-4 mr-2">
							<option selected value="title">Title</option>
							<option value="dialog_name">Name</option>
							<option value="id">ID</option>
							<option value="description">Description</option>
							<option value="ver_clarify">Clarify Version</option>
							<option value="ver_customer">Customer Version</option>
						</select>

						<select name="operator" class="form-control col-2 mr-2">
							<option selected value="starts">starts with</option>
							<option value="ends">ends with</option>
							<option value="equals">equals</option>
							<option value="contains">contains</option>
						</select>

						<input type="text" id="filter" name="filter" class="form-control col-3 mr-2" />

						<button id="formSearchButton" class="btn btn-info btn-sm">Search</button>
					</div>

					<div class="input-group input-group-sm">
						<select name="which" id="which" class="form-control col-4 mt-3">
					   	<option selected value="all">Search all forms</option>
					   	<option value="custom">Search only custom forms</option>
					   	<option value="baseline">Search only baseline forms</option>
						</select>
					</div>
				</div>
			</form>

			<p id="showControlSearch" class="mt-3">You can also <a href=# onClick="toggleSearch();">search for a particular control</a>.</p>
			<p id="hideControlSearch" class="invisible"><a href=# onClick="toggleSearch();">Hide the Search for Controls section</a></p>

			<div id="controlsSearchArea" class="invisible">
				<h3>Search for Controls where</h3>

				<form method="POST" name="controlSearchForm" id="controlSearchForm" action="controls.asp">
					<div class="row">
						<div class="input-group input-group-sm">
							<select name="attribute" class="form-control col-4 mr-2">
								<option selected value="control_name">Control Name</option>
								<option value="control_label">Control Label</option>
								<option value="win_id">Form ID</option>
								<option value="win_name">Form Name</option>
								<option value="clarify_ver">Clarify Version</option>
								<option value="customer_ver">Customer Version</option>
							</select>

							<select name="operator" class="form-control col-2 mr-2">
								<option selected value="starts">starts with</option>
								<option value="ends">ends with</option>
								<option value="equals">equals</option>
								<option value="contains">contains</option>
							</select>

							<input type="text" id="controlFilter" name="controlFilter" class="form-control col-3 mr-2" />

							<button id="controlSearchButton" class="btn btn-info btn-sm">Search</button>
						</div>

						<div class="input-group input-group-sm">
							<select name="which" id="which" class="form-control col-4 mt-3">
						    <option selected value="all">Search for All Control Types or limit to...</option>
						    <option value="4">Button</option>
						    <option value="0">Static Text</option>
						    <option value="2">Bitmap</option>
						    <option value="3">Multi-Line Edit</option>
						    <option value="5">Option Button/Tab</option>
						    <option value="6">Check Box</option>
						    <option value="7">Dropdown List Box</option>
						    <option value="9">List Box</option>
						    <option value="11">Dropdown Combo Box</option>
						    <option value="13">Grid</option>
						    <option value="14">Group Box</option>
						    <option value="7">Dropdown List Box</option>
						    <option value="9">List Box</option>
						    <option value="11">Dropdown Combo Box</option>
						    <option value="18">Select CBX</option>
						    <option value="19">Line</option>
						    <option value="20">Active X Control</option>
						    <option value="21">Graph</option>
						    <option value="22">UpDown</option>
						    <option value="23">Progress Bar</option>
						    <option value="24">Slider</option>
						    <option value="25">Animation</option>
						    <option value="26">Tree View</option>
						  </select>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript">
function toggleSearch(){
	$("#controlsSearchArea, #hideControlSearch, #showControlSearch").toggleClass("invisible");
	$(".filter:not(:hidden)").focus();
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	if($("#controlsSearchArea #controlFilter").val().length > 0) toggleSearch();
	$("#filter").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
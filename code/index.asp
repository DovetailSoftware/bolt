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
// Description    :  Selection page for Database objects (app default)
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
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/font-awesome.min.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Schema";
var sPageType = "Schema";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<!--#include file="inc/notifications.inc"-->
<div class="container-fluid">
	<div class="row-fluid mb-3">
		<div id="homeContainer" class="col-8 offset-2 mt-1">
			<h3 class="mb-3 text-center">Schema Search</h3>
			<center>
			<table>
				<tr>
					<td>Tables/Views whose name starts with</td>
					<td>
						<div class="input-group input-group-sm ml-2 mt-1">
  						<input type="text" class="form-control" id="type_name" />
  						<span class="btn btn-primary input-group-addon" id="ddonline"><i class="fa fa-search"></i></span>
						</div>
  				</td>
				</tr>
				<tr>
					<td>Tables/Views whose ID equals</td>
					<td>
						<div class="input-group input-group-sm ml-2 mt-1">
							<input type="text" class="form-control" id="type_id" />
							<span class="btn btn-primary input-group-addon" id="ddonline2"><i class="fa fa-search"></i></span>
						</div>
					</td>
				</tr>
				<tr>
					<td>Tables/Views that contain a field named</td>
					<td>
						<div class="input-group input-group-sm ml-2 mt-1">
						<input type="text" class="form-control" id="field_name" />
							<span class="btn btn-primary input-group-addon" id="fieldButton"><i class="fa fa-search"></i></span>
							<input type="hidden" value="search_by_field_name" id="search_type" />
						</div>
					</td>
				</tr>
				<tr>
					<td>Tables that contain a relation name starting with</td>
					<td>
						<div class="input-group input-group-sm ml-2 mt-1">
							<input type="text" class="form-control" id="rel_name" />
							<span class="btn btn-primary input-group-addon" id="relationButton"><i class="fa fa-search"></i></span>
						</div>
					</td>
				</tr>
				<tr>
					<td>User-Defined Tables/Views whose name starts with</td>
					<td>
						<div class="input-group input-group-sm ml-2 mt-1">
							<input type="text" class="form-control" id="type_custom" />
							<span class="btn btn-primary input-group-addon" id="customButton"><i class="fa fa-search"></i></span>
						</div>
					</td>
				</tr>
			</table>

			<h5 class="mt-3 mb-5 text-center"><a href="schema_id_info.asp">More information about User-Defined Table/View IDs</a></h5>
		</div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->

</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/notifications.js"></script>
<script type="text/javascript" src="js/schemaValidate.js"></script>
<script type="text/javascript">
function submitFormByName(strUrl, fieldName) {
	if(!validate_filter(fieldName)) return;
	window.location = strUrl + "?" + fieldName + "=" + $("#" + fieldName).val() + "&custom=0";
}

function submitFormById(strUrl, fieldName) {
	if(!validate_id(fieldName)) return;
	window.location = strUrl + "?" + fieldName + "=" + $("#" + fieldName).val() + "&custom=0";
}

function submitCustom() {
	if(!validate_filter("type_custom")) return;
	window.location = "tables.asp?type_name=" + $("#type_custom").val() + "&custom=1";
	submitFormByName("", "");
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#type_name").keypress(function(event) {
		if(event.keyCode == 13) $("#ddonline").click();
	});
	$("#ddonline").click(function() {
		submitFormByName("tables.asp", "type_name");
	});

	$("#type_id").keypress(function(event) {
		if(event.keyCode == 13) $("#ddonline2").click();
	});
	$("#ddonline2").click(function() {
		submitFormById("tables.asp", "type_id");
	});

	$("#field_name").keypress(function(event) {
		if(event.keyCode == 13) $("#fieldButton").click();
	});
	$("#fieldButton").click(function() {
		submitFormByName("search_fields.asp", "field_name");
	});

	$("#rel_name").keypress(function(event) {
		if(event.keyCode == 13) $("#relationButton").click();
	});
	$("#relationButton").click(function() {
		submitFormByName("search_rels.asp", "rel_name");
	});

	$("#type_custom").keypress(function(event) {
		if(event.keyCode == 13) $("#customButton").click();
	});
	$("#customButton").click(submitCustom);

	$("#type_name").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
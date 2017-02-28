<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  union_view.asp
//
// Description    :  Union View Details
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
<link href="css/style4.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var rsSpecRelID;

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
var type_name = GetTableName(type_id);
var sPageTitle = "Details for Union View: " + type_name;
var sPageType = "Schema";
//Update the Recent Cookie Collection
UpdateCookies();
%>
<!--#include file="inc/quicklinks.inc"-->
<!--#include file="inc/viewDetails.js"-->
</head>
<body>
<!--#include file="inc/navbar4.inc"-->
<div class="container-fluid">
	<div class="row">
    <div class="col-6 offset-3 card bg-faded">
			<%
				//Get the base table
				var TheLink = getBaseTableLink();
				outputViewHeader("Union ", TheLink);
			%>
		</div>
		<div class="col-3">
			<%
				var select_sql = "select * from table_" + type_name;
				var encoded_select_sql = Server.URLEncode(select_sql);
				//See if it has filter SQL
				var filterSQL = getFilterSQL();
				var unionViewsList = [];
				hyperlinksTable();
			%>
		</div>
	</div>

	<div class="row">
		<div id="fieldsContainer" class="col-12">
		<% outputViewFields(); %>
		</div>
	</div>

	<!--#include file="inc/recent_objects4.asp"-->
	<!--#include file="inc/quick_links4.asp"-->
</div>
</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript" src="js/addEvent.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";
	addEvent(window, "hashchange", function() { scrollBy(0, -50) });

  $(".tablesorter").tablesorter();
	$(".tablesorter tr").click(function () {
	   $(this).children("td").toggleClass("highlight");
	});
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
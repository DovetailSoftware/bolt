<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  lists.asp
//
// Description    :  List Viewer
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
<link href="css/tablesorter.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Lists";
var sPageType = "lists";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
	TheSQL = "select objid, title from table_gbst_lst";
	rsGbst = retrieveDataFromDB(TheSQL);

	TheSQL = "select objid, title from table_hgbst_lst";
	rsHgbst = retrieveDataFromDB(TheSQL);
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row">
		<div id="gbstContainer" class="col-4 offset-2">
			<h3>Application Lists</h3>
			<table id="gbst" class="tablesorter">
				<thead>
					<tr>
						<th>Title</th>
					</tr>
				</thead>
				<tbody>
				<% while (!rsGbst.EOF) { %>
				 <tr>
				 	<td>
				 	<% listTarget = "<a href='gbstList.asp?objid=" + rsGbst("objid") + "&title=" + rsGbst("title") + "'>" + rsGbst("title") + "</a>";
				 		rw(listTarget); %>
				 	</td>
				 </tr>
				 <% rsGbst.MoveNext(); } %>
				</tbody>
			</table>
		</div>

		<div id="hgbstContainer" class="col-4">
			<h3>User Defined Lists</h3>
			<table class="tablesorter">
				<thead>
					<tr>
						<th>Title</th>
					</tr>
				</thead>
				<tbody>
				<% while (!rsHgbst.EOF) { %>
				 <tr>
				 	<td>
				 	<% listTarget = "<a href='hgbstList.asp?objid=" + rsHgbst("objid") + "&title=" + rsHgbst("title") + "'>" + rsHgbst("title") + "</a>";
				 		rw(listTarget); %>
				 	</td>
				 </tr>
				 <% rsHgbst.MoveNext(); } %>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter();

	$("#gbstContainer, #hgbstContainer").on("click", ".tablesorter tbody tr", function () {
	   $(this).children("td").toggleClass("highlight");
	});
});
</script>
</html>
<%
rsGbst.Close();
rsGbst = null;
rsHgbst.Close();
rsHgbst = null;
FSO = null;
udl_file = null;
%>
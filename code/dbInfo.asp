<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  dbInfo.asp
//
// Description    :  Database Information
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
<link href="css/tablesorter.css" rel="stylesheet">
<style>
.tablesorter tbody td { width: 50%; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var type_name = Request("type_name");
var rsSpecRelID;

var sPageTitle = "Database Info";
var sPageType = "DB Info";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<%
	TheSQL = "select * from " + GLOBAL_HEADER_TABLE;
	rsADP = Server.CreateObject("ADODB.Recordset");
	rsADP.CursorLocation = gCursorLocation;
	rsADP.ActiveConnection = dbConnect;
	rsADP.Source = TheSQL;
	try {
		rsADP.Open();
	} catch(e) {
		displayDBAccessErrorPage(e);
	}
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">
			<h3>Database Information</h3>

			<table class="tablesorter simple">
				<thead>
				<tr>
					<th>ADP DB Header Information</th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
				<% var fldCount = rsADP.Fields.Count;
			    	for (count=1;count <= fldCount;count++) { %>
				<tr>
					<td><b><%=rsADP.Fields(count -1).Name%></b></td>
					<td><%=rsADP.Fields(count -1)%></td>
				</tr>
				<% } %>
				</tbody>
			</table>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="hyperlinksContainer" class="span8">
			<%
			var case_insensitive = ((rsADP("flags") & 1) > 0);
			var password_encrypted = ((rsADP("flags") & 2) > 0);
			var dwe_enabled = ((rsADP("flags") & 4) > 0);
			var secure_query = ((rsADP("flags") & 8) > 0);
			var vtext_supported = ((rsADP("flags") & 16) > 0);
			var mobile = ((rsADP("flags") & 32) > 0);
			var unicode = ((rsADP("flags") & 64) > 0);
			var schMgr_running = ((rsADP("flags") & 4096) > 0);
			%>

			<table class="tablesorter simple">
				<thead>
				<tr>
					<th>Database Flags</th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td><b>Case Insensitive</b></td>
					<td><%=case_insensitive%></td>
				</tr>
				<tr>
				<tr>
					<td><b>Password Encrypted</b></td>
					<td><%=password_encrypted%></td>
				</tr>
				<% if(ver < AMDOCS_75) { %>
				<tr>
					<td><b>DWE Enabled (Distributed Workflow Engine)</b></td>
					<td><%=dwe_enabled%></td>
				</tr>
				<% } %>
				<tr>
					<td><b>Secure Query</b></td>
					<td><%=secure_query%></td>
				</tr>
				<% if(ver >= AMDOCS_75) { %>
				<tr>
					<td><b>Database Supports vtext</b></td>
					<td><%=vtext_supported%></td>
				</tr>
				<% } %>
				<% if(ver < AMDOCS_75) { %>
				<tr>
					<td><b>Mobile (Traveler)</b></td>
					<td><%=mobile%></td>
				</tr>
				<% } %>
				<tr>
					<td><b>Unicode</b></td>
					<td><%=unicode%></td>
				</tr>
				<% if(ver >= AMDOCS_75) { %>
				<tr>
					<td><b>SchemaMgr Is Running</b></td>
					<td><%=schMgr_running%></td>
				</tr>
				<% } %>
				</tbody>
			</table>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="fieldsContainer" class="span8">
			<table class="tablesorter simple">
				<thead>
				<tr>
					<th>Additional Database Information</th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td><b>Database Type</b></td>
					<td><%=dbType%></td>
				</tr>
				<tr>
					<td><b>Clarify Version</b></td>
					<td><%=GetClarifyRelease()%></td>
				</tr>
				<tr>
					<td><b>Database Server</b></td>
					<td><%=database_server%></td>
				</tr>
				<tr>
					<td><b>Database Name</b></td>
					<td><%=database_name%></td>
				</tr>
				<tr>
					<td><b>Comments Field</b></td>
					<td><%=comment_field%></td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="relationsContainer" class="span8">
			<table class="tablesorter simple">
				<thead>
				<tr>
					<th>ADO Information</th>
					<th>Data</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td><b>Data Source</b></td>
					<td><%=rsADP.ActiveConnection.Properties("Data Source")%></td>
				</tr>
				<tr>
					<td><b>Provider</b></td>
					<td><%=rsADP.ActiveConnection.Provider%></td>
				</tr>
				<tr>
					<td><b>User Id</b></td>
					<td><%=rsADP.ActiveConnection.Properties("User Id")%></td>
				</tr>
				<tr>
					<td><b>ADO Version</b></td>
					<td><%=rsADP.ActiveConnection.Version%></td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="span2"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

   $(".tablesorter").tablesorter({
      headers: { 1: { sorter: false } }
   });
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
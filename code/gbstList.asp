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
<meta http-equiv="expires" content="0" />
<meta name="KeyWords" content="" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="Shortcut Icon" href="favicon.ico" />
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet" />
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Application List";
var sPageType = "lists";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
	var objid = Request("objid") - 0;
	var title = Request("title") + "";
	var rsLocElm = null;

	TheSQL = "select objid, title, rank, state from table_gbst_elm where gbst_elm2gbst_lst = " + objid + " order by rank asc";
	rsGbst = retrieveDataFromDB(TheSQL);

  var theSQL = "select type_id from adp_tbl_name_map where type_name = 'fc_loc_elm'";
  var boLocElm = retrieveDataFromDB(theSQL);
  var locElmFound = (!boLocElm.EOF);
  boLocElm.Close();

	if (locElmFound) {
	  TheSQL = "select count(*) from table_fc_loc_elm";
		rsLocalizations = retrieveDataFromDBStatic(TheSQL);
		var hasLocalizations = ((rsLocalizations(0) + 0) > 0);
		rsLocalizations.Close();
		if (!hasLocalizations) locElmFound = false;
	}
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row">
		<div id="gbstContainer" class="col-8 offset-2">

			<h5 class="text-right"><a href="lists.asp">(Back to Lists)</a></h5>
			<h3>Application List: <%=title%></h3>

			<table class="tablesorter localized">
				<thead>
					<tr>
						<th>Title</th>
						<th>Rank</th>
						<th>Status</th>
   					<% if (locElmFound) { %>
						<th>Localizations</th>
   					<% } %>
					</tr>
				</thead>
				<tbody>
				<% while (!rsGbst.EOF) {
					var state = rsGbst("state") - 0;
					var status = "Active";
					if (state == 2) status = "Default";
					if (state == 1) status = "Inactive";
				%>
				<tr>
				 	<td title="<%=rsGbst("objid")%>"><% rw(rsGbst("title") + ""); %></td>
				 	<td><% rw(rsGbst("rank") - 0); %></td>
				 	<td><% rw(status); %></td>
 					<% if (locElmFound) { %>
				 	<td class="bare">
				  <%
				  var locs = -1;
          if (locElmFound) {
	          TheSQL = "select locale, title from table_fc_loc_elm where fc_loc_elm2gbst_elm = " + (rsGbst("objid") - 0) + " order by locale asc";
		        rsLocElm = retrieveDataFromDB(TheSQL);
					  if (!rsLocElm.EOF) locs = rsLocElm.RecordCount;
          }
				  if (locs > 1) {
   				%>
   				 	<select>
   				<%
				  }
          if (locElmFound) {
					  while (!rsLocElm.EOF) {
	   					var locale = rsLocElm("locale") + "";
		   				var title = rsLocElm("title") + "";
	   				  if (locs > 1) {
   				%>
   					 	<option><% rw(locale + ": " + title); %></option>
   				<%
	   				  } else {
	      			 	rw(locale + ": " + title);
	   				  }
	            rsLocElm.MoveNext();
	   				}
				  }
				  if (locs > 1) {
   				%>
   				  </select>
   				<%
			    }
				  %>
	        </td>
 					<% } %>
				</tr>
				<% rsGbst.MoveNext(); } %>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter({ sortList: [[1,0]], });

	$("#gbstContainer").on("click", ".tablesorter tbody tr", function () {
	   $(this).children("td").toggleClass("highlight");
	});
});
</script>
</html>
<%
rsGbst.Close();
rsGbst = null;
if (rsLocElm) rsLocElm.Close();
rsLocElm = null;
FSO = null;
udl_file = null;
%>
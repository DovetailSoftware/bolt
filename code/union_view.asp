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
<title></title>
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var type_name = Request("type_name");
var rsSpecRelID;

var sPageTitle = "Details for Union View: " + type_name;
var sPageType = "Schema";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

//Update the Recent Cookie Collection
UpdateCookies();
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<!--#include file="inc/viewDetails.js"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8 topMargin">
		<%
			//Get the base table
			var TheLink = getBaseTableLink();

			//Page Header:
			outputViewHeader("Union ", TheLink);
		%>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="hyperlinksContainer" class="span8">
		<%
			//See if it has filter SQL
		   var filterSQL = getFilterSQL();
			var unionViewsList = [];

			hyperlinksTable();
		%>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div id="fieldsContainer" class="span12">
		<% outputViewFields(); %>
		</div>
	</div>

	<div class="row-fluid">
		<div id="joinsContainer" class="span12">
		<%
//			//Get the List of Joins for this View
//		   var TheSQL = TheSQL = "select ac.type_name, ac.type_id, aj.join_flag from adp_object ao join adp_join aj on aj.view_type_id = ao.type_id join adp_object ac on aj.obj_type_id = ac.type_id where ao.type_id = " + type_id;
//			rsJoins = retrieveDataFromDB(TheSQL);
//
//			//Build the table header
//			rw("<h4 name='views'>Contributing Views:</h4>");
//			rw("<table id='joins' class='tablesorter fullWidth'>");
//			rw("<thead><tr>");
//			rw("<th>");
//			rw("View ID");
//			rw("</th>");
//			rw("<th>");
//			rw("View Name");
//			rw("</th>");
//			rw("<th>");
//			rw("Union Type");
//			rw("</th>");
//			rw("</tr></thead>");
//			rw("<tbody>");
//
//			while (!rsJoins.EOF){
//				ObjectType = rsJoins("type_name") + "";
//				ObjectTypeID = rsJoins("type_id") + "";
//				JoinFlag = rsJoins("join_flag") + 0;
//				rw("<tr");
//				rw("<td>");
//				rw(ObjectTypeID);
//				rw("</td>");
//				rw("<td>");
//
//				//Make the View Name be a hyperlink:
//			   TheLink = "<a href=view.asp?type_id=";
//			   TheLink += ObjectTypeID;
//			   TheLink += "&type_name=";
//			   TheLink += ObjectType;
//			   TheLink += ">" + ObjectType;
//			   TheLink += "</a>";
//
//				rw(TheLink);
//				rw("</td>");
//				rw("<td>");
//				rw((JoinFlag > 10) ? "UNION ALL" : "UNION");
//				rw("</td>");
//				rw("</tr>");
//
//				rsJoins.MoveNext();
//			}
//
//			rw("</tbody>");
//			rw("</table>");
//
//			rsJoins.Close;
//			rsJoins = null;
//
//			//Print the filter
//			if(filterSQL != '') {
//				rw("<h4 name='filters'>Filters:</h4>");
//				rw(filterSQL.replace(/\n/g, "<br>"));
//			}
		%>
		</div>
		<div class="span2"></div>
	</div>


	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/recent_objects.asp"-->
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/quick_links.asp"-->
		</div>
		<div class="span2"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

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
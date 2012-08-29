<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  views.asp
//
// Description    :  List of View Details
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
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<style>
.bottomMargin { margin-bottom: 6em; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Views";
var sPageType = "Schema";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid bottomMargin">
		<div id="homeContainer" class="span12">

		<% var TableNum = Request("type_id");
			var SpecFieldID = Request("spec_field_id");
			var FieldName = Request("field_name");
			var TableName = GetTableName(TableNum);

			//First, get the list of views where this field is used
			var TheSQL = "select distinct from_obj_type, from_field_id, view_type_id  from adp_view_field_info where from_obj_type = ";
			TheSQL += TableNum ;
			TheSQL += " and from_field_id = ";
			TheSQL += SpecFieldID;
			TheSQL +=" order by view_type_id";
			rsViews = retrieveDataFromDB(TheSQL);

			if(rsViews.EOF) rw("<h3>" + TableName + Dot + FieldName + " is not used in any views</h3>");

			if(!rsViews.EOF) {
				//Page Header:
				rw("<h3>List of Views where " + TableName + Dot + FieldName + " is referenced" + "</h3>");

				//Table Header:
				rw("<table class='tablesorter fullWidth'>");
				rw("<thead><tr>");
				rw("<th>");
				rw("View ID");
				rw("</th>");
				rw("<th>");
				rw("View Name");
				rw("</th>");
				rw("</tr></thead>");
				rw("<tbody>");

				while(!rsViews.EOF)	{
					var ViewNum = rsViews(VIEW_ID);

					rw("<tr>");
					rw("<td>");
					rw(ViewNum);
					rw("</td>");
					rw("<td>");

					//Make a hyperlink
					var TheLink = BuildViewHyperLink(ViewNum);

					rw(TheLink);
					rw("</td>");
					rw("</tr>");

					rsViews.MoveNext();
				}

				rw("</tbody>");
				rw("</table>");
         }

			rsViews.Close;
			rsViews = null;
		%>
		</div>
	</div>

	<div class="row-fluid">
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
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter({
	   headers: {
	      // the first column is the "id_number" column
	      0: {
	         // force custom sort for id_number
	         sorter: "id_number"
	      }
	   }
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
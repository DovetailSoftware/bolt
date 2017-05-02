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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
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
	<div class="row">
		<div id="homeContainer" class="col-12">

		<% var TableNum = Request("type_id");
			var TableName = GetTableName(TableNum);
         var forField = true;

         // views for field
			var SpecFieldID = Request("spec_field_id") - 0;
			var FieldName = Request("field_name") + "";

         // views for relation
			var SpecRelID = Request("spec_rel_id") - 0;
			var RelationName = Request("rel_name") + "";

         if (FieldName != "undefined") {
   			//Get the list of views where this field is used
	   		var TheSQL = "select distinct from_obj_type, from_field_id, view_type_id  from adp_view_field_info where from_obj_type = " + TableNum;
		   	TheSQL += " and from_field_id = " + SpecFieldID;
         } else {
            forField = false;
   			//Get the list of views where this relation is used
	   		var TheSQL = "select distinct obj_type_id, obj_spec_rel_id, view_type_id  from adp_view_join_info where obj_type_id = " + TableNum;
		   	TheSQL += " and obj_spec_rel_id = " + SpecRelID;
         }

			TheSQL +=" order by view_type_id";
			rsViews = retrieveDataFromDB(TheSQL);

			if(rsViews.EOF) rw("<h3>" + TableName + Dot + ((forField)? FieldName : RelationName) + " is not used in any views</h3>");

			if(!rsViews.EOF) {
				//Page Header:
				rw("<h3>List of Views where " + TableName + Dot + ((forField)? FieldName : RelationName) + " is referenced" + "</h3>");

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
	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
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
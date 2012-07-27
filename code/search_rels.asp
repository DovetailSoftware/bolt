<%@ Language="JavaScript" codepage=65001 %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  search_rels.asp
//
// Description    :  List of Relations found in Tables/Views
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
<link href="css/jquery.tablesorter.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Relations";
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
		<div id="headerContainer" class="span12 topMargin">
		<%
			var name_filter=Request("rel_name");
			var name_filter = SQLFixup(name_filter);

			//Get the list of tables/views where this field exists
			var TheSQL = "select * from " + TABLE_TABLE + " where " + ID_FIELD + " in (";
			TheSQL += "select " + ID_FIELD;
			TheSQL += " from " + RELATION_TABLE;
			TheSQL += " where " + REL_NAME_FIELD + " like '";
			TheSQL += name_filter;
			TheSQL += "%')";

			rsTables = retrieveDataFromDBStatic(TheSQL);

			//If we only have one, then redirect to the details page for that table/view
			if (rsTables.RecordCount == 1) {
				TableName = rsTables(NAME_FIELD);
				TableNum = rsTables(ID_FIELD);
				Flags = rsTables(FLAGS_FIELD);
				Flags = Flags & VIEW_FIELD_BIT;

				if (Flags > 0) {
					TheLink = BuildViewURL(TableNum, TableName);
				} else {
					TheLink = BuildTableURL(TableNum, TableName);
				}
				Response.Redirect(TheLink);
			}

			//If we have none, say so
			if (rsTables.EOF) {
				rw("<h3 align='center'>No matches for relation name = '" + name_filter + "'</h3>");
			} else {

				//If we are still here, then we are building a list of tables
				//Page Header:
				rw("<h3>Tables/Views containing a relation named like '" + name_filter + "'</h3>");

				//Table Header
				rw("<table class='tablesorter fullWidth topMargin'>");
				rw("<thead><tr>");
				rw("<th>");
				rw("Table ID");
				rw("</th>");
				rw("<th>");
				rw("Table Name");
				rw("</th>");
				rw("<th>");
				rw("Comment");
				rw("</th>");
				rw("</tr></thead>");

				while (!rsTables.EOF) {
					TableName = rsTables(NAME_FIELD);
					TableNum = rsTables(ID_FIELD);
					Flags = rsTables(FLAGS_FIELD);
					TableComment = Server.HTMLEncode((rsTables(comment_field)));

					rw("<tr>");
					rw("<td>");
					rw(TableNum);
					rw("</td>");
					rw("<td>");
					//If the flag 512 bit is on, then this is a view, so build a different link
					//Flags = Flags & 512;
					Flags = Flags & VIEW_FIELD_BIT;
					if (Flags > 0) {
						TheLink = BuildViewHyperLink(TableNum, TableName);
					} else {
						TheLink = BuildTableHyperLink(TableNum, TableName);
					}
					rw(TheLink);
					rw("</td>");
					rw("<td>");
					rw(TableComment + "&nbsp;");
					rw("</td>");
					rw("</tr>");

					rsTables.MoveNext();
				}
				rw("</table>");
			}

			rsTables.Close;
			rsTables = null;
		%>
		</div>
	</div>

</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
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
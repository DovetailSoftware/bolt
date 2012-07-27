<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  forms.asp
//
// Description    :  Details about a Form
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
<style>
#headerContainer table { margin: 10px auto; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Forms";
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row-fluid">
		<div id="headerContainer" class="span12 topMargin">
		<%	Attribute = Request("attribute");
			Operator = Request("operator");
			Filter = Request("filter");
			var which = Request.Form("which");

			if (Attribute == "ID") Filter = Filter - 0;
			Filter = SQLFixup(Filter);

			//Get the list of forms
			TheSQL = "select * from table_window_db where " + Attribute;

			//Build the correct where clause depending on the data passed in
			switch (Operator + ""){
				case "starts":
					TheSQL+= " like '" + Filter + "%'";
					break;
				case "ends":
					TheSQL+= " like '" + "%" + Filter + "'";
					break;
				case "contains":
					TheSQL+= " like " + "'%" + Filter + "%'";
					break;
				case "equals":
					TheSQL+= " = '" + Filter + "'";
					break;
				default:
					TheSQL+= " like '" + Filter + "%'";
			}

			if (which == "baseline"){
				TheSQL+=" and base_flag = 'B' ";
			}
			if (which == "custom"){
				TheSQL+=" and base_flag <> 'B' ";
			}

			//Build the Order By Clause
			TheSQL+=" order by title";

			rsForms = retrieveDataFromDBStatic(TheSQL);

			//If we only have one, then redirect to the details page for that form
			if (rsForms.RecordCount == 1) {
				FormObjid = rsForms("objid");
				FormId = rsForms("id");
				TheLink = BuildFormURL(FormObjid, FormId)
				Response.Redirect(TheLink);
			}

			//If we have none, say so & exit
			if (rsForms.EOF) {
				rw("<h3 align='center'>No matches</h3>");
				rw("</body>");
				rw("</html>");
				Response.End
			}

			//If we're still here, then we're building a list of forms
			//Page Header:
			rw("<h3 align='center'>Forms</h3>");
			//Table Header
			rw("<table class='tablesorter'>");
			rw("<thead><tr>");
			rw("<th>");
			rw("Title");
			rw("</th>");
			rw("<th>");
			rw("Name");
			rw("</th>");
			rw("<th type=Number>");
			rw("Form ID");
			rw("</th>");
			rw("<th>");
			rw("Clarify Ver");
			rw("</th>");
			rw("<th>");
			rw("User Ver");
			rw("</th>");
			rw("<th>");
			rw("Description");
			rw("</th>");
			rw("</tr></thead>");
			rw("<tbody>");

			while (!rsForms.EOF)	{
				FormTitle = CleanUpString(rsForms("title"));
				FormVerClarify = CleanUpString(rsForms("ver_clarify"));
				FormVerCust = CleanUpString(rsForms("ver_customer"));
				FormID = rsForms("id");
				FormObjid = rsForms("objid");
				FormName = rsForms("dialog_name");
				FormDescription = CleanUpString(rsForms("description"));

				rw("<tr>");
				rw("<td>");
				//We want the FormTitle to be a HyperLink
				rw(BuildHyperLink(BuildFormURL(FormObjid,FormID) ,FormTitle));
				rw("</td>");
				rw("<td>");
				rw(FormName);
				rw("</td>");
				rw("<td>");
				rw(FormID);
				rw("</td>");
				rw("<td>");
				rw(FormVerClarify);
				rw("</td>");
				rw("<td>");
				rw(FormVerCust);
				rw("</td>");
				rw("<td>");
				rw(FormDescription);
				rw("</td>");
				rw("</tr>");

				rsForms.MoveNext();
			}

			rw("</tbody>");
			rw("</table>");
			rsForms.Close();
			rsForms = null;
		%>
		</div>
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
<script type="text/javascript">
$(document).ready(function() {
	$("ul.nav li a[href$='formsonline.asp']").parent().addClass("active");
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
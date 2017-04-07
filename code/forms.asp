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
var sPageTitle = "Forms";
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row">
		<div class="col-12">
		<%Attribute = Request("attribute");
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
				FormTitle = Server.HtmlEncode(CleanUpString(rsForms("title")));
				FormVerClarify = CleanUpString(rsForms("ver_clarify"));
				FormVerCust = CleanUpString(rsForms("ver_customer"));
				FormID = rsForms("id");
				FormObjid = rsForms("objid");
				FormName = rsForms("dialog_name");
				FormDescription = CleanUpString(rsForms("description"));

				rw("<tr>");
				rw("<td>");
				//We want the FormTitle to be a HyperLink
				rw(BuildHyperLink(BuildFormURL(FormObjid,FormID), FormTitle));
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
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("ul.navbar-nav li a[href$='formsonline.asp']").parent().addClass("active");
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
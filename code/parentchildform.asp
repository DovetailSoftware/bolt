<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  parentchildform.asp
//
// Description    :  Details about Child Forms/Tabs for a Form
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
var sPageTitle = "Child Forms/Tabs";
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<%
	//	Get the posted child form ID & convert it from a string to a number
	var ChildID = Request("id") - 0;
	var ParentObjid = Request("parent_objid") - 0;

	//Get the list of forms
	TheSQL = "select * from table_window_db where id = " + ChildID;
	rsForms = retrieveDataFromDBStatic(TheSQL);

	//If we only have one, then redirect to the details page for that form
	if (rsForms.RecordCount == 11) {
		FormObjid = rsForms("objid");
		FormId = rsForms("id");
		TheLink = BuildFormURL(FormObjid, FormId)
		Response.Redirect(TheLink);
	}
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row-fluid">
		<div id="headerContainer" class="col-8 offset-2 my-5">
		<% //If we have none, say so & exit
			if (rsForms.EOF) {
				rw("<h3>No matches</h3>");
			} else {

				// If we are still here, then there are multiple versions of the child form.
				// We only want the child forms that are a child of the particular parent.
				// We can do this by Resource Config.
				// If the parent form is only in 1 resource config:
				// 	- There will only be 1 child form in that RC, hence, that is the one we want
				// 	- So get it & redirect to that one form detail
				// If the parent form is in multiple RCs OR if the parent is in zero:
				// 	- Create a list of RCs that the parent is in
				// 	- For each RC, get the Child Form ID that is in that RC
				// 	- Create a table for all of these RCs & Child Forms

				// Get the RCs that this parent form belongs to
				TheSQL = "select rc_config2window_db from mtm_window_db4_rc_config1 where window_db2rc_config = " + ParentObjid;
				rsRC = retrieveDataFromDBStatic(TheSQL);

				// If we only have one, then redirect to the details page for that form
				if (rsRC.RecordCount == 11) {
					//Get the Child Form that is in this RC
					RCObjid = rsRC("rc_config2window_db");
					ChildObjid = GetChildFormObjid(ChildID,RCObjid);

					//Now Redirect
					TheLink = BuildFormURL(ChildObjid, ChildID);
					Response.Redirect(TheLink);
				}

				if (rsRC.RecordCount == 0) {
					// Get the child forms in ALL RCs
					// Do this by Creating a list of all RCs
					// Override/redefine the previous record set so the code below that builds the table stays the same
					TheSQL = "select distinct rc_config2window_db from mtm_window_db4_rc_config1";
					rsRC = retrieveDataFromDBStatic(TheSQL);
				}

				// If we are still here, that means that the parent belongs to multiple or no RCs
				// Loop through the list of RCs, and go get the child form that is in each RC

				// Page Header:
				rw("<h3>Child Forms/Tabs</h3>");

				// table Header
				rw("<table class='tablesorter fullWidth'>");
				rw("<THEAD>");
				rw("<tr>");
				rw("<th>");
				rw("Title");
				rw("</th>");
				rw("<th>");
				rw("Name");
				rw("</th>");
				rw("<th>");
				rw("Form ID");
				rw("</th>");
				rw("<th>");
				rw("Clarify Ver");
				rw("</th>");
				rw("<th>");
				rw("User Ver");
				rw("</th>");
				rw("<th>");
				rw("Resource Config");
				rw("</th>");
				rw("<th>");
				rw("Description");
				rw("</th>");
				rw("</tr>");
				rw("</thead>");
				rw("<tbody>");

				while (!rsRC.EOF) {
					RCObjid = rsRC("rc_config2window_db");
					RCName = GetRCName(RCObjid);
					ChildObjid = GetChildFormObjid(ChildID,RCObjid);

					//Go get the Details for this Child form
					TheSQL = "select * from table_window_db where objid = ";
					TheSQL+= ChildObjid;
					rsForms = retrieveDataFromDB(TheSQL);

					FormTitle = rsForms("title") + '';
					FormVerClarify = rsForms("ver_clarify") + '';
					FormVerCust = CleanUpString(rsForms("ver_customer")) + EmptyString;
					FormID = rsForms("id") + '';
					FormObjid = rsForms("objid") + '';
					FormName = rsForms("dialog_name") + '';
					FormDescription = CleanUpString(rsForms("description") + '') + EmptyString;

					rw("<tr>");
					rw("<td>");
					// We want the FormTitle to be a HyperLink
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
					rw(RCName);
					rw("</td>");
					rw("<td>");
					rw(FormDescription);
					rw("</td>");
					rw("</tr>");

					rsRC.MoveNext();
				}

				rw("</tbody>");
				rw("</table>");

				rsForms.Close();
				rsForms = null;
				rsRC.Close();
				rsRC = null;
			}
		%>
		</div>
		<div class="span2"></div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
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
<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  controls.asp
//
// Description    :  Listing of form controls
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
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%

var sPageTitle = "Controls";
var sPageType = "Controls";

//Set the Default control for focus
var sDefaultControl = "filter";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
%>

<div class="container-fluid">
	<div class="row-fluid">
		<div id="headerContainer" class="span12 topMargin">
		<%
			Attribute=Request("attribute");
			Operator=Request("operator");
			Filter=Request("controlFilter");
			var which=Request.Form("which");

			if (Attribute == "ID"){
			  //Subtracting zero will convert it from a string to a number
			  Filter = Filter - 0;
			}

			Filter=SQLFixup(Filter);

			//Get the list of forms
			TheSQL = "select * from table_win_control where ";
			TheSQL+= Attribute;
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

			if (which != "all"){
				TheSQL+=" and control_type = " + which;
			}

			//Build the Order By Clause
			TheSQL+=" order by control_name";

			rsButtons = retrieveDataFromDBStatic(TheSQL);

			//If we have none, say so & exit
			if (rsButtons.EOF) {
				rw("<h3 align='center'>No matches</h3>");
				rw("</body>");
				rw("</html>");
				Response.End
			}

			//If we're still here, then we're building a list of buttons
			//Page Header:
			rw("<h3>Controls</h3>");

			//Table Header
			rw("<table class='tablesorter'>");
			rw("<thead><tr>");
			rw("<th>");
			rw("Control Name");
			rw("</th>");
			rw("<th>");
			rw("Label");
			rw("</th>");
			rw("<th>");
			rw("Type");
			rw("</th>");
			rw("<th type=Number>");
			rw("Form ID");
			rw("</th>");
			rw("<th>");
			rw("Form Name");
			rw("</th>");
			rw("<th>");
			rw("Clarify Ver");
			rw("</th>");
			rw("<th>");
			rw("User Ver");
			rw("</th>");
			rw("</tr></thead>");
			rw("<tbody>");

			while (!rsButtons.EOF)	{
				ButtonName = CleanUpString(rsButtons("control_name"));
				ButtonLabel = CleanUpString(rsButtons("control_label"));
				FormVerClarify = CleanUpString(rsButtons("clarify_ver"));
				FormVerCust = CleanUpString(rsButtons("customer_ver"));
				FormID = rsButtons("win_id");
				FormName = rsButtons("win_name");
				var buttonURL = BuildButtonURL(rsButtons("objid"));
		      var controlType = TranslateControlType(rsButtons("control_type"))
		      var url = "getform.asp?id=" + FormID + "&ver_clarify=" + rsButtons("clarify_ver") + "&ver_customer=" + rsButtons("customer_ver");
		      var formURL = "<a href='" + url + "'>" + FormName + "</a>";

				rw("<TR>");
				rw("<TD>");
				if (rsButtons("control_type")==4){
					rw(BuildHyperLink(buttonURL, ButtonName));
				}
				else{
					rw(ButtonName);
				}
				rw("</TD>");
				rw("<TD>");
				rw(ButtonLabel);
				rw("</TD>");
				rw("<TD>");
				rw(controlType);
				rw("</TD>");
				rw("<TD>");
				rw(FormID);
				rw("</TD>");
				rw("<TD>");
				rw(formURL);
				rw("</TD>");
				rw("<TD>");
				rw(FormVerClarify);
				rw("</TD>");
				rw("<TD>");
				rw(FormVerCust);
				rw("</TD>");
				rw("</TR>");

				rsButtons.MoveNext();
			}

			rw("</tbody>");
			rw("</table>");
			rsButtons.Close();
			rsButtons = null;
		%>
		</div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->
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
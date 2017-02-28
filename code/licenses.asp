<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  licenses.asp
//
// Description    :  Database License Information
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
<link href="bs4/css/bootstrap.min.css" rel="stylesheet">
<link href="css/style4.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Licenses";
var sPageType = "licenses";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
	TheSQL = "select lic_type, paid_lic_count from table_lic_count";
	rsLicense = retrieveDataFromDB(TheSQL);

function TranslateLicType(LicType){
	var LicType2 = "";
	var Unknown = "Unknown";
	switch (LicType + "") {
		case "UNIV_ALL": LicType2 = "Universal Client License"; break;
		case "UNIV_EMS": LicType2 = "eResponse Manager"; break;
		case "UNIV_CS_FTS_DE": LicType2 = "ClearSupport, FTS, Diagnosis Engine"; break;
		case "UNIV_CS": LicType2 = "ClearSupport"; break;
		case "UNIV_CQ": LicType2 = "ClearQuality"; break;
		case "UNIV_CQ_FTS": LicType2 = "ClearQuality, FTS"; break;
		case "UNIV_CLFO": LicType2 = "ClearLogistics Field Operations"; break;
		case "UNIV_CLOO": LicType2 = "ClearLogistics Order Operations"; break;
		case "UNIV_CLSM": LicType2 = "ClearLogistics Spares Manager"; break;
		case "UNIV_CLDR": LicType2 = "ClearLogistics Depot Repair"; break;
		case "UNIV_CTB": LicType2 = "ClearTeleBusiness (ClearCallCenter)"; break;
		case "UNIV_CSA": LicType2 = "ClearSales"; break;
		case "UNIV_TM": LicType2 = "Task Manager"; break;
		case "UNIV_AM": LicType2 = "Account Manager"; break;
		case "UNIV_ME": LicType2 = "Marketing Encyclopedia"; break;
		case "UNIV_EL": LicType2 = "eLink"; break;
		case "UNIV_SMS": LicType2 = "SMS Integration"; break;
		case "UNIV_TAS": LicType2 = "ClearSales Targeted Account Selling"; break;
		case "UNIV_CSDE": LicType2 = "ClearSupport, Diagnosis Engine"; break;
		case "UNIV_CS_FTS": LicType2 = "ClearSupport, FTS"; break;
		case "UNIV_CCN": LicType2 = "ClearContracts"; break;
		case "UNIV_SM": LicType2 = "Service Manager"; break;
		case "UNIV_CCASE": LicType2 = "ClearCase Integration"; break;
		case "WEBUSER": LicType2 = "WebUser"; break;
		case "WEBSUPPORT": LicType2 = "WebSupport"; break;
		case "UNIV_BM": LicType2 = "Billing Manager"; break;
		case "UNIV_OL": LicType2 = "Outlook Integration"; break;
		case "UNIV_CFG": LicType2 = "ClearConfigurator"; break;
		case "UNIV_SCP": LicType2 = "Scipt Manager"; break;
		case "UNIV_FLEX": LicType2 = "Flexible Attributes"; break;
		case "UNIV_PM": LicType2 = "Process Manager"; break;
		case "UNIV_CSUPT": LicType2 = "ClarifyCRM Support"; break;
		case "UNIV_CSALE": LicType2 = "ClarifyCRM Sales"; break;
		case "UNIV_CCC": LicType2 = "ClarifyCRM CallCenter"; break;
		case "UNIV_OA": LicType2 = "Order Automation"; break;
		case "UNIV_CIM": LicType2 = "ClarifyCRM Customer Interaction Manager"; break;
		case "UNIV_ORD": LicType2 = "ClariftCRM Order Management Standard"; break;
		case "UNIV_XIG": LicType2 = "XML Integration Gateway"; break;
		default: LicType2 = Unknown; break;
	}

	if(LicType2 == Unknown) LicType2 = Unknown + " (" + LicType + ")";

	return LicType2;
}
%>
</head>
<body>
<!--#include file="inc/navbar4.inc"-->

<div class="container-fluid">
	<div class="row">
		<div id="homeContainer" class="col-8 offset-2">

			<h3>Clarify License Information</h3>

			<table class="tablesorter">
				<thead>
					<tr>
						<th>License Type</th>
						<th># of Licenses</th>
					</tr>
				</thead>
				<tbody>
				<% while (!rsLicense.EOF) { %>
				 <tr>
				 	<td>
				 	<% LicType = rsLicense("lic_type");
				 		LicType2 = TranslateLicType(LicType);
				 		rw(LicType2); %>
				 	</td>
				 	<td><%=rsLicense("paid_lic_count")%></td>
				 </tr>
				 <% rsLicense.MoveNext(); } %>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter();
});
</script>
</html>
<%
rsLicense.Close();
rsLicense = null;
FSO = null;
udl_file = null;
%>
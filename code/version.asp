<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  version.asp
//
// Description    :  Version Change Details
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
#homeContainer { margin-bottom: 40px; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Version";
var sPageType = "Master";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div id="homeContainer" class="span12">

			<h3>BOLT Version Information</h3>

			<table class="fullWidth tablesorter top">
				<thead>
					<tr>
						<th><b>Version</b></th>
						<th><b>Date</b></th>
						<th><b>Comments</b></th>
					</tr>
				</thead>
				<tr>
					<td>2.10.2</td>
					<td>08/22/11</td>
					<td>Fixed a bug with date conversions in the <a href="business_rule_report.asp">Business Rules Usage Report</a> when using the Microsoft OLEDB Provider for Oracle.</td>
				</tr>
				<tr>
					<td>2.10.1</td>
					<td>08/18/11</td>
					<td>Fixed a bug in the <a href="business_rule_report.asp">Business Rules Usage Report</a> when rule or action titles contained quotes.</td>
				</tr>
				<tr>
					<td>2.10</td>
					<td>08/03/11</td>
					<td>Added a <a href="business_rule_report.asp">Business Rules Usage Report</a>.<br/>
						Added <a href="clarifyID_help.asp">Clarify Classic Client Form Identifier</a>.</td>
				</tr>
				<tr>
					<td>2.9</td>
					<td>05/26/11</td>
					<td>Added ability to select and copy the text from a column for a schema table or view.</td>
				</tr>
				<tr>
					<td>2.8.4</td>
					<td>11/02/10</td>
					<td>Display the pager message in the <a href="select_biz_rules.asp">business rules</a> results.<br/>Allow for filtering of <a href="select_biz_rules.asp">business rules</a> using pager message.</td>
				</tr>
				<tr>
					<td>2.8.3</td>
					<td>08/18/10</td>
					<td>Added masking to the password field on the administration page.<br/>
						Hide/prevent access to the administration page based on the UDL file being read only.<br/>
						Changed header.inc to show "server name - database name" for connection reference.</td>
				</tr>
				<tr>
					<td>2.8.2</td>
					<td>10/21/09</td>
					<td>Corrected custom parser type for table sorting<br/>
						Added initial sort for sql results if "order by" is specified in query (only one column is sorted)<br/>
						Added table row highlighting to tables.asp and views.asp</td>
				</tr>

				<tr>
					<td>2.8.1</td>
					<td>8/11/09</td>
					<td>Added <a href="schema_id_info.asp">More information about User-Defined Table and View IDs</a>.<br></td>
				</tr>

				<tr>
					<td>2.8</td>
					<td>5/29/09</td>
					<td>Allow <a href="formsonline.asp">searching for controls</a>.<br>
						Display prilevege class restrictions for command button controls.</td>
				</tr>

				<tr>
					<td>2.7.2</td>
					<td>4/30/09</td>
					<td>Added full support of Amdocs 6 and Amdocs 7 metadata.<br>
						Added database error handling.</td>
				</tr>

				<tr>
					<td>2.7.1</td>
					<td>4/16/09</td>
					<td>Added a filter to the <a href="formsonline.asp">form search</a> page, allowing the user to filter for all forms, custom forms, or baseline forms</td>
				</tr>

				<tr>
					<td>2.7</td>
					<td>3/10/08</td>
					<td>jQuery additions in SQL for column sorting and row toggle</td>
				</tr>

				<tr>
					<td>2.6</td>
					<td>5/15/07</td>
					<td>Styling changes</td>
				</tr>


				<tr>
					<td>2.5.4</td>
					<td>3/8/06</td>
					<td>On Business Rule Display Page, add data for "To Urgency", "CC Urgency", and "Create Act Log?"<br>
						Add support for "Service Message" action type</td>
				</tr>

				<tr>
					<td>2.5.3</td>
					<td>1/27/06</td>
					<td>Support for Amdocs CRM 6 (Clarify 13.x)</td>
				</tr>

				<tr>
					<td>2.5.2</td>
					<td>1/24/06</td>
					<td>Added support for binary array types on the table detail page. <br>The common type will show as ARRAY and the flags will include the BINARY flag.</td>
				</tr>

				<tr>
					<td>2.5.1</td>
					<td>9/23/05</td>
					<td>Added client-side table sorting (Internet Explorer Only).<br>
						Reformated main info layout of table/view page.<br>
						Added Custom/Baseline indicator on table/view page.<br>
						Added ability to sort for user-defined tables/views on the <a href=ddonline.asp>Data Dictionary</a> page.</td>
				</tr>

				<tr>
					<td>2.5</td>
					<td>9/21/05</td>
					<td>Added support for USER_DEFINED flag on fields and relations.</td>
				</tr>

				<tr>
					<td>2.4</td>
					<td>4/12/05</td>
					<td>Added searching for field and relations on the <a href=ddonline.asp>Data Dictionary</a> page.</td>
				</tr>

				<tr>
					<td>2.3.8</td>
					<td>2/21/05</td>
					<td>Added Client-Side sorting on the <a href="sql.asp">SQL</a> page (Internet Explorer Only).</td>
				</tr>

				<tr>
					<td>2.3.7</td>
					<td>2/15/05</td>
					<td>Added long column wrap Option on the <a href="sql.asp">SQL</a> page.</td>
				</tr>

				<tr>
					<td>2.3.6</td>
					<td>12/21/04</td>
					<td>Added color toggle to the <a href="sql.asp">SQL</a> page.</td>
				</tr>

				<tr>
					<td>2.3.5</td>
					<td>12/2/04</td>
					<td>On the <a href="sql.asp">SQL</a> page, added Swap button (<>) to exchange Clipboard and SQL text.</td>
				</tr>


				<tr>
					<td>2.3.4</td>
					<td>12/1/04</td>
					<td>On the <a href="sql.asp">SQL</a> page, added alt-S as hotkey to execute the query.</td>
				</tr>

				<tr>
					<td>2.3.3</td>
					<td>11/19/04</td>
					<td>On the <a href="admin.asp">Administration</a> page, added support for Oracle OLEDB Provider.
						<br>On the <a href="sql.asp">SQL page</a>, add bind variable substitution capabilities.</td>
				</tr>

				<tr>
					<td>2.3.2</td>
					<td>8/16/04</td>
					<td>Added <a href="sql.asp">SQL page</a>.</td>
				</tr>

				<tr>
					<td>2.3.1</td>
					<td>6/14/04</td>
					<td>Validation and changes for Clarify version 12.5</td>
				</tr>

				<tr>
					<td>2.3</td>
					<td>4/28/04</td>
					<td>Improved ADO Connection management</td>
				</tr>

				<tr>
					<td>2.2.1</td>
					<td>12/12/03</td>
					<td>Added Support for Outer Joins</td>
				</tr>

				<tr>
					<td>2.2</td>
					<td>11/03/03</td>
					<td>Validation and changes for Clarify version 8.5 and version 12.0</td>
				</tr>

				<tr>
					<td>2.1</td>
					<td>10/16/03</td>
					<td>BOLT now supports SQL Views (new schema type as of Clarify 11.5)<BR>
						Add Recent Objects and Quick Search to the footer of the schema pages (view, table, sql_view)</td>
				</tr>

				<tr>
					<td>2.0</td>
					<td>6/17/03</td>
					<td>BOLT now supports Clarify and First Choice databases<BR></td>
				</tr>

				<tr>
					<td>1.7</td>
					<td>1/22/03</td>
					<td>Added ability to search the message text in <a href="select_biz_rules.asp">Select Business Rules</a> page.<BR></td>
				</tr>

				<tr>
					<td>1.6</td>
					<td>10/28/02</td>
					<td>Added <a href="licenses.asp">Clarify Licenses</a> page.<BR></td>
				</tr>

				<tr>
					<td>1.5</td>
					<td>8/26/02</td>
					<td>Added <a href="select_biz_rules.asp">Business Rules</a> page.<BR></td>
				</tr>

				<tr>
					<td>1.4</td>
					<td>7/8/02</td>
					<td>Added <a href="db_info.asp">Database Information page</a>. Validation and changes for Clarify version 11.x<BR></td>
				</tr>

				<tr>
					<td>1.3</td>
					<td>4/24/02</td>
					<td>Added Recent Objects and Quick Links on <a href="ddonline.asp">Data Dictionary</a> page<BR></td>
				</tr>

				<tr>
					<td>1.2</td>
					<td>2/1/02</td>
					<td>Added MTM table names in table page output<BR></td>
				</tr>

				<tr>
					<td>1.1</td>
					<td>11/12/01</td>
					<td>Added BOLT Administration<BR>
						Added Aliases for Views<BR>
						Added Schema Rev & Version in Page Headers<BR></td>
				</tr>

				<tr>
					<td>1.0</td>
					<td>5/10/01</td>
					<td>Initial Release</td>
				</tr>
			</table>
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
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter({
		widgets: ['zebra']
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
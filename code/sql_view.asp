<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  sql_view.asp
//
// Description    :  SQL View Details
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
var type_id=Request("type_id");
var type_name=Request("type_name");

var sPageTitle = "Details for SQL View: " + type_name;
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
<%
function GetNativeSQL(){
	var TheSQL = "";
	if(dbType == "MSSQL") {
		TheSQL = "select ans.generic_sql,ans." + TheSQLStrName + " from adp_object ao left outer join adp_native_sql ans on ao.sql_view_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
	} else {
		TheSQL = "select TO_CHAR(ans.generic_sql) AS generic_sql, TO_CHAR(ans." + TheSQLStrName + ") AS " + TheSQLStrName + " from adp_object ao left outer join adp_native_sql ans on ao.sql_view_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
	}

	var rsView = retrieveDataFromDB(TheSQL);
	var TheViewSQL = rsView(TheSQLStrName) + "";
	if(TheViewSQL == null || TheViewSQL == "null" || TheViewSQL == "") TheViewSQL = rsView("generic_sql") + "";
	rsView.Close;
	rsView = null;
	return TheViewSQL;
}

function GetSQL(){
	var TheSQL = "select " + ((dbType == "MSSQL")? "sql" : "TO_CHAR(sql)") + " from " + TABLE_TABLE + " where " + ID_FIELD + " = " + type_id;
	var rsView = retrieveDataFromDB(TheSQL);
   try {
		var TheViewSQL = rsView("sql") + "";
   } catch(e) {
      rw(e.description + "<br/><br/>" + TheSQL + "<br/><br/>");rf();
   }
	rsView.Close;
	rsView = null;
	return TheViewSQL;
}
%>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8 topMargin">
		<%
			//Get the base table
			var TheLink = getBaseTableLink();

			//Get the sql
			var ver = GetClarifyVersion();
   		var TheViewSQL = (ver > CLARIFY_125)? GetNativeSQL() : GetSQL();

			//See if it has filter SQL
			var filterSQL = getFilterSQL();

			//Page Header:
			outputViewHeader("SQL ", TheLink);
		%>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="hyperlinksContainer" class="span8">
		<%
			var select_sql = "select * from table_" + type_name;
			var encoded_select_sql = Server.URLEncode(select_sql);
			var unionViewsList = "";
			hyperlinksTable();
		%>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div id="fieldsContainer" class="span12 topMargin">
		<%
			//Fields Table:
			outputViewFields();

			//SQL for the view:
			rw("<h4 id='sql' class='topMargin'>SQL:</h4>");
			rw(TheViewSQL.replace(/\n/g, "<br>"));

			//Print the filter
			if(filterSQL != "") {
				rw("<h4 id='filters' class='topMargin'>Filters:</h4>");
				rw(filterSQL.replace(/\n/g,  "<br>"));
			}
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
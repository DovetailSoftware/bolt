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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/tableView.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id=Request("type_id");
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
var type_name = GetTableName(type_id);
var orderByField = "objid";

//Update the Recent Cookie Collection
UpdateCookies();

var sPageTitle = "Details for SQL View: " + type_name;
var sPageType = "Schema";
%>
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

function getEncodedSelectTopSql() {
  var select_top_sql = "";
  if(dbType == "MSSQL") {
    select_top_sql = "select top 10 * from table_" + type_name + " order by " + orderByField + " desc";
  } else {
    select_top_sql = "select * from (select * from table_" + type_name + " order by " + orderByField + " desc) where ROWNUM <= 10 order by " + orderByField + " desc";
  }
  return Server.URLEncode(select_top_sql);
}
%>
<div class="container-fluid">
	<div class="row">
		<% //Get the base table
			var TheLink = getBaseTableLink();

			//Get the sql
			var ver = GetClarifyVersion();
			var TheViewSQL = (ver > CLARIFY_125)? GetNativeSQL() : GetSQL();

			//See if it has filter SQL
			var filterSQL = getFilterSQL();
		%>
    <div class="col-6 offset-3 card bg-faded">
			<% outputViewHeader("SQL ", TheLink); %>
		</div>
		<div class="col-3">
			<%
				var select_sql = "select * from table_" + type_name;
				var encoded_select_sql = Server.URLEncode(select_sql);
				var unionViewsList = "";
				hyperlinksTable();
			%>
		</div>
	</div>

	<div class="row">
		<div id="fieldsContainer" class="col-12 mt-3">
		<% //Fields Table:
			outputViewFields();

			//SQL for the view:
			rw("<h4 id='sql' class='mt-3 mb-0'>SQL:</h4>");
			rw(TheViewSQL.replace(/\n/g, "<br>"));

			//Print the filter
			if(filterSQL != "") {
				rw("<h4 id='filters' class='mt-3'>Filters:</h4>");
				rw(filterSQL.replace(/\n/g,  "<br>"));
			}
		%>
		</div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->
</div>
<%
var select_sql = "select * from table_" + type_name;
var encoded_select_sql = Server.URLEncode(select_sql);
%>
<!--#include file="inc/help.inc"-->
<input type="button" style="display:none;" onclick="executeSql()" />
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/addEvent.js"></script>
<script type="text/javascript">
function showHelp() {
  $("#help tr.object").removeClass("hidden-xs-up");
	$("#help").modal();
	return false;
}

function executeSql() {
	var url = "sql.asp?sql=<%=encoded_select_sql%>";
	window.location.href = url;
}

function executeTopSql() {
	var url = "sql.asp?sql=<%=getEncodedSelectTopSql()%>";
	window.location.href = url;
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";
	addEvent(window, "hashchange", function() { scrollBy(0, -50) });

	$("#helpLink").click(showHelp);
	$("body").keydown(function(evt) {
		if(evt.shiftKey && evt.which == 191) showHelp();
		if(evt.altKey && evt.which == 83) executeSql();
		if(evt.altKey && evt.which == 84) executeTopSql();
	});

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
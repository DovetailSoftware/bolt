<%@ Language="JavaScript" codepage=65001 %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  sql.asp
//
// Description    :  SQL query utility
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
<link href="css/columnSelect.css" rel="stylesheet">
<style>
#sqlContainer h5 { margin: 0; }
#clipboardButtons { text-align: right; }
#clipboardContainer { white-space: nowrap;}
textarea { width:100%;height:150px;float:left;}
#otherButtons { margin-top: .2em; }
label.checkbox { display: inline-block; margin-left: 4em; margin-bottom: -.5em; }
#resultsContainer, pre { margin-top: 1em; }
#stats { font-size: .8em;margin:-.5em 0; }
.error { border: 2pt red solid;padding: 1em; }
.btn { white-space: nowrap; }
table.help td.shortcut {
	font-weight: bold;
	padding-right: .5em;
	text-align: right;
	white-space: nowrap;
}
</style>

<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<!--#include file="inc/utility.vbs"-->
<!--#include file="inc/utility.js"-->
<%
var sPageTitle = "SQL";
var sPageType = "SQL";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

var sql = Request("sql") + "";
if(sql == "undefined") sql = "";

var clp = Request.Cookies("bolt_sql_clp") + "";
if(clp == "undefined") clp = "";

var flag = Request("flag");

var wrap = Request("chk_wrap") + "";
if(wrap == "undefined") wrap = "";

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<%
var PARAM_CHAR = "@";
if(dbType == "Oracle") PARAM_CHAR = ":";
%>
<script type="text/javascript">
var initSort = "";
</script>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div id="homeContainer" class="span12">
			<h3>SQL</h3>
		</div>
	</div>

	<div class="row-fluid">
		<div id="sqlContainer" class="span12">
			<div id="sqlDiv" style="width:45%;float:left;">
				<h5>SQL Code</h5>
				<textarea id="sqlStmt" name="sqlStmt" wrap="soft" style="width:97%;"><%=sql%></textarea>
			</div>
			<div style="width:85px; float:left;margin-left:.5em;">
				<h5>&nbsp;</h5>
				<button class="btn btn-block" id="copySql" onclick="copysql()" title="Copy SQL to Clipboard">Copy <i class="icon icon-chevron-right"></i></button>
				<button class="btn btn-block" id="swapSql" onclick="swap()" title="Swap SQL and Clipboard"><i class="icon icon-chevron-left"></i> Swap <i class="icon icon-chevron-right"></i></button>
				<button class="btn btn-block" id="copyClp" onclick="copyclp()" title="Copy Clipboard to SQL"><i class="icon icon-chevron-left"></i> Copy</button>
			</div>
			<div id="clipDiv" style="float:right;width:42%;">
				<div style="float:right;margin: 0 .3em;font-size:.8em;"><a id="helpLink" href="">Keyboard shortcuts available</a></div>
				<h5>Clipboard</h5>
				<textarea id="clp" name="clp" wrap="soft" style="width:97%;"><%=clp%></textarea>
			</div>
		</div>
	</div>

	<div class="row-fluid">
		<div id="sqlButtons" class="span4">
			<button class="btn btn-primary input-medium" id="execSql" onclick="submitForm()" title="Execute SQL"><i class="icon-white icon-play"></i> Run</button>
			<button class="btn btn-link" id="clearsql" onclick="clearsql()" title="Clear SQL">Clear</button>
		</div>
		<div class="span4 empty"></div>
		<div id="clipboardButtons" class="span4">
			<button class="btn btn-link" id="clearClp" onclick="clearclp()" title="Clear Clipboard">Clear</button>
		</div>
	</div>

	<div class="row-fluid bottomMargin">
		<div id="otherButtons" class="span12">
			<button class="btn " id="prefill" onclick="prefill()" title="Prefill SQL">select * from table_</button>
			<button class="btn " id="substitute" onclick="substitute()" title="Bind Variables">Substitute Bind Variables</button>
			<span>(Bind Variable Character is "<b><%=PARAM_CHAR%></b>")</span>
			<label class="checkbox">
  				<input type="checkbox" id="wrapLong" name="wrapLong" <%=(wrap == 'on')? 'checked' : '' %> /> Wrap Long Columns
			</label>
		</div>
	</div>

	<div class="row-fluid">
		<div id="resultsContainer" class="span12">
		<% if(sql.length > 0 && flag != "no_query") {
				try {
				  	var start = new Date();

					var aRecordSet = Server.CreateObject("ADODB.Recordset");
					//Note that we're using a static cursor here as we need to check the rowcount
					aRecordSet.CursorType = adOpenStatic;
					aRecordSet.ActiveConnection = dbConnect;
					aRecordSet.CursorLocation = gCursorLocation;
					aRecordSet.Source = sql;
					aRecordSet.Open();
					DisconnectRecordset(aRecordSet);

					var RS = aRecordSet;

					rw("<table id='stats'>");
					rw("<tr>");
					rw("<td><b>Start Time:&nbsp;</b></td><td>" + start + "</td>");
					rw("<td style='width:20px;'>&nbsp;</td>");
					var end = new Date();
					var elapsed_ms = end.getMilliseconds() - start.getMilliseconds();

					try {
					   rw("<td><b>Number of Records:</b></td><td>" + RS.RecordCount + "</td>");
					} catch(e) {}
					rw("</tr>");
					rw("<tr>");
					rw("<td><b>End Time:</b></td><td>" + end + "</td>");
					rw("<td></td>");
					rw("<td><b>Elapsed Time (seconds):&nbsp;</b></td><td>" + elapsed_ms/1000 + "</td>");
					rw("</tr>");
					rw("</table>")

					if(RS.State == 1) { // if the recordset has rows
					   var pos = sql.indexOf("order by ");
					   if(pos > 0) {
					      var order = 0;
					      var orderBy = sql.substr(pos+9);
					      var colName = orderBy.split(" ");
					      if(colName.length > 1) {
					         if(colName[1] == "desc" || colName[1] == "desc,") {
					            order = 1;
					         }
					      }

					      for(var i=0; i < RS.Fields.Count;i++) {
					         if(RS.Fields(i).Name.toLowerCase() == colName[0].toLowerCase()) {
					            rw("<script>");
					            rw("  initSort = { sortList: [[" + i + ", " + order + "]] };");
					            rw("</script>");
					            break;
					         }
					      }
					   }
					}

					rw("<p id='fields'/><table class='tablesorter'>");
					if(RS.State == 1) { // if the recordset has rows
					  //show the column names
					  rw("<thead>");
					  rw("  <tr class='headerRow'>");
					  for(var i=0; i < RS.Fields.Count;i++) {
					     the_type = "CaseInsensitiveString";
					     if( RS.Fields(i).Type == 135) the_type="Date";
					     rw("<th title='Click to Sort'>" + RS.Fields(i).Name + "</th>")
					  }
					  rw("	</tr>");
					  rw("</thead>");
					  rw("<tbody>");
					  //show the rows
					  while(!RS.EOF) {
					      rw("  <tr>");
					      for(var i=0; i < RS.Fields.Count;i++) {
					         colName = RS.Fields(i).Name;
					         colValue = Server.HTMLEncode(RS.Fields(i).Value + "");

					         //show dates in a nice format
							   if( RS.Fields(i).Type == 135 && RS.Fields(i).Value != null) colValue = I18N_FormatGeneralDate( RS.Fields(i).Value);

					         wrap_val = "";
					         if(wrap == "on" && colValue.length > 60) wrap_val = " style='white-space:normal;'";

					         if(colName.toLowerCase() != "sql_stmt") {
									rw("<td" + wrap_val + ">" + colValue + "</td>");
					         } else {
					            colValue = colValue.replace(/outerPlus/g, "(+)")
					            rw("<td class='sqlTd'" + wrap_val + ">" + colValue + "</td>")
					         }
					      }
					      rw("	</tr>");
					      RS.MoveNext();
					   }


					} else {
					   rw("  <tr><td><b>Command Completed Successfully</b></td></tr>");
					}
					rw("</tbody>");
					rw("</table>");

				} catch(e) {
				   rw("<h2>SQL Error</h2>");
				   rw("<h3 class='error'>" + e.description + "</h3>");
				   rw("<pre>" + sql + "</pre>");
				}

				try { aRecordSet.Close(); } catch(e) {}
				aRecordSet = null;
			}
		%>
		</div>
	</div>
</div>

<div id="help" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	  <h3 id="myModalLabel">Keyboard shortcuts</h3>
	</div>
	<div class="modal-body">
		<table class="help">
			<tr>
				<td class="shortcut">alt-s</td>
				<td>Execute SQL</td>
			</tr>
			<tr>
				<td class="shortcut">alt-x</td>
				<td>Swap SQL and Clipboard</td>
			</tr>
			<tr>
				<td class="shortcut">?</td>
				<td>Bring up this help dialog</td>
			</tr>
		</table>
	</div>
</div>

<form id="formSQL" action="sql.asp" method="POST">
	<input type="hidden" id="sql" name="sql" value="" />
	<input type="hidden" id="flag" name="flag" value="" />
	<input type="hidden" id="chk_wrap" name="chk_wrap" value="" />
</form>

</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript">
function setCookie(name, value) {
	var exp = new Date();
	exp.setTime(exp.getTime()+31536000000);	//	1 year from now
	var curCookie = name + "=" + escape(value) + "; expires=" + exp.toGMTString();
	document.cookie = curCookie;
}

function getCookie(name) {
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);

	if(begin == -1) {
		begin = dc.indexOf(prefix);
		if(begin != 0) return null;
	} else
		begin += 2;

	var end = document.cookie.indexOf(";", begin);
	if(end == -1) end = dc.length;
	return unescape(dc.substring(begin + prefix.length, end));
}

function deleteCookie(name) {
	if(getCookie(name)) document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT";
}

function prefill() {
	$("#sqlStmt").focus().val("select * from table_");
}

function clearsql() {
	$("#sqlStmt").val("").focus();
}

function clearclp() {
	$("#clp").val("").focus();
	deleteCookie("bolt_sql_clp");
}

function copysql() {
	var sql = $("#sqlStmt").val();
	if(sql.length == 0) return false;
	var clp = $("#clp").val();
	var newclp = sql + '\n' + clp;
	$("#clp").val(newclp);
	setCookie("bolt_sql_clp", newclp);
}

function copyclp() {
	var clp = $("#clp").val();
	if(clp.length == 0) return false;

	var sql = $("#sqlStmt").val();
	$("#sqlStmt").val(sql + clp);
}

function swap() {
	var clp = $("#clp").val();
	var sql = $("#sqlStmt").val();

	$("#sqlStmt").val(clp);
	$("#clp").val(sql);

	setCookie("bolt_sql_clp", sql);
}

function substitute() {
	var s = $("#sqlStmt").val() + "";
	var s2 = subVariables(s);
	$("#sqlStmt").val(s2);
}

function subVariables(s) {
// This function will substitute bind variables into an expression.
// Mainly, it is for use with sql extracted from fcfl.net generated log files.
// The input is expected to look something like the following:

/*
   Command:
     SELECT  * FROM table_fnl_alst WHERE parent_objid = @0 order by  entry_time desc
   Parameters:
     @0 = 268435483
*/

	var PARAMETER="Parameters:";
	var COMMAND = "Command:";

	//for mssql,  the parameter character is the at sign (@)
	//for oracle, the parameter character is the colon (:)

	var PARAM_CHAR="<%=PARAM_CHAR%>";

	//split the inout string into command and parameter
	var param_index = s.indexOf(PARAMETER);
	var command = s.slice(0,param_index);
	var param = s.slice(param_index);

	//remove the command and parameter literal strings
	var re = new RegExp (COMMAND, 'i') ;
	command = command.replace(re,"");
	var re = new RegExp (PARAMETER, 'i') ;
	param = param.replace(re,"");

	//get rid of any spaces at the start of the line
	param = param.replace(/^\s+/,"");
	//get rid of the starting PARAM_CHAR character
	var re = new RegExp ("^" + PARAM_CHAR, '') ;
	param = param.replace(re,"");

	//split on the @ character
	var arrParams = param.split(PARAM_CHAR);

	//for each param name/value pair,
	//split on the equals character
	//add the PARAM_CHAR character back onto the param name
	//remove any leading or trailing spaces for the param & the  value
	//replace any single quotes with 2 single quotes
	//if the length of the value is zero, make it ''
	//otherwise, wrap it in single quotes
	//put the parameter in the command string

	for(var i = 0; i<arrParams.length;i++) {
		var arrP = arrParams[i].split('=');

		//If we dont have atleast 2 entries (which would be 1 name/value pair)
		//then dont do anything - just return the original string
		if(arrP.length <=1) return s;

		var param = PARAM_CHAR + arrP[0];
		var param_value = arrP[1];
		param = param.replace(/^\s+/,"");
		param = param.replace(/\s+$/,"");

		param_value = param_value.replace(/^\s+/,"");
		param_value = param_value.replace(/\s+$/,"");

		param_value =param_value.replace(/\'/g,"\'\'");

		if(param_value.length==0) {
			param_value= "''";}
		else{
			param_value= "'" + param_value + "'";
		}
		var re = new RegExp (param, 'i') ;
		command = command.replace(re,param_value);
	}

	//get rid of any spaces at the start of the line
	command = command.replace(/^\s+/,"");

	return command;
}

function prepareForm() {
	var sql = $("#sqlStmt").val();
	$("#sql").val(sql);

	var isChecked = $("#wrapLong").is(":checked");

	$("#chk_wrap").val((isChecked)? "on" : "off");
}

function submitForm() {
	prepareForm();
	$("#formSQL").submit();
}

function resizeTextAreas() {
	var newWidth = ($(".navbar").width() - 85 - 53) / 2;
	$("#sqlDiv, #clipDiv").css("width", newWidth);
}

function showHelp() {
	$("#help").modal({ "keyboard": true });
	return false;
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#helpLink").click(showHelp);
	$("body").keydown(function(evt) {
		if(evt.shiftKey && evt.which == 191) showHelp();
		if(evt.altKey && evt.which == 88) swap();
		if(evt.altKey && evt.which == 83) submitForm();
	});

	resizeTextAreas();
	$(window).resize(resizeTextAreas);

	$("#resultsContainer").on("click", ".tablesorter tbody tr", function () {
	   $(this).children("td").toggleClass("highlight");
	});

	$(".sqlTd").dblclick(function() {
		var thisSql = $(this).text();
		copysql();
		$("#sqlStmt").val(thisSql);
		submitForm();
	});

	if(<%=sql.length%> > 0) {
		$(".tablesorter").tablesorter(initSort);
	   columnSelect();
	}

	var sql = $("#sqlStmt").val() + "";
	$("#sqlStmt").focus().val(sql);
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
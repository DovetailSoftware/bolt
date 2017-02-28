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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="bs4/css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style4.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">
<style>
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
// temp
// var s = ["select top 10 * from table_case order by objid desc"];
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select * from table_case where objid in (268435463, 268435462, 268435461, 268435460, 268435459, 268435458, 268435457) order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// s.push("select top 10 * from table_subcase order by objid desc");
// localStorage.setItem('storedSql', JSON.stringify(s));

var storedSql = JSON.parse(localStorage.getItem('storedSql'));
var sqlIndex = 0;
</script>
</head>
<body>
<!--#include file="inc/navbar4.inc"-->
<div class="container-fluid">
  <div class="row">
    <div id="homeContainer" class="col-12">
      <h3>SQL</h3>
    </div>
  </div>

  <div class="row">
    <div id="sqlDiv" class="col-7">
      <div class="form-group mb-1">
        <label for="sqlStmt">SQL Code</label>
        <textarea id="sqlStmt" name="sqlStmt" wrap="soft" class="form-control" rows="5"><%=sql%></textarea>
      </div>    
    </div>
    <div id="clipDiv" class="col-5">
      <div style="float:right" class="m-0 mr-2 small"><a id="helpLink" href="">Keyboard shortcuts available</a></div>
      <div class="form-group mb-1">
        <label for="stored-sql">Stored SQL</label>
        <button class="btn btn-link" onclick="clearStoredSQL()" title="Clear Stored SQL">Clear</button>
        <div id='stored-sql' class="list-group"></div>
      </div>    
    </div>
  </div>

  <div class="row">
    <div id="sqlButtons" class="col-4">
      <button class="btn btn-primary btn-sm col-4 mb-2" id="execSql" onclick="submitForm()" title="Execute SQL"><i class="icon-white icon-play"></i> Run</button>
    </div>
    <div id="clipboardButtons" class="col-3">
      <div style="float:right" class="btn-group btn-group-sm">
        <button class="btn btn-info" id="clearsql" onclick="clearsql()" title="Clear SQL">Clear</button>
        <button class="btn btn-success" id="storeSql" onclick="storeSql()" title="Store SQL command">Store ></button>
      </div>
    </div>
  </div>

  <div class="row">
    <div id="otherButtons" class="col-12">
      <button class="btn btn-sm col-2" id="prefill" onclick="prefill()" title="Prefill SQL">select * from table_</button>
      <button class="btn btn-sm col-2" id="substitute" onclick="substitute()" title="Bind Variables">Substitute Bind Variables</button>
      <span class="small mx-4">(Bind Variable Character is "<b><%=PARAM_CHAR%></b>")</span>
      <label>
        <input type="checkbox" id="wrapLong" <%=(wrap == 'on')? 'checked' : '' %> /> Wrap Long Columns
      </label>
    </div>
  </div>

  <div class="row">
    <div id="resultsContainer" class="col-12">
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

          rw("<div class='col-5 pl-0'>");
          rw("<table id='stats' class='table table-sm small'>");
          rw("<tr>");
          rw("<td class='pl-0 font-weight-bold'>Start Time:</td><td>" + start + "</td>");
          var end = new Date();
          var elapsed_ms = end - start;
          try {
             rw("<td class='font-weight-bold'>Number of Records:</td><td><span class='btn btn-success py-0 px-1'>" + RS.RecordCount + "</span></td>");
          } catch(e) {}
          rw("</tr>");
          rw("<tr>");
          rw("<td class='pl-0 font-weight-bold'>End Time:</td><td>" + end + "</td>");
          rw("<td class='font-weight-bold'>Elapsed Time (seconds):</td><td>" + elapsed_ms/1000 + "</td>");
          rw("</tr>");
          rw("</table>")
          rw("</div>")

          if(RS.State == 1) { // if the recordset has rows
             var pos = sql.indexOf("order by ");
             if(pos > 0) {
                var order = 0;
                var orderBy = sql.substr(pos+9);
                var colName = orderBy.split(" ");
                if(colName.length > 1) {
                   var sortOrder = FCTrim(colName[1]).substr(0,4);
                   if(sortOrder == "desc") order = 1;
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

          rw("<p id='fields'/><div id='sql-results'><table class='tablesorter'>");
          if(RS.State == 1) { // if the recordset has rows
            //show the column names
            rw("<thead>");
            rw("  <tr class='headerRow'>");
            for(var i=0; i < RS.Fields.Count;i++) {
               the_type = "CaseInsensitiveString";
               if( RS.Fields(i).Type == 135) the_type="Date";
               rw("<th title='Click to Sort'>" + RS.Fields(i).Name + "</th>")
            }
            rw("  </tr>");
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
                rw("  </tr>");
                RS.MoveNext();
             }


          } else {
             rw("  <tr><td class='font-weight-bold'>Command Completed Successfully</td></tr>");
          }
          rw("</tbody>");
          rw("</table>");
          rw("</div>");

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

<!--#include file="inc/help.inc"-->

<form id="formSQL" action="sql.asp" method="POST">
  <input type="hidden" id="sql" name="sql" value="" />
  <input type="hidden" id="flag" name="flag" value="" />
  <input type="hidden" id="chk_wrap" name="chk_wrap" value="" />
</form>

</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript">
function prefill() {
  $("#sqlStmt").focus().val("select * from table_");
}

function clearsql() {
  $("#sqlStmt").val('').focus();
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
     SELECT * FROM table_fnl_alst WHERE parent_objid = @0 order by  entry_time desc
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

function showHelp() {
  $("#help tr.sql").removeClass("hidden-xs-up");
  $("#help").modal();
  return false;
}

function clearStoredSQL() {
  storedSql = [];
  localStorage.setItem('storedSql', JSON.stringify(storedSql));
  
  $(`input.stored`).each(function() {
    var i = $(this).data('index');
    $(`#remove${i}`).trigger('click');
  });
}

function storeSql() {
  var sql = $("#sqlStmt").val();
  if(sql.length == 0) return false;

  var found = storedSql.indexOf(sql) > -1;
  if(found) {
    $(`input.stored[value='${sql}']`).each(function() {
      var i = $(this).data('index');
      $(`#remove${i}`).trigger('click');
    });
  }

  storedSql.push(sql);
  localStorage.setItem('storedSql', JSON.stringify(storedSql));
  appendSql(sql);
}

function removeSql(el) {
  var dropSql = $(el).parents('div').children("input").val();
  var $div = $(el).parents('div.storage');
  var i = $(el).data('index');
  $div.remove();

  storedSql = storedSql.filter(function(item) { 
    return item !== dropSql;
  });
  localStorage.setItem('storedSql', JSON.stringify(storedSql));
}

function appendSql(sql) {
  var i = sqlIndex++;
  var cmd = `<div class="storage input-group mb-1">
      <span class="input-group-btn">
        <button class="load btn btn-success btn-sm" type="button"><</button>
      </span>
      <input type="text" class="stored form-control p-1" readonly value="${sql}" title="${sql}" data-index="${i}">
      <span class="input-group-btn">
        <button id="remove${i}" class="btn btn-default btn-sm" type="button" data-index="${i}">x</button>
      </span>
    </div>`;

  $('#stored-sql').prepend(cmd);

  $(`#remove${i}`).click(function() {
    removeSql(this);
  });
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

  storedSql.forEach(function(sql) {
    appendSql(sql);
  });

  $("button.load").on("click", function () {
    var sql = $(this).parents('div').children("input").val();
    $("#sqlStmt").focus().val(sql);
  });

  var sql = $("#sqlStmt").val() + "";
  $("#sqlStmt").focus().val(sql);
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
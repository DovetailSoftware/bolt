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
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">
<link href="css/font-awesome.min.css" rel="stylesheet">
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
if(sql === "undefined") sql = "";

var flag = Request("flag");

var wrap = Request("chk_wrap") + "";
if(wrap === "undefined") wrap = "";

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<%
var PARAM_CHAR = "@";
if(dbType === "Oracle") PARAM_CHAR = ":";
%>
<script type="text/javascript">
var initSort = "";

var storedSql = JSON.parse(localStorage.getItem('storedSql'));
if(storedSql == undefined) storedSql = [];

var sqlIndex = 0;
</script>
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
  <div class="row">
    <div class="col-7">
      <div class="row">
        <div class="col-8">
          <h5>SQL Code</h5>
        </div>
        <div class="col-4">
          <div style="float:right">
            <button class="btn btn-sm btn-default pointer" id="clearsql" onclick="clearsql()" title="Erase SQL Code"><i class="fa fa-eraser"></i></button>
            <button class="btn btn-sm btn-success pointer" id="storeSql" onclick="storeSql()" title="Store SQL"><i class="fa fa-arrow-circle-right"></i></button>
          </div>
        </div>
      </div>    
      <div class="row">
        <div class="form-group my-1 col-12">
          <textarea id="sqlStmt" name="sqlStmt" wrap="soft" class="form-control" rows="5"><%=sql%></textarea>
        </div>    
      </div>    
      <div class="row">
        <div class="col-3">
          <button class="btn btn-primary btn-sm col-12 mb-2 mr-0" id="execSql" onclick="submitForm()" title="Execute SQL"><i class="fa fa-play"></i> Run</button>
        </div>
        <div class="col-9">
          <button class="btn btn-sm" id="prefill" onclick="prefill()" title="Prefill SQL">select * from table_</button>
          <button class="btn btn-sm" id="substitute" onclick="substitute()" title="Bind Variable Character is '<%=PARAM_CHAR%>'">Substitute Bind Variables</button>
          <div class="form-group ml-2 list-inline-item">
            <input type="checkbox" id="wrapLong" <%=(wrap === 'on')? 'checked' : '' %> />
            <label for="wrapLong" class="small">Wrap Long Columns</label>
          </div>    
        </div>
      </div>    
      <div class="row">
        <div id="statDiv" class="col-8 ml-2"></div>
      </div>
    </div>

    <div class="col-5 pl-0">
      <div style="float:right" class="m-0 mr-2 small"><a id="helpLink" href="">Keyboard shortcuts available</a></div>
      <div class="form-group">
        <h5 class="mb-0 list-inline-item">Stored SQL</h5>
        <button class="btn btn-sm btn-default pointer" onclick="clearStoredSQL()" title="Remove all Stored SQL"><i class="fa fa-trash"></i></button>
        <div id='stored-sql' class="mt-1 list-group"></div>
      </div>    
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
          rw("<table id='stats' class='my-0 table table-sm small'>");
          rw("<tr>");
          rw("<td class='pl-0 font-weight-bold'>Start:</td><td>" + start + "</td>");
          var end = new Date();
          var elapsed_ms = end - start;
          try {
             rw("<td class='font-weight-bold'>Number of Records:</td><td><span class='btn btn-success py-0 px-1'>" + RS.RecordCount + "</span></td>");
          } catch(e) {}
          rw("</tr>");
          rw("<tr>");
          rw("<td class='pl-0 font-weight-bold'>End:</td><td>" + end + "</td>");
          rw("<td class='font-weight-bold'>Elapsed Time (seconds):</td><td>" + elapsed_ms/1000 + "</td>");
          rw("</tr>");
          rw("</table>")
          rw("</div>")

          if(RS.State === 1) { // if the recordset has rows
             var pos = sql.indexOf("order by ");
             if(pos > 0) {
                var order = 0;
                var orderBy = sql.substr(pos+9);
                var colName = orderBy.split(" ");
                if(colName.length > 1) {
                   var sortOrder = FCTrim(colName[1]).substr(0,4);
                   if(sortOrder === "desc") order = 1;
                }

                for(var i=0; i < RS.Fields.Count;i++) {
                   if(RS.Fields(i).Name.toLowerCase() === colName[0].toLowerCase()) {
                      rw("<script>");
                      rw("  initSort = { sortList: [[" + i + ", " + order + "]] };");
                      rw("</script>");
                      break;
                   }
                }
             }
          }

          // reset any existing focusType
          focusType = -1;

          rw("<p id='fields'/><div id='sql-results'><table class='tablesorter'>");
          if(RS.State === 1) { // if the recordset has rows
            //show the column names
            rw("<thead>");
            rw("  <tr class='headerRow'>");
            for(var i=0; i < RS.Fields.Count;i++) {
               the_type = "CaseInsensitiveString";
               if(RS.Fields(i).Type === 135) the_type="Date";
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
                 colType = "";
                 colClass = "";
                 TargetName = "";
                 if(colName.toLowerCase() === "sql_stmt") {
                   colClass = " class='sqlTd'";
                 } else if(RS.Fields(i).Type === 3) {
                   if(RS.Fields(i).Value != null) {
                     colClass = " class='relTd'";
                     colType = " data-type='3' data-rel='" + colName + "'";
                     TargetName = GetSpecRelInfo(colName)
                     if(TargetName) {
                       sqlHref = "sql.asp?sql=" + Server.URLEncode("select * from table_" + TargetName + " where objid = " + colValue)
                       colValue = "<a href='" + sqlHref + "'>" + colValue + "</a>"
                     } else if(colName === "focus_lowid" && colValue > 0) {
                       TargetName = GetTableName(focusType)
                       if(TargetName) {
                         sqlHref = "sql.asp?sql=" + Server.URLEncode("select * from table_" + TargetName + " where objid = " + colValue)
                         colValue = "<a href='" + sqlHref + "'>" + colValue + "</a>"
                       }
                     }
                   }
                 } else if(RS.Fields(i).Type === 2 && colName === "focus_type") {
                   focusType = colValue;
                 }

                 //show dates in a nice format
                 if(RS.Fields(i).Type === 135 && RS.Fields(i).Value != null) 
                   colValue = I18N_FormatGeneralDate( RS.Fields(i).Value);

                 wrap_val = "";
                 if(wrap === "on" && colValue.length > 60) wrap_val = " style='white-space:normal;'";

                 if(colName.toLowerCase() != "sql_stmt") {
                    rw("<td" + colClass + wrap_val + colType + ">" + colValue + "</td>");
                 } else {
                    colValue = colValue.replace(/outerPlus/g, "(+)")
                    rw("<td" + colClass + wrap_val + ">" + colValue + "</td>")
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
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
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
  
  $('input.stored').each(function() {
    var i = $(this).data('index');
    $('#remove'+i).trigger('click');
  });
}

function storeSql() {
  var sql = $("#sqlStmt").val();
  if(sql.length === 0) return false;

  var found = storedSql.indexOf(sql) > -1;
  if(found) {
    $('input.stored[value="'+sql+'"]').each(function() {
      var i = $(this).data('index');
      $('#remove'+i).trigger('click');
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
  var cmd = '<div class="storage input-group mb-1">' +
      '<span class="input-group-btn">' +
      '  <button class="load btn btn-success btn-sm pointer" title="Load SQL" type="button"><i class="fa fa-arrow-circle-left"></i></button>' +
      '</span>' +
      '<input type="text" class="stored form-control p-1" title="Load SQL" readonly value="'+sql+'" title="'+sql+'" data-index="'+i+'">' +
      '<span class="input-group-btn">' +
      '  <button id="remove'+i+'" class="btn btn-default btn-sm pointer" type="button" title="Remove SQL" data-index="'+i+'"><i class="fa fa-trash"></i></button>' +
      '</span>' +
    '</div>';

  $('#stored-sql').prepend(cmd);

  $('#remove'+i).click(function() {
    removeSql(this);
  });

  $("button.load")
    .unbind("click")
    .on("click", function () {
      var sql = $(this).parents('div').children("input").val();
      $("#sqlStmt").focus().val(sql);
    });

  $("input.stored")
    .unbind("click")
    .on("click", function () {
      var sql = $(this).val();
      $("#sqlStmt").focus().val(sql);
    });
}

$(document).ready(function() {
  var path = window.location.pathname;
  var page = path.substr(path.lastIndexOf("/")+1);
  $("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
  $(".navbar").find(".connected").text("<%=connect_info%>");
  document.title = "Bolt: <%=sPageTitle%>";

  $("#stats").appendTo("#statDiv");

  $("#helpLink").click(showHelp);
  $("body").keydown(function(evt) {
    if(evt.shiftKey && evt.which === 191) showHelp();
    if(evt.altKey && evt.which === 88) swap();
    if(evt.altKey && evt.which === 83) submitForm();
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

  var sql = $("#sqlStmt").val() + "";
  $("#sqlStmt").focus().val(sql);
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  view.asp
//
// Description    :  View Details
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
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var orderByField = "objid";

var type_id = Request("type_id");
var rsSpecRelID;

var sPageTitle = "Details for View";
var sPageType = "Schema";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
var type_name = GetTableName(type_id);
if(IsView(type_id) == false) Response.Redirect(BuildTableURL(type_id));
//Update the Recent Cookie Collection
UpdateCookies();
%>
<!--#include file="inc/quicklinks.inc"-->
<!--#include file="inc/viewDetails.js"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
//see if this is a sql view
//if so, redirect to sql_view.asp
TheSQL = "select type_flags from " + TABLE_TABLE + " where " + ID_FIELD + " = ";
TheSQL+= type_id;
rsView = retrieveDataFromDB(TheSQL);
var Flags = rsView("type_flags") + "";
rsView.Close;
rsView = null;

if (Flags & SQL_VIEW_FLAG){
  var TheURL = BuildSQLViewURL(type_id);
  Response.Redirect(TheURL);
}

if (Flags & UNION_VIEW_FLAG){
  var TheURL = BuildUnionViewURL(type_id);
  Response.Redirect(TheURL);
}

//See if it contributes to any UNION views
var unionViewsList = getUnionViewsList(type_id);
//See if it has filter SQL
var filterSQL = getFilterSQL();

function getEncodedSelectTopSql() {
  var select_top_sql = "";
  if(dbType == "MSSQL") {
    select_top_sql = "select top 10 * from table_" + type_name + " order by " + orderByField + " desc";
  } else {
    select_top_sql = "select * from (select * from table_" + type_name + " order by " + orderByField + " desc) where ROWNUM <= 10  order by " + orderByField + " desc";
  }
  return Server.URLEncode(select_top_sql);
}
%>
<div class="container-fluid">
  <div class="row">
      <div class="col-6 offset-3 card bg-faded">
      <% outputViewHeader("", ""); %>
    </div>
    <div class="col-3">
      <% hyperlinksTable(); %>
    </div>
  </div>

  <div class="row">
    <div class="col-12">
      <% outputViewFields(); %>
    </div>
  </div>

  <div class="row">
    <div id="joinsContainer" class="col-12">
    <%  //Get the List of Joins for this View
      TheSQL = "select * from " + JOIN_TABLE + " where " + VIEW_ID + " = " + type_id;
      TheSQL+= " and flags = (select MIN(flags) from " + JOIN_TABLE + " where " + VIEW_ID + " = " + type_id + ")";
      rsJoins = retrieveDataFromDB(TheSQL);

      //Define a new array
      //Its structure will look like:
      //Column 0: From Table ID
      //Column 1: From Table Name
      //Column 2: From Spec Rel ID
      //Column 3: From Relation Name
      //Column 4: To Table Name
      //Column 5: To Relation Name
      //Column 6: From Table Alias
      //Column 7: To Table Alias
      //Column 8: Join Flag

      var JoinArray = [];

      row = 0;
      while (!rsJoins.EOF){
        ObjectTypeID = rsJoins(JOIN_FROM_TBL_ID);
        ToAlias = rsJoins(JOIN_PRIM_ALIAS) + "";
        FromAlias = rsJoins(JOIN_SEC_ALIAS) + "";
        JoinFlag = rsJoins("join_flag") + "";
        ObjectSpecRelID = 0;

        ObjectSpecRelID = rsJoins("obj_spec_rel_id");
        if (ObjectSpecRelID >= 16384) {
          ObjectSpecRelID = ObjectSpecRelID - 16384;
        }

        JoinArray[row] = [];
        JoinArray[row][0] = ObjectTypeID + "";
        JoinArray[row][6] = FromAlias + "";
        JoinArray[row][7] = ToAlias + "";
        JoinArray[row][8] = JoinFlag + "";

        //Get the Table Name
        TableName = GetTableName(ObjectTypeID);
        JoinArray[row][1] = TableName + "";

        //Get the Relation Info
        TheSQL = "select * from adp_sch_rel_info where type_id = ";
        TheSQL+= ObjectTypeID;
        TheSQL+= " and spec_rel_id = ";
        TheSQL+= ObjectSpecRelID;
        rsRelName = retrieveDataFromDB(TheSQL);
        JoinArray[row][3] = rsRelName("rel_name") + "";
        JoinArray[row][4] = rsRelName("target_name") + "";
        JoinArray[row][5] = rsRelName("inv_rel_name") + "";
        rsRelName.Close();
        rsRelName = null;

        row = row + 1;
        rsJoins.MoveNext();
      }

      //Print the Table of Joins
      //Build the table header
      rw("<h4 id='joins'>Joins:</h4>");
      rw("<table class='tablesorter joins'>");
      rw("<thead><tr class='headerRow'>");
      rw("<th>");
      rw("Join From");
      rw("</th>");
      rw("<th>");
      rw("Join To");
      rw("</th>");
      rw("</tr></thead>");

      nFields = JoinArray.length;
      for(row = 0; row < nFields; row++) {
        FromTableNum = JoinArray[row][0];
        FromTable = JoinArray[row][1];
        FromRel = JoinArray[row][3];
        ToTable = JoinArray[row][4];
        ToRel = JoinArray[row][5];
        FromAlias = JoinArray[row][6];
        ToAlias = JoinArray[row][7];
        JoinFlag = JoinArray[row][8];
        ToTableNum = GetTableNum(ToTable);
        FromJoin = "";
        ToJoin = "";
        LeftOuter = "";
        RightOuter = "";
        if (JoinFlag == "1") { LeftOuter  = "OUTER "; }
        if (JoinFlag == "2") { RightOuter = "OUTER "; }
        if (JoinFlag == "3") { RightOuter = "CROSS "; }

        //Make the From Joined Table Name be a hyperlink:
        TheLink = BuildTableHyperLink(FromTableNum);
        //If there's an alias, show the alias, and put the real table in parens & hyperlinked

        switch(FromAlias){
          case "","null":
            FromJoin = RightOuter + TheLink + Dot + FromRel;
            break;
          default:
            FromJoin = RightOuter + FromAlias + "(" + TheLink + ")" + ((FromRel != undefined) ? (Dot + FromRel) : "");
            break;
        }

        //Make the To Joined Table Name be a hyperlink:
        TheLink = BuildTableHyperLink(ToTableNum);
        //If there's an alias, show the alias, and put the real table in parens & hyperlinked

        switch(ToAlias) {
          case "","null":
            ToJoin = LeftOuter + TheLink + Dot + ToRel;
            break;
          default:
            ToJoin = LeftOuter + ToAlias + ((ToRel != undefined) ? ("(" + TheLink + ")" + Dot + ToRel) : "");
            break;
        }

        rw("<tr>");
        rw("<td>");
        rw(FromJoin);
        rw("</td>");
        rw("<td>");
        rw(ToJoin);
        rw("</td>");
        rw("</tr>");
      }
      rw("</table>");

      rsJoins.Close;
      rsJoins = null;

      //Print the filter
      if(filterSQL != "") {
        rw("<h4 id='filters'>Filters:</h4>");
        rw(filterSQL.replace(/\n/g,"<br/>"));
      }

      //Print the Table of Union Views this view contributes to
      if(unionViewsList.length > 0) {
        rw("<h4 id='contribs'>Contributes To UNION Views:</h4>");
        rw("<table id='contribs' class='tablesorter'>");
        rw("<thead><tr>");
        rw("<th>");
        rw("View Name");
        rw("</th>");
        rw("</tr></thead>");

        for(var j=0; j < unionViewsList.length; j++) {
          rw("<tr>");
          rw("<td>");
          rw(BuildViewHyperLink(unionViewsList[j][0]));
          rw("</td>");
          rw("</tr>");
        }
        rw("</table>");
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
<script type="text/javascript" src="js/columnSelect.js"></script>
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

  $(".tablesorter.fields").tablesorter({ sortList: [[0,0]], });
  $(".tablesorter.joins").tablesorter();
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
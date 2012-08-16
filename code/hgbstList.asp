<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  lists.asp
//
// Description    :  List Viewer
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
<style>
label {
   display: inline;
   margin: .5em;
   font-size: 1.2em;
   font-weight: bold;
}
select {
   margin: .5em;
   min-width: 550px;
}
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Lists";
var sPageType = "lists";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
var objid = Request("objid") - 0;
var title = Request("title") + "";
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
   <div class="row-fluid">
      <div class="span2"></div>
      <div id="gbstContainer" class="span8 topMargin">

         <h5><a href="lists.asp" class="pull-right">(Back to Lists)</a></h5>

         <h3>User Defined List: <%=title%></h3>

         <div class="playlist topMargin">
            <label>Level 1</label><select id="level1"></select><br/>
            <label>Level 2</label><select id="level2"></select><br/>
            <label>Level 3</label><select id="level3"></select><br/>
            <label>Level 4</label><select id="level4"></select><br/>
            <label>Level 5</label><select id="level5"></select><br/>
         </div>
      </div>

      <div class="span2"></div>
   </div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/multiLevelListHelper.js"></script>

<script type="text/javascript">
$(document).ready(function() {
   var path = window.location.pathname;
   var page = path.substr(path.lastIndexOf("/")+1);
   $("ul.nav li a[href$='" + page + "']").parent().addClass("active");
   $(".navbar").find(".connected").text("<%=connect_info%>");
   document.title = "Bolt: <%=sPageTitle%>";

   var multiLevelList = new multiLevelListHelper('<%=title%>', ['level1','level2','level3','level4','level5'], ['','','','','']);
   multiLevelList.populate();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
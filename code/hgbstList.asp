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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="bs4/css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style4.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "User Defined List";
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
<!--#include file="inc/navbar4.inc"-->
<div class="container-fluid">
   <div class="row">
      <div id="gbstContainer" class="col-10 offset-2 mt-2">

         <h5 class="text-right"><a href="lists.asp">(Back to Lists)</a></h5>
         <h3 class="mb-4">User Defined List: <%=title%></h3>

         <div class="form-group row">
           <label for="level1" class="col-1 col-form-label">Level 1</label>
           <select class="form-control col-6" id="level1"></select>
         </div>
         <div class="form-group row">
           <label for="level2" class="col-1 col-form-label">Level 2</label>
           <select class="form-control col-6" id="level2"></select>
         </div>
         <div class="form-group row">
           <label for="level3" class="col-1 col-form-label">Level 3</label>
           <select class="form-control col-6" id="level3"></select>
         </div>
         <div class="form-group row">
           <label for="level4" class="col-1 col-form-label">Level 4</label>
           <select class="form-control col-6" id="level4"></select>
         </div>
         <div class="form-group row">
           <label for="level5" class="col-1 col-form-label">Level 5</label>
           <select class="form-control col-6" id="level5"></select>
         </div>
      </div>
   </div>
</div>
</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/multiLevelListHelper.js"></script>
<script type="text/javascript">
$(document).ready(function() {
   var path = window.location.pathname;
   var page = path.substr(path.lastIndexOf("/")+1);
   $("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
   $(".navbar").find(".connected").text("<%=connect_info%>");
   document.title = "Bolt: <%=sPageTitle%>";

   var multiLevelList = new multiLevelListHelper('<%=title%>', ['level1','level2','level3','level4','level5'], ['','','','','']);
   multiLevelList.populate();
   $("#level1").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
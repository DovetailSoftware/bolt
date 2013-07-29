<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  admin.asp
//
// Description    :  Database Connection Input Form
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
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var type_name = Request("type_name");
var rsSpecRelID;

var sPageTitle = "Administration";
var sPageType = "Admin";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
var read_only_udl = udl_file.Attributes & 1;

FSO = null;
udl_file = null;

if(read_only_udl) Response.Redirect("online.asp");

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<%
	TheSQL = "select * from " + GLOBAL_HEADER_TABLE;
	rsADP = Server.CreateObject("ADODB.Recordset");
	rsADP.CursorLocation = gCursorLocation;
	rsADP.ActiveConnection = dbConnect;
	rsADP.Source = TheSQL;
	try {
		rsADP.Open();
	} catch(e) {
		displayDBAccessErrorPage(e);
	}
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">

			<h2>Set BOLT Database</h2>
			<p><b>Warning!</b> Please keep in mind that this sets the database for everyone using this BOLT Web Application.
			<br/>This is a global, not an individual setting.</p>

		   <label class="fixedWidth">Provider:</label>
		   <select id="Provider" name="Provider">
		      <option selected value="SQLOLEDB.1">SQL Server</option>
		      <option value="OraOLEDB.Oracle">Oracle Provider</option>
		      <option value="MSDAORA.1">Microsoft Provider for Oracle</option>
		   </select>

		   <label class="fixedWidth">User ID:</label>
		   <input type="text" id="UserID" name="UserID" />

		   <label class="fixedWidth">Password:</label>
		   <input type="password" id="Password"name="Password" />

		   <label class="fixedWidth">Server:</label>
		   <input type="text" id="DBServer" name="DBServer" />

		   <div id="server">
		   	<label class="fixedWidth">Database (SQL Server): </label>
		   	<input type="text" id="Database" name="Database" />
		   </div>

		   <div id="buttonArea">
		   	<button class="btn " id="submitButton">Submit</button>
		   	<button class="btn" id="resetButton">Reset</button>
		   </div>

		</div>
		<div class="span2"></div>
	</div>

</div>
</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript">
//////////////////////////////////////////////////////////////////////
// Validate Form - make sure the correct data is filled in
//////////////////////////////////////////////////////////////////////
function validate_form() {
	var searchfield = $("#UserID");
	var filter = searchfield.val();
   if (filter.length == 0) {
      alert("You must specify a User ID.");
		searchfield.focus();
      return false;
   }

	var searchfield = $("#Password");
	var filter = searchfield.val();
   if (filter.length == 0) {
      alert("You must specify a Password.");
	   searchfield.focus();
      return false;
   }

	var searchfield = $("#DBServer");
	var filter = searchfield.val();
   if (filter.length == 0) {
      alert("You must specify a Server.");
		searchfield.focus();
      return false;
   }

	var searchfield = $("#Provider");
   var TheProvider = searchfield.val();

   //Database is required for non-Oracle providers
   if (TheProvider != "MSDAORA.1" && TheProvider != "OraOLEDB.Oracle") {
		var searchfield = $("#Database");
		var filter = searchfield.val();
      if (filter.length == 0) {
         alert("You must specify a Database.");
			searchfield.focus();
         return false;
      }
   }

   return true;
}

function changeDatabase() {

	if(!validate_form()) return;

	var databaseData = {
	   Provider: $("#Provider").val(),
	   UserID: $("#UserID").val(),
	   Password: $("#Password").val(),
	   DBServer: $("#DBServer").val(),
	   Database: $("#Database").val()
	}

	$.ajax({
	   type: "POST",
	   url: "admin2.asp",
	   dataType: "json",
	   cache: false,
	   data: databaseData,
	   success: function(results) {
	      if(results.success == true) {
	         window.location = "index.asp";
	      } else {
	         alert("An error occurred while updating database: " + results.errorMessage);
	      }
	   },
	   error: function(xhr) {
	      alert("An error occurred while updating database in admin2.asp");
	   }
	});
}

$(document).ready(function() {
	$("ul.nav li a[href$='index.asp']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

   $("#Provider").change(function() {
      var TheProvider =$("#Provider").val()
	   if(TheProvider == "MSDAORA.1" || TheProvider == "OraOLEDB.Oracle") {
	      $("#server").hide();
      } else {
	      $("#server").show();
      }
   });

   $("#submitButton").click(changeDatabase);

   $("input:text").keypress(function(event) {
		if(event.keyCode == 13) $("#submitButton").click();
	});

   $("#Provider").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
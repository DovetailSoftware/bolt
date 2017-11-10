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
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/font-awesome.min.css" rel="stylesheet">
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

if (read_only_udl) Response.Redirect("index.asp");
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<script type="text/javascript">
(function(){
    var keyPaths = [];

    var saveKeyPath = function(path) {
        keyPaths.push({
            sign: (path[0] === '+' || path[0] === '-')? parseInt(path.shift()+1) : 1,
            path: path
        });
    };

    var valueOf = function(object, path) {
        var ptr = object;
        for (var i=0,l=path.length; i<l; i++) ptr = ptr[path[i]];
        return ptr;
    };

    var comparer = function(a, b) {
        for (var i = 0, l = keyPaths.length; i < l; i++) {
            aVal = valueOf(a, keyPaths[i].path);
            bVal = valueOf(b, keyPaths[i].path);
            if (aVal > bVal) return keyPaths[i].sign;
            if (aVal < bVal) return -keyPaths[i].sign;
        }
        return 0;
    };

    Array.prototype.sortBy = function() {
        keyPaths = [];
        for (var i=0,l=arguments.length; i<l; i++) {
            switch (typeof(arguments[i])) {
                case "object": saveKeyPath(arguments[i]); break;
                case "string": saveKeyPath(arguments[i].match(/[+-]|[^.]+/g)); break;
            }
        }
        return this.sort(comparer);
    };    
})();

var allowConnectionSaves = ("<%=allowConnectionSaves%>" === "True");
var storedConnections = JSON.parse(localStorage.getItem('storedConnections'));
if(storedConnections == undefined) storedConnections = [];

storedConnections.sortBy('Provider', 'DBServer', 'Database');

var connectionIndex = 0;
</script>
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<!--#include file="inc/notifications.inc"-->
<div class="container-fluid">
	<div class="row">
		<div class="col-8 offset-2">

			<h2>Connect to BOLT Database</h2>
			<p class="mt-3"><b>Warning!</b> Please keep in mind that this sets the database for everyone using this BOLT Web Application.
			<br/>This is a global, not an individual setting.</p>

			<div class="form-group row mb-1 mt-4">
				<label class="form-label col-3">Provider</label>
				<select class="form-control col-3" id="Provider" name="Provider">
					<option selected value="SQLNCLI11.1">SQL Native Client</option>
					<option value="SQLOLEDB.1">SQL Server</option>
					<option value="OraOLEDB.Oracle">Oracle Provider</option>
					<option value="MSDAORA.1">Microsoft Provider for Oracle</option>
				</select>
			</div>

			<div class="form-group row my-1">
				<label class="form-label col-3">User ID</label>
		   	<input class="form-control col-3" type="text" id="UserID" name="UserID" />
			</div>

			<div class="form-group row my-1">
				<label class="form-label col-3">Password:</label>
				<input class="form-control col-3" type="password" id="Password"name="Password" />
			</div>

			<div class="form-group row my-1">
				<label class="form-label col-3">Server:</label>
				<input class="form-control col-3" type="text" id="DBServer" name="DBServer" />
			</div>

			<div id="server" class="form-group row my-1">
				<label class="form-label col-3">Database (SQL Server): </label>
				<input class="form-control col-3" type="text" id="Database" name="Database" />
			</div>

		  <div class="form-group row mt-3">
			  <div class="col-3 offset-3 px-0">
					<button class="btn btn-sm btn-primary col-5" id="submitButton">Submit</button>
					<button class="btn btn-sm btn-primary col-5" id="resetButton">Reset</button>
				</div>
			</div>

		  <div id="connections" class="form-group row mt-5 hide">
		    <div class="col-8">
		      <div class="form-group">
		        <h5 class="mb-0 list-inline-item">Stored Connections</h5>
		        <button class="btn btn-sm btn-success pointer" id="storeConnection" onclick="storeConnection()" title="Store Connection"><i class="fa fa-arrow-circle-down"></i></button>
		        <button class="btn btn-sm btn-default pointer" onclick="clearStoredConnections()" title="Remove all Stored Connections"><i class="fa fa-trash"></i></button>
		        <div id='stored-connections' class="mt-1 list-group"></div>
		      </div>    
		    </div>
		  </div>

		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/notifications.js"></script>
<script type="text/javascript">
//////////////////////////////////////////////////////////////////////
// Validate Form - make sure the correct data is filled in
//////////////////////////////////////////////////////////////////////
function validate_form() {
	var searchfield = $("#UserID");
	var filter = searchfield.val();
  if (filter.length == 0) {
		addNotification('You must specify a User ID.');
		searchfield.focus();
    return false;
  }

	var searchfield = $("#Password");
	var filter = searchfield.val();
  if (filter.length == 0) {
		addNotification('You must specify a Password.');
    searchfield.focus();
    return false;
  }

	var searchfield = $("#DBServer");
	var filter = searchfield.val();
  if (filter.length == 0) {
		addNotification('You must specify a Server.');
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
			addNotification('You must specify a Database.');
			searchfield.focus();
      return false;
    }
  }

  return true;
}

function clearStoredConnections() {
  storedConnections = [];
  localStorage.setItem('storedConnections', JSON.stringify(storedConnections));
  
  $('input.stored').each(function() {
    var i = $(this).data('index');
    $('#remove'+i).trigger('click');
  });
}

function storeConnection() {
	var databaseData = {
	   Provider: $("#Provider").val(),
	   UserID: $("#UserID").val(),
	   Password: $("#Password").val(),
	   DBServer: $("#DBServer").val(),
	   Database: $("#Database").val()
	}

  var found = storedConnections.indexOf(databaseData) > -1;
  if(found) {
    $('input.stored[value="'+databaseData+'"]').each(function() {
      var i = $(this).data('index');
      $('#remove'+i).trigger('click');
    });
  }

  storedConnections.push(databaseData);
  localStorage.setItem('storedConnections', JSON.stringify(storedConnections));
  appendConnection(databaseData);
}

function appendConnection(connection) {
  var i = connectionIndex++;

	var provider = 'SQL';
	var name = connection.DBServer + ': ' + connection.Database;

	if(connection.Provider == "MSDAORA.1" || connection.Provider == "OraOLEDB.Oracle") {
		provider = 'Oracle';
		name = connection.DBServer;
	}

	var connectionTitle = provider + ': ' + name;

  var cmd = '<div class="storage input-group mb-1">' +
      '<span class="input-group-btn">' +
      '  <button class="load btn btn-success btn-sm pointer" title="Load Connection" type="button"><i class="fa fa-arrow-circle-up"></i></button>' +
      '</span>' +
      '<input id="connection'+i+'" type="text" class="stored form-control p-1" title="Load Connection" readonly value="'+ connectionTitle +'" title="'+connection.Database+ '" data-index="'+i+'">' +
      '<span class="input-group-btn">' +
      '  <button id="remove'+i+'" class="btn btn-default btn-sm pointer" type="button" title="Remove Connection" data-index="'+i+'"><i class="fa fa-trash"></i></button>' +
      '</span>' +
    '</div>';

  $('#stored-connections').prepend(cmd);
  $('#connection'+i).data('conn', connection);

  $('#remove'+i).click(function() {
    removeConnection(this);
  });

  $("button.load")
    .unbind("click")
    .on("click", function () {
      loadConnectionForId($(this).parents('div').children('input').prop('id'));
    });

  $("input.stored")
    .unbind("click")
    .on("click", function () {
      loadConnectionForId($(this).prop('id'));
    });
}

function loadConnectionForId(id) {
	var connection = $('#'+id).data('conn');
	$("#Provider").val(connection.Provider).trigger('change');
	$("#UserID").val(connection.UserID);
	$("#Password").val(connection.Password);
	$("#DBServer").val(connection.DBServer);
	$("#Database").val(connection.Database);
}

function removeConnection(el) {
  var dropConnection = $(el).parents('div').children("input").data('conn');

  var $div = $(el).parents('div.storage');
  var i = $(el).data('index');
  $div.remove();

  storedConnections = storedConnections.filter(function(item) { 
    return item !== dropConnection;
  });
  localStorage.setItem('storedConnections', JSON.stringify(storedConnections));
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
       		 addNotification("An error occurred while updating database: " + results.errorMessage);
	      }
	   },
	   error: function(xhr) {
   		 addNotification('An error occurred while updating database in admin2.asp');
	   }
	});
}

$(document).ready(function() {
	$("ul.navbar-nav li a[href$='index.asp']").parent().addClass("active");
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

	if(allowConnectionSaves) {
		$('#connections').show();

	  storedConnections.forEach(function(connection) {
	    appendConnection(connection);
	  });
	}

  $("#UserID").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
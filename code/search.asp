<%@ Language="JavaScript" codepage=65001 %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  search.asp
//
// Description    :  Get search results from seeker and display grid
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
// Copyright (C) 2001-2014 Dovetail Software, Inc.
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
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Search";
var sPageType = "Schema";
%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row-fluid bottomMargin">
		<div class="span12 topMargin">
	  	<div class="header span7 offset5">
		  	<h3>Seeker Search</h3>
<%
  var seeker = "";
  try { seeker = seekerUrl; } catch(e) {}
  if(seeker === "") {
%>
  		</div>
	  	<div class="span9 offset3">
       	<h4 class="error">Seeker has not been configured for this installation of BOLT.</h4>
  		</div>
		</div>
	</div>
</div>
</div>
</body>
</html>
<%
    Response.End();
  } else {
    Response.Write("<script type='text/javascript'>var seekerUrl = '" + seekerUrl + "';</script>");
%>
  		</div>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span10 offset2 form-horizontal compressed-form">
			<div class="control-group">
  			<label class="control-label">Select a domain</label>
				<select id="domain" name="domain" class="input controls margin-default-left" size="1"></select>
			</div>

			<div class="control-group">
  			<label class="control-label">Enter a query</label>
				<input type="text" id="query" name="query" class="input controls margin-default-left input-xxlarge"></input>
				<span class="hide error">Query string is required.</span>
			</div>

			<div class="control-group">
  			<label class="control-label">&nbsp;</label>
				<button id="search" disabled class="btn btn-primary input controls margin-default-left input-medium">Search</button>
			</div>
		</div>
	</div>

	<div class="row-fluid">
		<div class="span12">
  		  <h4 class="inline-block">Search Results</h4>
        <ul class="pager no-margin inline-block pull-right">
          <li><a id="prev" href="#">Previous</a></li>
          <li><a id="next" href="#">Next</a></li>
        </ul>
  		  <h4 class="index inline-block pull-right">&nbsp;</h4>
    </div>
	</div>

	<div class="row-fluid">
		<div class="span12">
		  <table id="results" class="table table-condensed table-bordered tablesorter">
		    <thead></thead>
		    <tbody></tbody>
      </table>
  	</div>
	</div>
<%
  }
%>
</div>
</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/json2.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
var _pageNumber = 0;
var _lastPage = 0;
var _resultsPerPage = 18;
var _sortedByField = '';
var _isSortedAscending = false;
var _searchUrl = '';
var _domain = '';
var _fields = [];

function executeQuery() {
  var query = $("#query").val();
  if(query.length == 0) query = "%";
  _searchUrl = seekerUrl + "/search?query=" + query + "%20domain:" + _domain + "&startResultIndex=" + (_pageNumber * _resultsPerPage) + "&resultCount=" + _resultsPerPage;
  $.each(_fields, function(i, field) {
    if(i > 2) _searchUrl += "&returnCustomField=" + field;
  });

  $.get(_searchUrl, function(res) {
    $("#results tbody").empty();

    $.each(res.SearchResults, function(i, result) {
      var row = "<tr><td>" + result.Id + "</td><td>" + $.trim(result.Title) + "</td><td>" + $.trim(result.Summary) + "</td>";
      $.each(_fields, function(i, field) {
        if(i > 2) row += "<td>" + $.trim(result.CustomFields[field]) + "</td>";
      });

      $("#results tbody").append(row);
    });

    _resultsPerPage = res.RequestedNumberOfResults;
    _lastPage = Math.floor(res.TotalNumberOfResults / res.RequestedNumberOfResults);
    $("h4.index").text("Page " + (_pageNumber+1) + " of " + (_lastPage+1));
  });
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	document.title = "Bolt: <%=sPageTitle%>";

  $.get(seekerUrl + "/specifications/index", function(res) {
    $.each(res, function(i, domainObject) {
      var d = $.parseJSON(JSON.stringify(domainObject));
      var domainFields = 'Id,Title,Summary,' + d.Fields;
      $("#domain").append("<option value='" + d.Domain + "' data-fields='" + domainFields + "'>" + d.Domain + "</option>");
    });

    $("#domain").change(function() {
      _domain = $(this).val();
      _fields = $("#domain option:selected").data("fields").split(",");
      $("#results tbody").empty();
      $("#results thead").empty().append("<tr></tr>");
      $.each(_fields, function(i, field) {
        $("#results thead tr").append("<th>" + field + "</th>");
      });
    }).trigger('change');
    $("#search").prop("disabled", false);

  }).fail(function() {
    $("<h5 class='error'>Could not access Seeker with URL '" + seekerUrl + "'</h5>").prependTo("div.topMargin");
  });

  // set up paging buttons (startResultIndex)
  $("#prev").click(function() {
    if(_pageNumber > 0) _pageNumber--;
    executeQuery();
  });
  $("#next").click(function() {
    if(_pageNumber < _lastPage) _pageNumber++;
    executeQuery();
  });

  $("#search").click(function() {
    _pageNumber = 0;
    executeQuery();
  });

 	$(".tablesorter tbody").on("click", "tr", function () {
    $(this).toggleClass("highlight");
 	});

	$("#query")
	  .keypress(function(e) {
	    if (e.keyCode === 13) executeQuery();
	  })
	  .focus();
});
</script>
</html>
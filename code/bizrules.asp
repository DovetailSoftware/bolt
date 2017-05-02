<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  bizrules.asp
//
// Description    :  Filter page for viewing Business Rules
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
<link href="css/bizrules.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Business Rules";
var sPageType = "BizRules";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<div class="container-fluid">
	<div class="row">
		<div class="col-8 card bg-faded offset-2 my-3">
			<h3>Business Rule Usage Report</h3>			
			<p>This report allows you to see the rules that are fired, including their frequency. <a href="business_rule_report.asp">Run Report</a></p>
		</div>
	</div>
<hr/>
	<div class="row">
		<form method="POST" name ="bizrules" action="bizrules2.asp" class="form col-8 offset-2">
			<h3>Search for Business Rules where</h3>
			<div class="form-group row mb-1 mt-3">
				<label class="col-4 col-form-label">Title</label>				
				<select class="form-control col-3 mr-1" name="operator" name="operator">
			   	<option selected value="like">starts with</option>
			   	<option value="=">equals</option>
				</select>
				<input class="form-control col-4" type="text" id="filter" name="filter" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Rule Set</label>				
				<select class="form-control col-3 mr-1" id="operator2" name="operator2">
					<option selected value="like">starts with</option>
					<option value="=">equals</option>
				</select>
				<input class="form-control col-4" type="text" id="filter2" name="filter2" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Start Event</label>				
				<select class="form-control col-3 mr-1" id="operator3" name="operator3">
			   	<option selected value="like">starts with</option>
			   	<option value="equals">equals</option>
			 	</select>
				<input class="form-control col-4" type="text" id="filter3" name="filter3" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Cancel Event</label>				
				<select class="form-control col-3 mr-1" id="operator4" name="operator4">
					<option selected value="like">starts with</option>
					<option value="equals">equals</option>
				</select>
				<input class="form-control col-4"  type="text" id="filter4" name="filter4" /> 
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Rule Status</label>				
				<label class="col-3 mr-1 col-form-label">Equals</label>				
				<select class="form-control col-4" id="rule_status" name="rule_status">
			   	<option selected value="All">All</option>
			   	<option value="Active">Active</option>
			   	<option value="Inactive">Inactive</option>
			 	</select>
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Object Type</label>				
				<label class="col-3 mr-1 col-form-label">Equals</label>				
				<select class="form-control col-4" id="object_type" name="object_type">
					<option selected value="All">All</option>
					<option>Case</option>
					<option>Subcase</option>
					<option>Solution</option>
					<option>Change Request</option>
					<option>Part Request Detail</option>
					<option>Part Transaction Record</option>
					<option value="contract">Quote/Contract/Order</option>
					<option>Opportunity</option>
					<option>Action Item</option>
					<option>Exchange</option>
					<option>Count Setup</option>
					<option>Lead</option>
					<option>Account</option>
					<option>Dialogue</option>
					<option>Communication</option>
					<option>Contact</option>
				</select>
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Condition Property</label>				
				<select class="form-control col-3 mr-1" id="cond_prop_operator" name="cond_prop_operator">
					<option selected value="like">starts with</option>
					<option value="equals">equals</option>
				</select>
				<input class="form-control col-4" type="text" name="cond_prop_filter" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Condition Value</label>				
				<select class="form-control col-3 mr-1" name="cond_value_operator">
			   	<option selected value="like">starts with</option>
			   	<option value="equals">equals</option>
			  </select>
				<input class="form-control col-4" type="text" id="cond_value_filter" name="cond_value_filter" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Action Type</label>				
				<label class="col-3 mr-1 col-form-label">Equals</label>				
				<select class="form-control col-4" name="action_type">
					<option selected value="0">All</option>
					<option value="3">Command Line</option>
					<option value="2">Message</option>
					<option value="4">Service Message</option>
					<option value="1001">Carrier Message</option>
				</select>
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Message</label>				
				<select class="form-control col-3 mr-1" id="message_value_operator" name="message_value_operator">
	    		<option selected value="contains">contains</option>
	    		<option value="starts with">starts with</option>
	    		<option value="equals">equals</option>
	  		</select>
				<input class="form-control col-4" type="text" id="message_value_filter" name="message_value_filter" />
			</div>

			<div class="form-group row my-1">
				<label class="col-4 col-form-label">Pager Message</label>				
				<select class="form-control col-3 mr-1" name="pager_message_value_operator" id="pager_message_value_operator">
			   	<option selected value="contains">contains</option>
			   	<option value="starts with">starts with</option>
			   	<option value="equals">equals</option>
			   	<option value="is not empty">is not empty</option>
		  	</select>
				<input class="form-control col-4" type="text" id="pager_message_value_filter" name="pager_message_value_filter" />
			</div>

			<div class="form-group row my-1">
				<label class="col-8 offset-4 col-form-label">
	  			<input type="checkbox" name="SuppressActions" id="SuppressActions" checked/> Hide Rule Actions in Results					
				</label>				
			</div>

			<div class="form-group row my-1">
				<label class="col-8 offset-4 col-form-label">Note: All Filters are <b>AND</b>ed together</label>				
			</div>

			<div class="form-group row my-1">
				<button id="search" class="col-3 mr-1 offset-4 btn btn-primary btn-block">Search</button>
			</div>
		</form>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#filter").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
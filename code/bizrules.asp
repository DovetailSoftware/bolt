<%@ language="JavaScript" %>
<!DOCTYPE html>
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
<link href="css/jquery.tablesorter.css" rel="stylesheet">
<style>
.span8 h3 { text-align: center;margin-bottom: .5em; }
#reportContainer table * { margin-bottom: .4em; }
label { display: inline-block }
</style>
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
	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">

			<h3>Business Rule Usage Report</h3>

			<div class="centered_wrapper" />
				<p class="centered" style="text-align:center"><a href="business_rule_report.asp">Business Rule Usage Report</a></p>
			</div>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="reportContainer" class="span8">

			<form method="POST" name ="bizrules" action="bizrules2.asp" />
			<h3>Search for Business Rules where</h3>

			<table class="shrink" align="center">
			<tr>
				<td>Title</td>
				<td>
					<select name="operator" size="1">
				   	<option selected value="like">starts with</option>
				   	<option value="=">equals</option>
					</select>
				</td>
				<td><input type="text" id="filter" name="filter"><td>
			</tr>
			<tr>
				<td>Rule Set</td>
				<td>
					<select name="operator2" size="1">
						<option selected value="like">starts with</option>
						<option value="=">equals</option>
					</select>
				</td>
				<td><input type="text" name="filter2"></td>
			</tr>
			<tr>
				<td>Start Event</td>
				<td>
					<select name="operator3" size="1">
				   	<option selected value="like">starts with</option>
				   	<option value="equals">equals</option>
				  	</select>
				</td>
				<td><input type="text" name="filter3"></td>
			</tr>
			<tr>
				<td>Cancel Event</td>
				<td>
					<select name="operator4" size="1">
						<option selected value="like">starts with</option>
						<option value="equals">equals</option>
					</select>
				</td>
				<td><input  type="text" name="filter4"></td>
			</tr>
			<tr>
				<td>Rule Status</td>
				<td>Equals</td>
				<td>
					<select name="rule_status" size="1">
				   	<option selected value="All">All</option>
				   	<option value="Active">Active</option>
				   	<option value="Inactive">Inactive</option>
				  	</select>
				</td>
			</tr>
			<tr>
				<td>Object Type</td>
				<td>Equals</td>
				<td>
					<select name="object_type" size="1">
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
				</td>
			</tr>
			<tr>
				<td class="padRight">Condition Property</td>
				<td>
					<select name="cond_prop_operator" size="1">
						<option selected value="like">starts with</option>
						<option value="equals">equals</option>
					</select>
				</td>
				<td><input type="text" name="cond_prop_filter" /></td>
			</tr>
			<tr>
				<td>Condition Value</td>
				<td>
					<select name="cond_value_operator" size="1">
				   	<option selected value="like">starts with</option>
				   	<option value="equals">equals</option>
				  	</select>
				</td>
				<td><input type="text" name="cond_value_filter" /></td>
			</tr>
			<tr class="action_filter">
				<td>Action Type</td>
				<td>Equals</td>
				<td>
					<select name="action_type" size="1" style="display:inline">
						<option selected value="0">All</option>
						<option value="3">Command Line</option>
						<option value="2">Message</option>
						<option value="4">Service Message</option>
					</select>
				</td>
			</tr>
			<tr class="action_filter">
				<td>Message</td>
				<td>
					<select name="message_value_operator" size="1">
			    		<option selected value="contains">contains</option>
			    		<option value="starts with">starts with</option>
			    		<option value="equals">equals</option>
			  		</select>
				</td>
				<td>
					<input type="text" name="message_value_filter" />
				</td>
			</tr>
			<tr class="action_filter">
				<td>Pager Message</td>
				<td>
					<select name="pager_message_value_operator" id="pager_message_value_operator" size="1">
				   	<option selected value="contains">contains</option>
				   	<option value="starts with">starts with</option>
				   	<option value="equals">equals</option>
				   	<option value="is not empty">is not empty</option>
				  	</select>
				</td>
				<td>
					<input type="text" name="pager_message_value_filter" id="pager_message_value_filter" />
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<input type="checkbox" name="SuppressActions" id="SuppressActions" style="width:20px;margin-right:10px" checked><label for="SuppressActions">Hide Rule Actions in Results</label>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3">Note: All Filters are ANDed together</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><button id="search" class="btn btn-primary">Search</button></td>
			</tr>
			</table>
			</form>
		</div>
		<div class="span2"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
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
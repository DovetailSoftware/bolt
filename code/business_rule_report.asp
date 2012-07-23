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
#headerContainer, .span12 { margin: 20px 0; }
table.leftHeader thead th { text-align: left; }
#filters span, #filters a { margin-right: 1em; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<!--#include file="inc/report.inc"-->
<%

var sPageTitle = "Business Rule Usage Report";
var sPageType = "BizRules";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/inc_vbscript.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
	//Setup start & end dates
	var when = Request("when") + "";
	if(when == "undefined" || when == "null") when = "last_30_days";

	var start = getStartDate(when);
	var end = getEndDate(when);
	var totalRulesFired = 0;
	var numberOfRuleActions = 0;

	//Setup a recordset to hold all of our rule and action data
	var rs = Server.CreateObject( "ADODB.Recordset");
	rs.Fields.Append("rulename", adLongVarWChar, 8000);
	rs.Fields.Append("action", adVarWChar, 1000);
	rs.Fields.Append("fired", adInteger);
	rs.Fields.Append("create_activity_log", adInteger);
	rs.Fields.Append("objid", adInteger);
	rs.Open();
%>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">
			<h3>Business Rule Usage Report (<%=whenString(when)%>)</h3>
			<div class="centered_wrapper" >
			<p class="centered" id="time_periods">
				<span id="time_periods_heading">Filter by Time Period:</span>
				<div id="filters">
				<%
				var now = new Date();
				var thisYear = now.getFullYear();
				var lastYear = now.getFullYear() - 1;
				var curr_month = now.getMonth();
				var thisMonth = monthAbbreviationArray[curr_month];
				var last_month = curr_month - 1;

				if(last_month == - 1) last_month = 11;
				var lastMonth = monthAbbreviationArray[last_month];
				%>
				<%=BuildTimeFilter("last_30_days","Last 30 Days",when)%>
				<%=BuildTimeFilter("last_365_days","Last 365 Days",when)%>
				<%=BuildTimeFilter("this_month","This Month (" + thisMonth + ")",when)%>
				<%=BuildTimeFilter("last_month","Last Month (" + lastMonth + ")",when)%>
				<%=BuildTimeFilter("this_year","This Year (" + thisYear + ")",when)%>
				<%=BuildTimeFilter("last_year","Last Year (" + lastYear + ")",when)%>
				</div>
			</p>
			</div>

			<p align="center" id="loading" class="highlight info" >Loading...</p>

			<%
			  Response.Flush();
				FillRecordSetWithRulesThatFired(rs, start, end);
				FillRecordSetWithRemainingRules(rs);
			%>

			<table class="tablesorter fullWidth">
				<thead>
					<tr><th>Rule Name</th><th>Rule Action</th><th># of times rule fired</th><th>&nbsp;</th></tr>
				</thead>
				<tbody>
					<%	WriteReport(rs);
						rs.Close();
					%>
				</tbody>
				<tfoot>
					<tr><th>Totals</th><th><%=numberOfRuleActions%>&nbsp;Business Rule Actions</th><th class="centerMiddle"><%=totalRulesFired%></th><th>&nbsp;</th></tr>
				</tfoot>
			</table>

		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div class="span8">
			<p class="centered"><img src="img/icon-warning.png" alt="warning"/>
			<strong>Regarding the Warning:</strong>
			If a rule action has its <em>Create Activity Log</em> option set to No, then the number of times the rule fired will always be zero.
			If you wish the number of rule firings to be accurate for this rule, check the <em>Create Activity Log on Action</em> checkbox
			for this rule action in your Business Rule Editor.</p>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div class="span8">
			<p class="centered"><strong>About this report:</strong>
			This report allows you to see the rules that are fired, including their frequency.
			Perhaps even more importantly, it allows you to see the rules that are not being fired.
			Perhaps those rules could be removed, or made inactive, therefore simplifying your business rule administration.
			</p>
		</div>
		<div class="span2"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
function DisplayReport(when){
	var href="business_rule_report.asp?when=" + when;
	window.location=href;
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#loading").hide();

   $(".tablesorter").tablesorter({
		widgets: ['zebra']
	});
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
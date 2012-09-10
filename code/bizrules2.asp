<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  bizrules2.asp
//
// Description    :  Business Rule Details
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
<link href="css/tablesorter.css" rel="stylesheet">
<style>
.span12 h3 { text-align: center;margin-bottom: .5em; }
label { display: inline-block }
table.tablesorter thead tr th { font-weight: bold; }
table.tablesorter th, table.tablesorter td { white-space: normal;font-size: .9em;line-height:14px; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Business Rules";
var sPageType = "BizRules";

var forceDisplay = false;
if(Request("forceDisplay") == 1) forceDisplay = true;

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
%>
<div class="container-fluid">
	<div class="row-fluid topMargin">
		<div id="headerContainer" class="span12">
		<%
			var rs = Server.CreateObject("ADODB.Recordset");
			rs.ActiveConnection = dbConnect;
			var provider = rs.ActiveConnection.Provider + "";

			if(dbType == "Oracle" && provider == "MSDAORA.1") {
				var err = {};
				err.description = "<h4>Unsupported Oracle Provider</h4>";
				var details = "The Microsoft provider for Oracle (" + provider + ") is not supported for Business Rules.";
				details += "<br/>Use the Oracle provider (OraOLEDB.Oracle) instead.";
				details += "<p>The provider can be configured in the BOLT.UDL file or via the <a href='admin.asp'>admin page</a>.</p>";
			 	displayDBAccessErrorPage(err,details);
			}

			//Get the Posted Data
			//Where necessary, upper case the data
			//This is necessary because these fields do not have S_ fields in Oracle
			//And Oracle is case sensitive
			TitleOperator=Request("operator");
			TitleFilter=SQLFixup(Request("filter") + "");

			RuleSetOperator=Request("operator2");
			RuleSetFilter=SQLFixup(Request("filter2") + "");

			StartEventOperator=Request("operator3");
			StartEventFilter=SQLFixup(String(Request("filter3") + "").toUpperCase());

			StopEventOperator=Request("operator4");
			StopEventFilter=SQLFixup(String(Request("filter4") + "").toUpperCase());

			ConditionPropertyOperator=Request("cond_prop_operator");
			ConditionPropertyFilter=SQLFixup(String(Request("cond_prop_filter") + "").toUpperCase());

			ConditionValueOperator=Request("cond_value_operator");
			ConditionValueFilter=SQLFixup(String(Request("cond_value_filter") + "").toUpperCase());

			MessageValueOperator=Request("message_value_operator");
			MessageValueFilter=SQLFixup(String(Request("message_value_filter") + ""));

			PagerMessageValueOperator=Request("pager_message_value_operator");
			PagerMessageValueFilter=SQLFixup(String(Request("pager_message_value_filter") + ""));

			RuleStatusFilter=Request("rule_status");

			ObjectTypeFilter=String(Request("object_type") + "").toUpperCase();
			if(ObjectTypeFilter == "ALL") ObjectTypeFilter = "";

			ActionTypeFilter=Request("action_type") - 0 ;

			SuppressActions=Request("SuppressActions");

			bSuppressActions = false;

			TableWidth = "150";

			if(SuppressActions == "ON") {
				bSuppressActions = true;
				TableWidth = "100";
			}

			//Get the Business Rules
			TheSQL = "select * from table_com_tmplte where type = 1";

			//Add the Title Filter
			if(TitleFilter != "") {
				TheSQL += " and upper(title) " + TitleOperator + " upper('" + TitleFilter;
				if(TitleOperator == "like") TheSQL += "%";
				TheSQL += "')";
			}

			//Add the Rule Set Filter
			if(RuleSetFilter != "") {
				TheSQL += " and upper(rule_set) " + RuleSetOperator + " upper('" + RuleSetFilter;
				if(RuleSetOperator == "like") TheSQL += "";
				TheSQL += "')";
			}

			//Add the Rule Status Filter
			if(RuleStatusFilter == "Active") TheSQL += " and flags = 0";
			if(RuleStatusFilter == "Inactive") TheSQL += " and flags = 65536";

			rsCT = retrieveDataFromDBStatic(TheSQL);
		%>

		<h3>Business Rules</h3>

		<table class="tablesorter" style="width:<%=TableWidth%>%;">
			<thead>
		   	<tr>
		      	<th>Title</th>
		        	<th>Rule Set</th>
		        	<th>Description</th>
		        	<th>Rule Status</th>
		        	<th>Object</th>
		        	<th>Start Event</th>
		        	<th>Cancel Event</th>
		        	<th>Conditions</th>
		      	<% if(bSuppressActions == false) { %>
	        		<th>Actions</th>
		   		<% } %>
		      </tr>
			</thead>
		<%
		//Loop through the list of rules
		while(rsCT.EOF == false) {
			// Assume that we do not display this rule
			var DisplayRow = false;

			//Get the Object Types, Start Events, Stop Events, and Conditions for the rule
			CTObjid = rsCT("objid") - 0;
			TheSQL2 = "select * from table_rule_cond where parentrule2com_tmplte = " + CTObjid;
			rsRuleCond = retrieveDataFromDB(TheSQL2);

			//Assume Active
			//If the 65536 flag is on, then it is Inactive
			Active = "Active";
			if((rsCT("flags") & 65536) > 0) Active = "Inactive";

			//Initialize the variables for each rule
			StartEvent = "";
			StopEvent = "";
			ObjectType = "";
			Condition = "";
			ConditionCount = 0;

			//Initialize the match booleans
			//These are used to determine if this rule should be visible or not
			//Normally assume true
			//If there is a filter, assume false

			StartMatch = true;
			if(StartEventFilter != "") StartMatch = false;

			StopMatch = true;
			if(StopEventFilter != "") StopMatch = false;

			ObjectTypeMatch = true;
			if(ObjectTypeFilter != "") ObjectTypeMatch = false;

			ConditionPropMatch = true;
			if(ConditionPropertyFilter != "") ConditionPropMatch = false;

			ConditionValueMatch = true;
			if(ConditionValueFilter != "") ConditionValueMatch = false;

			//Loop through the Object Types, Start Events, Stop Events, and Conditions for the rule
			while(rsRuleCond.EOF == false) {
				//Type 1 = Object Types
				//Type 2 = Start Events
				//Type 3 = Cancel Events
				//Type 4 = Conditions

				if(rsRuleCond("type") == 1) {
					strObjectType = String(rsRuleCond("operand1")).toUpperCase();

					//If we have a filter, see if we match to the filter
					//If it does, set the match boolean to True
					if(ObjectTypeFilter != "") {
						if(strObjectType == ObjectTypeFilter) ObjectTypeMatch = true;
					}
					//Append this data to the list
					ObjectType += rsRuleCond("operand1") + " ";
				}

				if(rsRuleCond("type") == 2) {
					strStartEvent = String(rsRuleCond("operand1"));

					//We have to translate some events, such as Clarify Custom & User Defined
					//Query for the Real Value
					if(strStartEvent.slice(0,7).toUpperCase() == "CLARIFY" || strStartEvent.slice(0,4).toUpperCase() == "USER" || strStartEvent.slice(0,4).toUpperCase() == "CHST") {
						TheSQL4 = "select value1 from table_value_item where value3 = '" + strStartEvent + "'";
						rsValueItem = retrieveDataFromDB(TheSQL4);
						RealStartEvent = rsValueItem("value1") + "";
						rsValueItem.Close();
					} else {
						RealStartEvent = rsRuleCond("operand1");
					}

					strRealStartEvent = String(RealStartEvent).toUpperCase();
					StartEvent += RealStartEvent + "<br/>";

					//If we have a filter, see if we match to the filter
					//If it does, set the match boolean to True
					if(StartEventFilter != "") {
						if(StartEventOperator == "equals") {
							if(strRealStartEvent == StartEventFilter) StartMatch = true;
						}
						if(StartEventOperator == "like") {
							FilterLen = String(StartEventFilter).length;
							foo = strRealStartEvent.slice(0,FilterLen);
							if(foo == StartEventFilter) StartMatch = true;
						}
					}
				}

				if(rsRuleCond("type") == 3) {
					strStopEvent = String(rsRuleCond("operand1"));

					//We have to translate some events, such as Clarify Custom & User Defined
					//Query for the Real Value
					if(strStopEvent.slice(0,7).toUpperCase() == "CLARIFY" || strStopEvent.slice(0,4).toUpperCase() == "USER" || strStopEvent.slice(0,4).toUpperCase() == "CHST") {
						TheSQL5 = "select value1 from table_value_item where value3 = '" + strStopEvent + "'";
						rsValueItem2 = retrieveDataFromDB(TheSQL5);
						RealStopEvent = rsValueItem2("value1") + "";
						rsValueItem2.Close();
					} else {
						RealStopEvent = rsRuleCond("operand1");
					}

					StopEvent += RealStopEvent + "<br/>";
					strRealStopEvent = String(RealStopEvent).toUpperCase();

					//If we have a filter, see if we match to the filter
					//If it does, set the match boolean to True
					if(StopEventFilter != "") {
						if(StopEventOperator == "equals") {
							if(strRealStopEvent == StopEventFilter) StopMatch = true;
						}
						if(StopEventOperator == "like") {
							FilterLen = String(StopEventFilter).length;
							foo = strRealStopEvent.slice(0,FilterLen);
							if(foo == StopEventFilter) StopMatch = true;
						}
					}
				}

				if(rsRuleCond("type") == 4) {
					ConditionCount++;

					//Translate the Operator from an integer to a string
					CondOperator = TranslateRuleOperator(rsRuleCond("operator"));
					ConditionProperty = String(rsRuleCond("operand1")).toUpperCase();
					ConditionValue = String(rsRuleCond("operand2")).toUpperCase();

					//If we have a filter, see if we match to the filter
					//If it does, set the match boolean to True
					//We need to do this for the Condition Property and the Condition Value filters
					if(ConditionPropertyFilter != "") {
						if(ConditionPropertyOperator == "equals") {
							if(ConditionProperty == ConditionPropertyFilter) ConditionPropMatch = true;
						}
						if(ConditionPropertyOperator == "like") {
							FilterLen = String(ConditionPropertyFilter).length;
							foo = ConditionProperty.slice(0,FilterLen);
							if(foo == ConditionPropertyFilter) ConditionPropMatch = true;
						}
					}

					if(ConditionValueFilter != "") {
						if(ConditionValueOperator == "equals") {
							if(ConditionValue == ConditionValueFilter) ConditionValueMatch = true;
						}
						if(ConditionValueOperator == "like") {
						  	FilterLen = String(ConditionValueFilter).length;
						  	foo = ConditionValue.slice(0,FilterLen);
						  	if(foo == ConditionValueFilter) ConditionValueMatch = true;
						}
					}

					if(ConditionCount > 1) Condition += "<br/><br/>"
				  	Condition += ConditionCount + ". " + rsRuleCond("operand1") + CondOperator + rsRuleCond("operand2");
				}

				rsRuleCond.MoveNext();
			}

			//If requested, Get the Actions for the rule
			if(bSuppressActions == false) {
				TheSQL3 = "select * from table_com_tmplte where escal_act2com_tmplte = " + CTObjid;

				rsAction = retrieveDataFromDB(TheSQL3);
				ActionTitle = "";
				ActionCount = 0;
			}

			//If all of our match booleans are true, then we will display this rule, so set its display property to nothing
			if(StartMatch && StopMatch && ObjectTypeMatch && ConditionPropMatch && ConditionValueMatch) DisplayRow = true;
			if(forceDisplay) DisplayRow = true;
			%>

			<tr <%=(DisplayRow)? "" : "style='display:none;'" %> id="<%=rsCT("objid")%>">
			<td><b><%=rsCT("title")%></b></td>
			<td><%=rsCT("rule_set")%></td>
			<td><%=rsCT("description")%></td>
			<td><%=Active%></td>
			<td><%=ObjectType%></td>
			<td><%=StartEvent%></td>
			<td><%=StopEvent%></td>
			<td><%=Condition%></td>
			<td width="100%">
			<% if(bSuppressActions == false) { %>
			  	<table class="biz-rule-action">
			  		<thead>
			  			<tr>
			  				<th>Action Title</th>
			  				<th>Create Act Log?</th>
			  				<th>Action Type</th>
			  				<th>To Urgency</th>
			  				<th>CC Urgency</th>
			  				<th class="action-message">Message</th>
			  				<th class="action-message">Pager Message</th>
			  				<th>Start Action (d:h:m)</th>
			  				<th>From</th>
			  				<th>Using</th>
			  				<th>Repeat every (d:h:m)</th>
			  				<th>Repeat Duration (d:h:m)</th>
			  			</tr>
					</thead>
					<tbody>
			<% } %>
			<% if(bSuppressActions == false) {
				//Assume this is not an action that should be displayed
				//Assume this is not an action message that should be displayed

				//If we match any of the actions to the action type filter,
				//Then we will display all of the actions for this rule
				GoodAction = false;
				GoodMessage = false;
				GoodPagerMessage = false;

				if(forceDisplay) {
					GoodAction = true;
					GoodMessage = true;
					GoodPagerMessage = true;
				}

				while(rsAction.EOF == false) {
					ActionCount++;
					ActionTitle = ActionCount + ". " + rsAction("title");
					ActionUrgency = rsAction("urgency");

					// Decode the To Urgency
					ToUrgency = "";
					//If the 1 bit is on, then it is To Low
					//If the 2 bit is on, then it is To Medium
					//If the 4 bit is on, then it is To High
					if((ActionUrgency & 1) > 0) ToUrgency = "Low";
					if((ActionUrgency & 2) > 0) ToUrgency = "Medium";
					if((ActionUrgency & 4) > 0) ToUrgency = "High";

					// Decode the CC Urgency
					CCUrgency = "";
					//If the 8 bit is on, then it is CC Low
					//If the 16 bit is on, then it is CC Medium
					//If the 32 bit is on, then it is CC High
					if((ActionUrgency & 8) > 0) CCUrgency = "Low";
					if((ActionUrgency & 16) > 0) CCUrgency = "Medium";
					if((ActionUrgency & 32) > 0) CCUrgency = "High";

					ActionMessage = rsAction("action") + "";
					var pagerMessage 	= rsAction("condition") + "";
					var strPagerMessage = pagerMessage.toUpperCase();
					strActionMessage = ActionMessage.toString().toUpperCase();
					strMessageValueFilter = MessageValueFilter.toUpperCase();
					strPagerMessageValueFilter = PagerMessageValueFilter.toUpperCase();

					ActionObjid = rsAction("objid");
					numActionType = rsAction("type") - 0;
					ActionType = "Message"; //type = 2
					if(numActionType == 3) ActionType = "Command Line";
					if(numActionType == 4) ActionType = "Service Message";

					if(numActionType == ActionTypeFilter) GoodAction = true;

					//If the action type is "All" (actiontypefilter=0), then
					//this is an action that should be displayed
					//if(ActionTypeFilter <= 0 ) GoodAction = true;

					//If we have a message filter value...
					//If the message value matches, then it is a good message

					if(MessageValueFilter != "") {
						if(MessageValueOperator == "starts with") {
							if(strActionMessage.indexOf(strMessageValueFilter) == 0) GoodMessage = true;
						}
						if(MessageValueOperator == "contains") {
							if(strActionMessage.indexOf(strMessageValueFilter) >= 0) GoodMessage = true;
						}
						if(MessageValueOperator == "equals") {
							if(strActionMessage == strMessageValueFilter) GoodMessage = true;
						}
					}

					//If we have a pager message filter value...
					//If the pager message value matches, then it is a good message

					if(PagerMessageValueFilter != "") {
						if(PagerMessageValueOperator == "starts with") {
							if(strPagerMessage.indexOf(strPagerMessageValueFilter) == 0) GoodPagerMessage = true;
						}
						if(PagerMessageValueOperator == "contains") {
							if(strPagerMessage.indexOf(strPagerMessageValueFilter) >= 0) GoodPagerMessage = true;
						}
						if(PagerMessageValueOperator == "equals") {
							if(strPagerMessage == strPagerMessageValueFilter) GoodPagerMessage = true;
						}
					}

					if(PagerMessageValueOperator == "is not empty") {
						PagerMessageValueFilter = "nonEmptyPlaceHolder";
						if(strPagerMessage.length > 0) GoodPagerMessage = true;
					}

					StartTime = FormatSeconds(rsAction("time_til_esc"));
					repeat_period = rsAction("repeat_period");
					repeat_num = rsAction("repeat_num");
					duration_num = repeat_period * repeat_num;
					Duration = FormatSeconds(duration_num);
					Repeat = FormatSeconds(rsAction("repeat_period"));
					TimeType = TranslateTimeType(rsAction("time_type"));
					TimeUnits = TranslateTimeUnits(rsAction("time_units"));
					ActionFlags = rsAction("flags") - 0;
					%>
					 	<tr>
							<td><%=ActionTitle%></td>
							<td>
							<%
							// Figure out of the "Create Act Log on Action" is checked or not
							// If the 1024 bit is on, then its checked;
							rw(((ActionFlags & 1024) > 0)? "Yes" : "No");
							%>
							</td>
							<td><%=ActionType%></td>
							<td><%=ToUrgency%></td>
							<td><%=CCUrgency%></td>
							<td><%=Server.HTMLEncode(ActionMessage)%></td>
							<td><%=Server.HTMLEncode(pagerMessage)%></td>
							<td><%=StartTime%></td>
							<td><%=TimeType%></td>
							<td><%=TimeUnits%></td>
							<td><%=Repeat%></td>
							<td><%=Duration%></td>
					 	</tr>
					<%
					rsAction.MoveNext();
				}

				%>
				<script language="JavaScript">
				<%
				//If we have an action type filter,
				//hide the rule whose actions do not match the action filter

				if(ActionTypeFilter > 0 && GoodAction == false) {
					rw("document.getElementById('" + CTObjid + "').style.display='none'; ");
				}

				//If we have a message filter,
				//hide the rule whose messages do not match the message filter
				if((MessageValueFilter != "") && (GoodMessage == false)) {
					rw("document.getElementById('" + CTObjid + "').style.display='none'; ");
				}

				//If we have a pager message filter,
				//hide the rule whose pager messages do not match the pager message filter
				if((PagerMessageValueFilter != "") && (GoodPagerMessage == false)) {
					rw("document.getElementById('" + CTObjid + "').style.display='none'; ");
				}
				%>
				</script>
				<%
				rsAction.Close();
			}

			if(bSuppressActions == false) {
			%>
				</tbody>
			</table>
			<% } %>
			</td>
			</tr>
			<%
			rsRuleCond.Close();

			rsCT.MoveNext();
		}
		%>
		</table>
		<%	if(rsCT.RecordCount == 0) rw("<h3>No rules found which matched the specified criteria</h3>");
			rsCT.Close();
		%>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var page = "bizrules.asp";
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

   $(".tablesorter").tablesorter();
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
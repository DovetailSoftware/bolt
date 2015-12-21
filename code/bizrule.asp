<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  bizrule.asp
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
<link href="css/bizrules.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Business Rule";
var sPageType = "BizRules";

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
   <div class="row-fluid">
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

      var ruleObjid = Request("objid");

      //Get the Business Rule
      TheSQL = "select * from table_com_tmplte where objid=" + ruleObjid;

      rsCT = retrieveDataFromDBStatic(TheSQL);
      %>

      <h3>Business Rule</h3>
      <h5>Title:&nbsp;<%=rsCT("title")%></h5>
      <h5>Rule Set:&nbsp;<%=rsCT("rule_set")%></h5>
      <h5>Description:&nbsp;<%=rsCT("description")%></h5>

      <table class="tablesorter" style="width:150;">
         <thead>
            <tr>
               <th>Status</th>
               <th>Object</th>
               <th>Start&nbsp;Event</th>
               <th>Cancel&nbsp;Event</th>
               <th>Conditions</th>
               <th>Actions</th>
            </tr>
         </thead>
      <%
      //Loop through the list of rules
      while(rsCT.EOF == false) {

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

         //Loop through the Object Types, Start Events, Stop Events, and Conditions for the rule
         while(rsRuleCond.EOF == false) {
            //Type 1 = Object Types
            //Type 2 = Start Events
            //Type 3 = Cancel Events
            //Type 4 = Conditions

            if(rsRuleCond("type") == 1) {
               strObjectType = String(rsRuleCond("operand1")).toUpperCase();
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
               ConditionPropMatch = true;
               ConditionValueMatch = true;

               if(ConditionCount > 1) Condition += "<br/><br/>"
               Condition += ConditionCount + ". " + rsRuleCond("operand1") + CondOperator + rsRuleCond("operand2");
            }

            rsRuleCond.MoveNext();
         }
         rsRuleCond.Close();

         TheSQL3 = "select * from table_com_tmplte where escal_act2com_tmplte = " + CTObjid;

         rsAction = retrieveDataFromDB(TheSQL3);
         ActionTitle = "";
         ActionCount = 0;
         %>
         <tr class="biz-rule" id="<%=rsCT("objid")%>">
         <td><%=Active%></td>
         <td><%=ObjectType%></td>
         <td><%=StartEvent%></td>
         <td><%=StopEvent%></td>
         <td><%=Condition%></td>
         <td style="display:table-cell">
            <table class="biz-rule-action">
               <thead>
                  <tr>
                     <th>Action&nbsp;Title</th>
                     <th>Create Act Log?</th>
                     <th>Action&nbsp;Type</th>
                     <th>To&nbsp;Urgency</th>
                     <th>CC&nbsp;Urgency</th>
                     <th class="action-message">Message</th>
                     <th class="action-message" nowrap>Pager&nbsp;Message</th>
                     <th>Start&nbsp;Action (d:h:m)</th>
                     <th>From</th>
                     <th>Using</th>
                     <th>Repeat&nbsp;every (d:h:m)</th>
                     <th>Repeat&nbsp;Duration (d:h:m)</th>
                  </tr>
               </thead>
               <tbody>
            <%
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

               ActionObjid = rsAction("objid");
               numActionType = rsAction("type") - 0;
               ActionType = "Message"; //type = 2
               if(numActionType == 3) ActionType = "Command Line";
               if(numActionType == 4) ActionType = "Service Message";

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
            rsAction.Close();
            %>
            </tbody>
         </table>
         </td>
         </tr>
         <%
         rsCT.MoveNext();
      }
      %>
      </table>
      <%
      rsCT.Close();
      %>
      </div>
   </div>
</div>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
   $(".navbar").find(".connected").text("<%=connect_info%>");
   document.title = "Bolt: <%=sPageTitle%>";
});
</script>
</body>
</html>
<%
FSO = null;
udl_file = null;
%>
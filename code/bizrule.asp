<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  BOLT
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  bizrule.asp
//
// Description    :  Business Rule Details
//
// Author         :  Dovetail Software, Inc.
//                   (512) 610-5400
//                   EMAIL: support@dovetailsoftware.com
//                   www.dovetailsoftware.com
//
// Copyright (C) 2001-2017 Dovetail Software, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////

// TO DO:
* separate out the To and CC from the message
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

      if (rsCT.RecordCount == 0){
          rsCT.Close();
          Response.Write('<h4>Business Rule with objid of ' + ruleObjid + ' not found.</h4>')
          Response.End();
       }

      //Assume Active
      //If the 65536 flag is on, then it is Inactive
      Active = "Active";
      if((rsCT("flags") & 65536) > 0) Active = "Inactive";

         //Get the Object Types, Start Events, Stop Events, and Conditions for the rule
         CTObjid = rsCT("objid") - 0;
         TheSQL2 = "select * from table_rule_cond where parentrule2com_tmplte = " + CTObjid;
         if (IsField(287,"x_rank")){TheSQL2+=' order by x_rank'}
         rsRuleCond = retrieveDataFromDB(TheSQL2);

         //Initialize the variables
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
               strStartEvent = String(rsRuleCond("operand1") + '');
               RealStartEvent = TranslateCustomEvent(strStartEvent)
               if (StartEvent != "") StartEvent += "<br/>"; 
               StartEvent += RealStartEvent;
            }

            if(rsRuleCond("type") == 3) {
                strStopEvent = String(rsRuleCond("operand1") + '');
                RealStopEvent = TranslateCustomEvent(strStopEvent)
                if (StopEvent != "") StopEvent += "<br/>";                 
                StopEvent += RealStopEvent; 
             }

            if(rsRuleCond("type") == 4) {
               ConditionCount++;

               //Translate the Operator from an integer to a string
               CondOperator = TranslateRuleOperator(rsRuleCond("operator"));
               ConditionProperty = String(rsRuleCond("operand1")).toUpperCase();
               ConditionValue = String(rsRuleCond("operand2")).toUpperCase();

               if(ConditionCount > 1) Condition += "<br/>"
               Condition += rsRuleCond("operand1") + CondOperator + rsRuleCond("operand2");
            }

            rsRuleCond.MoveNext();
         }
         rsRuleCond.Close();

         TheSQL3 = "select * from table_com_tmplte where escal_act2com_tmplte = " + CTObjid;

         rsAction = retrieveDataFromDB(TheSQL3);
         ActionTitle = "";
         ActionCount = 0;
         %>

<div class="container col-8" id="biz-rule-container">
    <div class="row">
        <div class="col">

             <h3>Business Rule</h3>

            <table class="table table-sm small">
                <thead>
                    <tr><td>Property</td><td>Value</td></tr>
                </thead>
                <tbody>
                    <tr><td>Title</td><td><%=rsCT("title")%></td></tr>
                    <tr><td>Description</td><td><%=rsCT("description")%></td></tr>
                    <tr><td>Rule Set</td><td><%=rsCT("rule_set")%></td></tr>
                    <tr><td>Status</td><td><%=Active%></td></tr>
                    <tr><td>Object Types</td><td><%=ObjectType%></td></tr>                     
                    <tr><td>Start Events</td><td><%=StartEvent%></td></tr>
                    <tr><td>Cancel Events</td><td><%=StopEvent%></td></tr>
                    <tr><td>Conditions</td><td><%=Condition%></td></tr>   
                </tbody>                  
            </table>
        </div>
    </div>

    <div class="row">
        <div class="col">
            <h4>Business Rule Actions (<%=rsAction.RecordCount%>)</h4>
        </div>
    </div>

    <%
    while(rsAction.EOF == false) {

        ActionCount++;
        ActionTitle = rsAction("title");
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
        pagerMessage = rsAction("condition") + "";

        ActionObjid = rsAction("objid");
        numActionType = rsAction("type") - 0;
        ActionType = "Message"; //type = 2
        if(numActionType == 3) ActionType = "Command Line";
        if(numActionType == 4) ActionType = "Service Message";
        if(numActionType == 1001) ActionType = "Carrier Message";

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

    <hr/>
        
    <div class="row">
        <div class="col">        
            <h5>Action <%=ActionCount%>: <%=ActionTitle%> </h5>            
            <table class="table table-sm small">
                <thead>
                    <tr><td>Property</td><td>Value</td></tr>
                </thead>
                <tr><td>Type</td><td><%=ActionType%></td></tr>
                <tr><td>Create Activity Log</td><td><%=((ActionFlags & 1024) > 0)? "Yes" : "No"%></td></tr>
                <tr><td>Start Action</td><td><%=StartTime%> (ddd hh:mm)</td></tr>
                <tr><td>From</td><td><%=TimeType%></td></tr>
                <tr><td>Using</td><td><%=TimeUnits%></td></tr>
                <tr><td>Repeat Every</td><td><%=Repeat%>  (ddd hh:mm)</td></tr>
                <tr><td>Repeat For</td><td><%=Duration%>  (ddd hh:mm)</td></tr>
                <!-- <tr><td>To</td><td></td></tr> -->
                <tr><td>To Urgency</td><td><%=ToUrgency%></td></tr>
                <!-- <tr><td>CC</td><td></td></tr> -->                   
                <tr><td>CC Urgency</td><td><%=CCUrgency%></td></tr>
            </table>            
        </div>

        <div class="col-7">
            <h6>Message</h6> 
            <div class="card bg-faded"><%=FormatMultilineText(Server.HTMLEncode(ActionMessage))%><br/></div>
            <h6>Pager Message</h6> 
            <div class="card bg-faded"><%=FormatMultilineText(Server.HTMLEncode(pagerMessage))%><br/></div>
        </div>

    </div>

    <%
    rsAction.MoveNext();
    }
    rsCT.Close();
    %>
</div>
<div class="container col-8" id="markdown-container">
    <div class="row">
        <div class="col">
                <p><span class="bold">Convert to Markdown</span> - This can be useful when sharing a business rule, such as in a Github issue</p>
                <button onclick="convertToMarkdown()">Convert to Markdown</button>   
                <button id="copy" data-clipboard-target="#markdown-text" title="Copied!" data-trigger="manual" data-toggle="tooltip"  data-placement="bottom">Copy Markdown to Clipboard</button>
                <br/>
                <div id="markdown-text" style="overflow:scroll;"></div>
        </div>
    </div>
</div> 

<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/tether.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script src="https://unpkg.com/turndown/dist/turndown.js"></script>
<script src="https://unpkg.com/turndown-plugin-gfm/dist/turndown-plugin-gfm.js"></script>

<script src="js/clipboard.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
   $("ul.navbar-nav li a[href$='bizrules.asp']").parent().addClass("active");
   $(".navbar").find(".connected").text("<%=connect_info%>");
   document.title = "Bolt: <%=sPageTitle%>";
   $('[data-toggle="tooltip"]').tooltip();
   $('#markdown-text').hide();
});

function convertToMarkdown(){

    var html = document.getElementById('biz-rule-container').outerHTML;
    var turndownService = new TurndownService();

    // Import plugins from turndown-plugin-gfm
    var gfm = turndownPluginGfm.gfm;
    var tables = turndownPluginGfm.tables;

    // Use the plugins
    turndownService.use(gfm);
    turndownService.use(tables);

    //keep BRs, to allow for multi-lines in a table cell, which GFM (github flavored markdown) supports
    turndownService.addRule('breaks', {
      filter: ['br'],
      replacement: function (content) {
        return '<br/>'
      }
    });

    //get rid of DIVs
    turndownService.addRule('divs', {
      filter: ['div'],
      replacement: function (content) {
        return content
      }
    });

    //improve how h5 headings render
    turndownService.addRule('h5', {
      filter: ['h5'],
      replacement: function (content) {
        return '#### ' + content
      }
    });

    var md = turndownService.turndown(html);

    $('#markdown-text').show();
    document.getElementById('markdown-text').innerText=md;
    document.getElementById('markdown-text').scrollIntoView({behavior: "smooth"});
    $('#copy').show();
}

var clipboard = new Clipboard('#copy');

clipboard.on('success', function(e) {
    console.info('Action:', e.action);
    //console.info('Text:', e.text);
    console.info('Trigger:', e.trigger);
    $('#copy').tooltip('show');
    setTimeout(function(){
        $('#copy').tooltip( 'hide' );
        }, 1000);
    e.clearSelection();
});

clipboard.on('error', function(e) {
    console.error('Action:', e.action);
    console.error('Trigger:', e.trigger);
});

</script>
</body>
</html>
<%
FSO = null;
udl_file = null;
%>
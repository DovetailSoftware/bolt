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
.watermark { color:#666;font-size:10px; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%

var objid = Request("objid");
var id = Request("id");

var FormIdentifierForFormViewer = objid;
if(objid < 100000) FormIdentifierForFormViewer = id;

var sPageTitle = "Details for Form " + id;
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span3"></div>
		<div id="headerContainer" class="span6 topMargin">
		<%
			// Go get the Details for this form
			TheSQL = "select * from table_window_db where objid = " + objid;
			rsForms = Server.CreateObject("ADODB.Recordset");
			rsForms.CursorLocation = gCursorLocation;
			rsForms.ActiveConnection = dbConnect;
			rsForms.Source = TheSQL;
			try {
				rsForms.Open();
			} catch(e) {
				displayDBAccessErrorPage(e);
			}

			var ConnString = rsForms.ActiveConnection.ConnectionString + '';
			DisconnectRecordset(rsForms);

			FormTitle = rsForms("title");
			FormVerClarify = rsForms("ver_clarify");
			FormVerCust = rsForms("ver_customer") + EmptyString;

		 	if(FormVerCust == "null" + EmptyString) FormVerCust = EmptyString;
			FormID = rsForms("id") - 0;

			cBottom = rsForms("bottom_c");
			cTop = rsForms("top_c");
			cLeft = rsForms("left_c");
			cRight = rsForms("right_c");

			// Store a Local Copy of the Form Data independent of the record set
			// These get used by the Form Viewer
			var TheFormVerClarify = FormVerClarify + EmptyString;
			var TheFormVerCust = FormVerCust + EmptyString;
			var FormNumber = FormID - 0;
			var BottomPixels = cBottom - 0;
			var TopPixels = cTop - 0;
			var LeftPixels = cLeft - 0;
			var RightPixels = cRight - 0;
			var BufferPixels = 21;
			var WidthPixels = RightPixels - LeftPixels + BufferPixels;
			var HeightPixels = BottomPixels - TopPixels + BufferPixels;

			FormObjid = rsForms("objid");
			FormName = rsForms("dialog_name");
			FormDescription = rsForms("description") + EmptyString;
		 	if(FormDescription == "null" + EmptyString) FormDescription = EmptyString;

		    // Fetch the Tabs
			TheSQL = "select distinct name from table_control_db where control2window_db = " + FormObjid;
			TheSQL+= " and type = 5 and ((name LIKE 'TAB_D%') OR (name LIKE 'TAB_I_%'))";
			rsTabs = retrieveDataFromDB(TheSQL);

			// Init the RC Objid to zero
			var RC_Objid = 0 - 0;
			// Init the Pick a RC variable to False
			var PickRC = 0 - 0 ;

			// Go get the Resource Configs that this form is in
			TheSQL = "select objid,name from table_rc_config where objid in( ";
			TheSQL+= "select objid from table_win_head where dlg_id = " + FormNumber;
			TheSQL+= " and ver_clarify = '" + FormVerClarify + "' and ver_customer ='" + rsForms("ver_customer") + "' )";

			rsRC = retrieveDataFromDBStatic(TheSQL);

			// If this form is only in 1 RC, then this is the RC we'll pass to the Form Viewer
			if(rsRC.RecordCount == 1) {
				RCobjid = rsRC("objid");
				RC_Objid = RCobjid - 0;
			} else {
				// We may need to prompt the user to pick a RC
				// Only need to do this if the form has tabs
				if(!rsTabs.EOF) {
					// There are tabs - make the user pick a RC
					PickRC = 1;
				}
			}

			if(rsRC.RecordCount == 0) {
				RC_Objid = 0 - 0;
				PickRC = 0;
			}

			// Page Header:
			rw("<table>");
			rw("<tr>");
			rw("<td>");
			rw("Form ID: ");
			rw("</td>");
			rw("<td>");
			rw(FormID);
			rw("</td>");
			rw("</tr>");
			rw("<tr>");
			rw("<td>");
			rw("Title: ");
			rw("</td>");
			rw("<td>");
			rw(FormTitle);
			rw("</td>");
			rw("</tr>");
			rw("<tr>");
			rw("<td>");
			rw("Name: ");
			rw("</td>");
			rw("<td>");
			rw(FormName);
			rw("</td>");
			rw("</tr>");
			rw("<tr>");
			rw("<td>");
			rw("Clarify Ver: ");
			rw("</td>");
			rw("<td>");
			rw(FormVerClarify);
			rw("</td>");
			rw("</tr>");
			rw("<tr>");
			rw("<td>");
			rw("User Ver: ");
			rw("</td>");
			rw("<td>");
			rw(FormVerCust);
			rw("</td>");
			rw("</tr>");
			rw("<tr>");
			rw("<td class='padRight'>");
			rw("Description:");
			rw("</td>");
			rw("<td>");
			rw(FormDescription);
			rw("</td>");
			rw("</tr>");
			rw("</table>");

			// Build the Hyperlinks Table:
			rw("<table class='fullWidth topMargin'>");
			rw("<tr>");
			rw("<td>");
			rw("<a href='#cobj'>Contextual Objects</a>");
			rw("</td>");
			rw("<td>");
			rw("<a href='#controls'>Controls</a>");
			rw("</td>");
			rw("<td>");
			rw("<a href='#children'>Child Forms & Tabs</a>");
			rw("</td>");
			rw("<td>");
			rw("<a href='#parent'>Parent Forms</a>");
			rw("</td>");
			rw("</table>");
			%>
		</div>
		<div class="span3"></div>
	</div>

	<div class="row-fluid">
		<div id="cobjContainer" class="span12 topMargin">
		<%	// Cobj Table:
			// Build the Table Header:
			rw("<h4>Contextual Objects:</h4>");
			rw("<table id='cobj' class='tablesorter'>");
			rw("<thead><tr>");
			rw("<th type=Number>");
			rw("Cobj #");
			rw("</th>");
			rw("<th>");
			rw("Name");
			rw("</th>");
			rw("<th>");
			rw("Defined By");
			rw("</th>");
			rw("<th>");
			rw("Type");
			rw("</th>");
			if( GetClarifyVersion() >= CLARIFY_80){
				rw("<th>");
				rw("Caption");
				rw("</th>");
				rw("<th>");
				rw("SubType");
				rw("</th>");
			}
			rw("</tr></thead>");

			// Get the cobjs for this form
			TheSQL = "select * from table_ctx_obj_db where ctx_obj2window_db = " + FormObjid + " order by idx";
			rsCobj = retrieveDataFromDB(TheSQL);

			while(!rsCobj.EOF) {
				CobjIndex = rsCobj("idx");
				CobjName = rsCobj("title");
				CobjDefined = TranslateCobjDefined(rsCobj("behavior"));
				CobjType = TranslateCobjType(rsCobj("type"));
				CobjCaption = EmptyString;
				CobjSubType = EmptyString;

				if( GetClarifyVersion() >= CLARIFY_80){
					CobjCaption = CleanUpString(rsCobj("caption"));
					CobjSubType = rsCobj("subtype")+ EmptyString;
				}

				if(CobjSubType == "null" + EmptyString) CobjSubType = EmptyString;

				// Now that all of our data is cool, build the data part of the table
				rw("<tr>");
				rw("<td>");
				rw(CobjIndex);
				rw("</td>");
				rw("<td>");
				rw(CobjName);
				rw("</td>");
				rw("<td>");
				rw(CobjDefined);
				rw("</td>");
				rw("<td>");
				rw(CobjType);
				rw("</td>");

				if( GetClarifyVersion() >= CLARIFY_80){
					rw("<td>");
					rw(CobjCaption);
					rw("</td>");
					rw("<td>");
					rw(CobjSubType);
					rw("</td>");
				}

				rw("</tr>");
				rsCobj.MoveNext();
			}
			rw("</table>");

			// Get the controls for this form
			TheSQL = "select * from table_control_db where control2window_db = ";
			TheSQL+= FormObjid;
			TheSQL+=" order by id";
			rsControl = retrieveDataFromDB(TheSQL);

			if(rsControl.EOF) {
				rw("This form does not have any controls.");
			} else {

				// Controls Table
				// Build the Table Header:
				rw("<h4 id='controls' class='topMargin'>Controls:</h4>");
				rw("\n<table class='tablesorter'>");
				rw("<thead><tr>");
				rw("<th Type=Number >");
				rw("Ctrl #");
				rw("</th>");
				rw("<th>");
				rw("Type");
				rw("</th>");
				rw("<th>");
				rw("Name");
				rw("</th>");
				rw("<th>");
				rw("Caption");
				rw("</th>");
				rw("<th>");
				rw("Source Cobj");
				rw("</th>");
				rw("<th>");
				rw("Dest. Cobj");
				rw("</th>");
				rw("<th>");
				rw("Button Actions");
				rw("</th>");
				rw("<th>");
				rw("Privileges");
				rw("</th>");
				rw("</tr></thead>");

				while(!rsControl.EOF) {
					CtlID = rsControl("id");
					CtlType = TranslateControlType(rsControl("type"));
					CtlName = rsControl("name") + EmptyString;
					CtlCaption = CleanUpString(rsControl("title"));
					CtlSource = rsControl("tlink_name") + EmptyString;
					CtlDest = rsControl("vlink_name") + EmptyString;
					CtlObjid = rsControl("objid");

					if(CtlCaption == "null" + EmptyString) CtlCaption = EmptyString;
					if(CtlSource == "null" + EmptyString) CtlSource = EmptyString;
					if(CtlDest == "null" + EmptyString) CtlDest = EmptyString;

					// If this is a cmd button, see if there are any button actions
					NumButtonActions = 0;
					NumPrivClasses = 0;
					if(CtlType == "Command Button") {
						NumButtonActions = GetNumButtonActions(CtlObjid);
						NumPrivClasses = GetNumPrivClassesWhereThisButtonIsDisabled(CtlObjid);
					}

					// Now that all of our data is cool, build the data part of the table
					rw("<tr>");
					rw("<td>");
					rw(CtlID);
					rw("</td>");
					rw("<td>");
					rw(CtlType);
					rw("</td>");
					rw("<td>");
					rw(CtlName);
					rw("</td>");
					rw("<td>");
					rw(CtlCaption);
					rw("</td>");
					rw("<td>");
					rw(CtlSource);
					rw("</td>");
					rw("<td>");
					rw(CtlDest);
					rw("</td>");
					// If this is a command button, and there are Button Actions, then add a link to get to the button actions
					rw("<td>");

					if(NumButtonActions > 0){
						TheURL = BuildButtonURL(CtlObjid);
						TheTitle = NumButtonActions + " Button Action";
						if(NumButtonActions > 1) TheTitle+="s";
						rw(BuildHyperLink(TheURL, TheTitle));
					}
					rw("</td>");
					rw("<td>");
					if(NumPrivClasses > 0){
						TheURL = BuildButtonURL(CtlObjid);
						TheTitle = "Disabled for " + NumPrivClasses + " Privilege Class";
						if(NumPrivClasses > 1) TheTitle+="es";
						rw(BuildHyperLink(TheURL, TheTitle));
					}
					else{
						rw("<span class='watermark'>no restrictions</span>");
					}
					rw(EmptyString);
					rw("</td>");
					rw("</tr>");

					rsControl.MoveNext();
				}
				rw("</table>");
			}

			// Get the children (forms) for this form

			// These are the Children Forms
			TheSQL = "select distinct value2 from table_control_db where control2window_db = ";
			TheSQL+= FormObjid;
			TheSQL+= " and type = 4 and value2 <> '' and flags < 16384";
			rsChildren = retrieveDataFromDB(TheSQL);

			// Bookmark & Heading
			rw("<h4 id='children' class='topMargin'>Child Forms & Tabs:</h4>");

			// Save the Parent Objid so we can use it in a hyperlink
			ParentObjid = objid;

			if((rsChildren.EOF) && (rsTabs.EOF)) {
				rw("This form does not have any child forms.");
			} else {
				// Build a Table of Children & Tabs
				rw("\n<table class='tablesorter'>");
				rw("<thead><tr>");
				rw("<th Type=Number>");
				rw("Form ID");
				rw("</th>");
				rw("<th>");
				rw("Type");
				rw("</th>");
				rw("</tr></thead>");

				// Print out the Tabs
				while(!rsTabs.EOF) {
					// Need to extract the Form ID out of the string, which will look like TAB_D_XXX
					TabName = new String(rsTabs("name"));
					TabID = TabName.slice(6,TabName.length);
					TheLink = BuildParentChildFormHyperLink(TabID,ParentObjid);
					rw("<tr>");
					rw("<td>");
					rw(TheLink);
					rw("</td>");
					rw("<td>");
					rw("Tab");
					rw("</td>");
					rw("</tr>");

					rsTabs.MoveNext();
				}

				// Print out the Children
				while(!rsChildren.EOF) {
					rw("<tr>");
					rw("<td>");
					ChildID = rsChildren("value2");
					TheLink = BuildParentChildFormHyperLink(ChildID,ParentObjid);
					rw(TheLink);
					rw("</td>");
					rw("<td>");
					rw("Child");
					rw("</td>");
					rw("</tr>");

					rsChildren.MoveNext();
				}

				rw("</table>");
			}

			rsTabs.Close;
			rsTabs = null;
			rsChildren.Close;
			rsChildren = null;
			rsForms.Close;
			rsForms = null;
			rsCobj.Close;
			rsCobj = null;
			rsControl.Close;
			rsControl = null;
			rsRC.Close;
			rsRC = null;

			// Get all of the Parent Forms for this form
			// These are the Parent Forms IDs for the Tabs
			TheSQL = "select distinct win_id from table_win_control where control_type = 5 and control_name = 'TAB_D_" + FormID + "'";
			rsParentTabs = retrieveDataFromDB(TheSQL);

			// These are the Parent Forms
			TheSQL = "select distinct win_id from table_control_db where type = 4 and value2 = '" + FormID + "' and flags < 16384";
			rsParent = retrieveDataFromDB(TheSQL);

			// Bookmark & Heading
			rw("<h4 id='parent' class='topMargin'>Parent Forms:</h4>");

			// Save the Child Objid so we can use it in a hyperlink
			ChildObjid = objid;

			if((rsParent.EOF) && (rsParentTabs.EOF)) {
				rw("This form does not have any parent forms");
			} else {
				// Build a Table of Children
				rw("\n<table class='tablesorter'>");
				rw("<thead><tr>");
				rw("<th>");
				rw("Form ID");
				rw("</th>");
				rw("<th>");
				rw("Type");
				rw("</th>");
				rw("</tr></thead>");

				// Print out the Parents where this form is a Tab
				while(!rsParentTabs.EOF) {
					ParentTabID = rsParentTabs("win_id");
					TheLink = BuildParentChildFormHyperLink(ParentTabID,ChildObjid);
					rw("<tr>");
					rw("<td>");
					rw(TheLink);
					rw("</td>");
					rw("<td>");
					rw("Tab");
					rw("</td>");
					rw("</tr>");

					rsParentTabs.MoveNext();
				}

				// Print out the Parents
				while(!rsParent.EOF) {
					rw("<tr>");
					rw("<td>");
					ParentID = rsParent("win_id")
					TheLink = BuildParentChildFormHyperLink(ParentID,ChildObjid);
					rw(TheLink);
					rw("</td>");
					rw("<td>");
					rw("Child");
					rw("</td>");
					rw("</tr>");

					rsParent.MoveNext();
				}

				rw("</table>");
			}
			rsParent.Close();
			rsParent = null;
			rsParentTabs.Close();
			rsParentTabs = null;

		%>
		</div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/recent_objects.asp"-->
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/quick_links.asp"-->
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
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter({
		headers: {
			0: { sorter: "digit" }
		}
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
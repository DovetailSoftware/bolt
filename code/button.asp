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
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var objid = Request("objid");
var sPageTitle = "Command Button Details ";
var sPageType = "Forms";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<!--#include file="inc/viewDetails.js"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
	//Go get the Details for button
	TheSQL = "select * from table_control_db where objid = " + objid;
	rsControl = retrieveDataFromDB(TheSQL);

	CtlID = rsControl("id");
	CtlType = TranslateControlType(rsControl("type"));
	CtlName = rsControl("name") + EmptyString;
	CtlCaption = rsControl("title") + EmptyString;
	CtlSource = rsControl("tlink_name") + EmptyString;
	CtlDest = rsControl("vlink_name") + EmptyString;
	CtlObjid = rsControl("objid");
	CtlTitle = rsControl("title");
	WindowObjid = rsControl("control2window_db");

	TheSQL = "select * from table_win_control where objid = " + objid;
	rsWindowControl = retrieveDataFromDB(TheSQL);

	var windowName = rsWindowControl("win_label");
	var windowTitle = rsWindowControl("win_name");
	var windowCustomerVersion = rsWindowControl("customer_ver");
	var windowClarifyVersion = rsWindowControl("clarify_ver");
	var windowId = rsWindowControl("win_id");

	var formURL = BuildFormURL(WindowObjid,windowId);
%>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8 topMargin">
			<h3>Button Details</h3>

			<table class='fullwidth'>
				<tr><td>Button Name:</td><td><%=CtlName%></td></tr>
				<tr><td>Button Label:</td><td><%=CtlTitle%></td></tr>
				<tr><td>Form Name:</td><td><%=windowName%></td></tr>
				<tr><td>Form Title:</td><td><a href="<%=formURL%>"><%=windowTitle%></a></td></tr>
				<tr><td>Form Customer Version:</td><td><%=windowCustomerVersion%></td></tr>
				<tr><td>Form Clarify Version:</td><td><%=windowClarifyVersion%></td></tr>
			</table>

			<hr/>

			<h4>Privileges:</h4>

			<%	//Get the privilege classes that have disabled this button
				TheSQL = "select * from table_privclass where objid in (select priv_objid from table_priv_controls where objid = ";
				TheSQL+= CtlObjid;
				TheSQL+=" ) order by class_name";
				rsPrivClasses = retrieveDataFromDB(TheSQL);
				if (rsPrivClasses.EOF) {
					rw("This button is enabled for all privilege classes.");
				} else {
					rw("<p><a name='privclasses'></a></p>");
					rw("This button is disabled for the following privilege classes:");
					rw("<ul>");
					while (!rsPrivClasses.EOF){
						rw("<li>" + rsPrivClasses("class_name") + "</li>");
						rsPrivClasses.MoveNext();
					}
					rw("</ul>");
				}
			%>

				<hr/>
				<h4>Button Actions:</h4>

			<%	//Get the button actions for this button
				TheSQL = "select * from table_btn_action where btn_action2control_db = ";
				TheSQL+= CtlObjid;
				TheSQL+=" order by execution_order";
				rsBtnAction = retrieveDataFromDB(TheSQL);

				if (rsBtnAction.EOF) {
					rw("There are no Button Actions for this Button.");
				} else {
					rw("<p><a name='actions'></a></p>");

					while (!rsBtnAction.EOF){
						BtnActTitle = rsBtnAction("title") + EmptyString;
						BtnActType = TranslateBtnActionType(rsBtnAction("button_type"));
						BtnActOrder = TranslateBtnActionOrder(rsBtnAction("execution_order"));
						BtnActPlatform = rsBtnAction("platform") + EmptyString;
						BtnActCommand = rsBtnAction("command") + EmptyString;
						BtnActSync = TranslateBtnActionSync(rsBtnAction("is_sync"));
						BtnActObjid = rsBtnAction("objid");

						rw("<blockquote>");
						rw("<h5>Button Action #" + rsBtnAction.AbsolutePosition + "</h5>");
						rw("<BR>");
						rw("<STRONG>Title: </STRONG>" + BtnActTitle);
						rw("<BR>");
						rw("<STRONG>Type: </STRONG>" + BtnActType);
						rw("<BR>");
						rw("<STRONG>Platform: </STRONG>" + BtnActPlatform);
						rw("<BR>");
						rw("<STRONG>Order: </STRONG>" + BtnActOrder);
						rw("<BR>");
						rw("<STRONG>Mode: </STRONG>"  + BtnActSync);
						rw("<BR>");
						rw("<STRONG>Command: </STRONG>" + BtnActCommand);
						rw("<BR>");

						//Go get the Input Args for this action
						TheSQL = "select * from table_btn_argument where btn_argument2in_action = ";
						TheSQL+= BtnActObjid;
						TheSQL+=" order by rank";
						rsArgument = retrieveDataFromDB(TheSQL);

						if (rsArgument.EOF) {
							rw("<B>There are no Input Arguments.</B><BR>");
						} else {
							rw("<B>Input Arguments:</B><BR>");
							while (!rsArgument.EOF)	{
								ArgCobj = rsArgument("cobj_name");
								ArgField = rsArgument("field_name");

								//If the arg is a primitive type, its field will be zero
								//Make it look pretty
								if (ArgField == 0) {
									ArgField = EmptyString;
								} else {
									ArgField = Dot + ArgField;
								}

								rw(ArgCobj + ArgField);
								rw("<BR>");
								rsArgument.MoveNext();
							}
						}
						rsArgument.Close;
						rsArgument = null;

						//Go get the Output Args for this action
						TheSQL = "select * from table_btn_argument where btn_argument2out_action = ";
						TheSQL+= BtnActObjid;
						TheSQL+=" order by rank";
						rsOutArgument = retrieveDataFromDB(TheSQL);

						if (rsOutArgument.EOF){
							rw("<B>There are no Output Arguments.</B><BR>");
						} else {
							rw("<B>Output Arguments:</B><BR>");
							while (!rsOutArgument.EOF) {
								ArgCobj = rsOutArgument("cobj_name");
								ArgField = rsOutArgument("field_name");
								rw(ArgCobj + Dot + ArgField + "<BR>");
								rw("<BR>");
								rsOutArgument.MoveNext();
							}
						}
						rsOutArgument.Close;
						rsOutArgument = null;

						rw("</blockquote>");
						rsBtnAction.MoveNext();

						rw("<br><br>");
					}
				}

				rsBtnAction.Close;
				rsBtnAction = null;

				rsControl.Close;
				rsControl = null;
			%>
		</div>
		<div class="span2"></div>
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
	var page = path.substr(path.lastIndexOf("/")+1);
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
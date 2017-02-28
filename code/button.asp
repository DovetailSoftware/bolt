<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  button.asp
//
// Description    :  Button Detail Information
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
<link rel="Shortcut Icon" href="favicon.ico">
<link href="bs4/css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style4.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
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
<!--#include file="inc/navbar4.inc"-->
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
	">
					<tr><td class="w-25 font-weight-bold pr-2">Button Name:</td><td class="w-75"><%=CtlName%></td></tr>
					<tr><td class="w-25 font-weight-bold">Button Label:</td><td><%=CtlTitle%></td></tr>
					<tr><td class="w-25 font-weight-bold">Form Name:</td><td><%=windowName%></td></tr>
					<tr><td class="w-25 font-weight-bold">Form Title:</td><td><a href="<%=formURL%>"><%=windowTitle%></a></td></tr>
					<tr><td class="w-25 font-weight-bold">Form Customer Version:</td><td><%=windowCustomerVersion%></td></tr>
					<tr><td class="w-25 font-weight-bold">Form Clarify Version:</td><td><%=windowClarifyVersion%></td></tr>
				</table>
			</div>

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
	</div>
	<!--#include file="inc/recent_objects4.asp"-->
	<!--#include file="inc/quick_links4.asp"-->
</div>
</body>
<script type="text/javascript" src="js/jquery/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="bs4/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
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
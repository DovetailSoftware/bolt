<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  privileges.asp
//
// Description    :  Privilege Viewer
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
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="css/privclass.css" rel="stylesheet">
<link href="css/rotateTableCellContent.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Privileges";
var sPageType = "privileges";
%>
<!--#include file="inc/ddonline.inc"-->
<%
function translateModule(x_type) {
	var module = "";
	switch (x_type - 0) {
		case 0: module = "Application";break;
		case 1: module = "General";break;
		case 2: module = "Support";break;
		case 3: module = "Quality";break;
		case 4: module = "Logistics";break;
		case 5: module = "CallCenter";break;
		case 6: module = "Sales";break;
		case 7: module = "Dovetail Admin";break;
	}
	return module;
}

function html(data){
  if (data == null){return '';}
  return Server.HTMLEncode(data);
}

   var TheSQL = "select x_name, class_name, enabled ";
   TheSQL += " from table_x_web_cmd wc cross join table_privclass p";
   TheSQL += " left outer join (select x_web_cmd2privclass, privclass2x_web_cmd,";
   TheSQL += " count(*) as enabled from mtm_privclass10_x_web_cmd0";
   TheSQL += " group by x_web_cmd2privclass,privclass2x_web_cmd) mtm on";
   TheSQL += " mtm.x_web_cmd2privclass = wc.objid and";
   TheSQL += " mtm.privclass2x_web_cmd = p.objid";
   TheSQL += " order by x_type, x_name, class_name";

   rsPrivileges = retrieveDataFromDB(TheSQL);
   var vbRowsArray = new VBArray(rsPrivileges.GetRows());
   var numberOfRows = vbRowsArray.ubound(2) + 1;
   var numberOfColumns = vbRowsArray.ubound(1) + 1;
   var rowsArray = vbRowsArray.toArray();
   rowsArray.numberOfRows = numberOfRows;
   rowsArray.numberOfColumns = numberOfColumns;

	TheSQL = "select objid, class_name from table_privclass";
	rsPrivclass = retrieveDataFromDB(TheSQL);

	TheSQL = "select x_type, x_name from table_x_web_cmd";
	rsWebCommands = retrieveDataFromDB(TheSQL);

var cellValue = "";
var cellClass ="";
var headerColumn = "<td class='header' xtitle='Click to toggle row highlight'>";

%>
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div id="privContainer" class="span4">
			<h3>Privileges</h3>

			<table id="summary">
				<thead>
            	<tr class="section">
   	            <th>Module</th>
	               <th>Function</th>
                  <%
                  var numberOfPrivileges = rsPrivclass.RecordCount;
                  var col = 2;
                  while (!rsPrivclass.EOF){
                 	   rw("<th scope=" + col++ + " class='section verticaltext' title='Click to toggle column highlight'>");
                 	   rw(html(rsPrivclass("class_name")));
                 	   rw("</th>");
                 	   rsPrivclass.MoveNext();
                  }
                  %>
               </tr>
			   </thead>
				<tbody>
               <%
               var i = 0;
               while (!rsWebCommands.EOF) {
                  rw("<tr>");
                  rw(headerColumn);
                  rw(translateModule(rsWebCommands("x_type")));
                  rw("</td>");
                  rw(headerColumn);
                  rw(rsWebCommands("x_name"));
                  rw("</td>");

                  var col = 2;
                  for (var j = 0; j < numberOfPrivileges; j++) {
               		//the privclass_enabled flag (one or zero) is in every 3rd (rowsArray.numberOfColumns) array slot
               		startingIndexForThisWebCommand = (i * numberOfPrivileges * rowsArray.numberOfColumns);
               		index = startingIndexForThisWebCommand + (rowsArray.numberOfColumns * j) + 2;
               		cellValue = "&nbsp;";
               		cellClass = "";
               		if (rowsArray[index] - 0 >= 1 ) {
               			cellValue = "x";
               			cellClass = "privilege_enabled";
               		}

                     rw("<td class='" + cellClass + " col" + col++ + "'>" + cellValue + "</td>");
               	}
                  rw("</tr>");
               	rf();
               	i++;
                  rsWebCommands.MoveNext();
               }
               %>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/rotateTableCellContent.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	//$("#summary").rotateTableCellContent({className: 'verticaltext'});
});
</script>
</html>
<%
rsPrivileges.Close();
rsPrivileges = null;
rsPrivclass.Close();
rsPrivclass = null;
rsWebCommands.Close();
rsWebCommands = null;
%>
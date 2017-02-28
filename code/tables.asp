<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  tables.asp
//
// Description    :  List of Table Details
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
var sPageTitle = "Schema";
var sPageType = "Schema";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar4.inc"-->
<div class="container-fluid">
	<div class="row">
		<div id="homeContainer" class="col-12">
	<%var name_filter = Request("type_name");
		var custom_filter = Request("custom") - 0;
		var minRange = Request("minRange") - 0;
		var maxRange = Request("maxRange") - 0;
		var rangeQuery = false;
		var whereClause = "";
		var orderByClause = " order by " + NAME_FIELD;

		name_filter = SQLFixup(name_filter);
		id_filterstr = Request("type_id");
		id_filter = id_filterstr - 0;

		//Get the list of tables
		TheSQL = "select " + NAME_FIELD + "," + ID_FIELD + "," + FLAGS_FIELD + ",";
		TheSQL+= comment_field ;
		TheSQL+= " from adp_tbl_name_map ";

		//We can search by either table num or by table name
		//Build the correct where clause depending on the data passed in
		if(id_filter >= 0) {
			whereClause+= "where " + ID_FIELD + "= ";
			whereClause+= id_filter;
		} else {
			whereClause+= "where " + NAME_FIELD + " like '";
			whereClause+= name_filter;
			whereClause+= "%'";
		}

		//searching for custom tables/views
		if(custom_filter==1){
			whereClause+=" and ( (type_id >= 2000 and type_id <= 4999) OR (type_id >= 430 and type_id <= 511)) ";
		}

		//search based on a range of IDs
		if(minRange > 0 && maxRange > 0)
		{
			rangeQuery = true;
			whereClause =  "where (type_id >= " + minRange + " and type_id <= " + maxRange + ") ";
			orderByClause = "order by type_id";
		}

		TheSQL+=whereClause;
		TheSQL+=orderByClause;

		rsTables = retrieveDataFromDBStatic(TheSQL);

		//If we only have one, then redirect to the details page for that table/view
		if(rsTables.RecordCount == 1) {
			TableNum = rsTables(ID_FIELD);
			Flags = rsTables(FLAGS_FIELD);
			Flags = Flags & VIEW_FIELD_BIT;

			if(Flags > 0) {
				TheLink = BuildViewURL(TableNum);
			} else {
				TheLink = BuildTableURL(TableNum);
			}
			Response.Redirect(TheLink);
		}

		//If we have none, say so & exit
		if(rsTables.EOF) {
			rw("<h3>");
			if(id_filter >= 0) {
				rw("No matches for table or view id = " + id_filter );
			} else if(rangeQuery==true){
				rw("No matches for tables or views in the given range (" + minRange + "-"+ maxRange + ")");
			} else {
				rw("No matches for table or view name starting with '" + name_filter + "'");
			}
			rw("</h3>");

			rw("</body>");
			rw("</html>");
			rsTables.Close;
			rsTables = null;
			Response.End
		}

		//If we are still here, then build a list of tables
		//Page Header:
		rw("<h3>");
		if(custom_filter==1) {
			rw("Custom Tables/Views");
		} else if(rangeQuery == true) {
			rw("Tables/Views in ID range " + minRange + "-" + maxRange + "");
		} else {
			rw("Tables/Views");
		}
		rw("</h3>");

		//Table Header
		rw("<table class='tablesorter fullWidth top'>");
		rw("<thead><tr>");
		rw("<th>ID</th>");
		rw("<th>Name</th>");
		rw("<th>Comment</th>");
		rw("</tr></thead>");
		rw("<tbody>");

		while (!rsTables.EOF) {
			TableNum = rsTables(ID_FIELD);
			Flags = rsTables(FLAGS_FIELD);
			TableComment = CleanUpString(Server.HTMLEncode((rsTables(comment_field)+"")));

			rw("<tr>");
			rw("<td>");
			rw(TableNum);
			rw("</td>");
			rw("<td>");

			//If the flag 512 bit is on, then this is a view, so build a different link
			//Flags = Flags & 512;
			Flags = Flags & VIEW_FIELD_BIT;
			if(Flags > 0) {
				TheLink = BuildViewHyperLink(TableNum);
			} else {
				TheLink = BuildTableHyperLink(TableNum);
			}

			rw(TheLink);
			rw("</td>");
			rw("<td style='white-space:normal'>");
			rw(TableComment + "&nbsp;");
			rw("</td>");
			rw("</tr>");

			rsTables.MoveNext();
		}

		rw("<tbody>");
		rw("</table>");
		rsTables.Close;
		rsTables = null;
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
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.navbar-nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$(".tablesorter").tablesorter({
	   headers: {
	      // the first column is the "id_number" column
	      0: {
	         // force custom sort for id_number
	         sorter: "id_number"
	      }
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
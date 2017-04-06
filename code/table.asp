<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  table.asp
//
// Description    :  Table Details
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
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">

<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var rsSpecRelID;

var sPageTitle = "Details for Table";
var sPageType = "Schema";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
if(IsView(type_id) == true) Response.Redirect(BuildViewURL(type_id));
var type_name = GetTableName(type_id);
//Update the Recent Cookie Collection
UpdateCookies();

var BC = "Baseline";
type_id = type_id - 0;
if (type_id >= 2000 & type_id <= 4999) BC = "Custom";
if (type_id >= 430 & type_id <= 511) BC = "Custom";

var orderByField = "objid";
function getEncodedSelectTopSql() {
  var select_top_sql = "";
  if(dbType == "MSSQL") {
    select_top_sql = "select top 10 * from table_" + type_name + " order by " + orderByField + " desc";
  } else {
    select_top_sql = "select * from (select * from table_" + type_name + " order by " + orderByField + " desc) where ROWNUM <= 10  order by " + orderByField + " desc";
  }
  return Server.URLEncode(select_top_sql);
}
%>
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row">
		<div class="col-6 offset-3 card bg-faded">
			<table class="table table-sm small mb-1">
				<tr><td class="text-right font-weight-bold pr-2">Table Name:</td><td><%=type_name %></td></tr>
				<tr><td class="text-right font-weight-bold pr-2">Table Number:</td><td><%=type_id %></td></tr>
				<tr><td class="text-right font-weight-bold pr-2">Group:</td><td><%=GetTableGroup(type_name) %></td></tr>
				<tr><td class="text-right font-weight-bold pr-2">Description:</td><td><%=Server.HTMLEncode(GetTableComment(type_name)) %></td></tr>
				<tr><td class="text-right font-weight-bold pr-2">Flags:</td><td><%=GetTableParams(type_id) %></td></tr>
				<tr><td class="text-right font-weight-bold pr-2">Baseline/Custom:</td><td><%=BC %></td></tr>
			</table>
		</div>
		<div class="col-3 pl-4">
			<ul class="list-unstyled pl-3 mb-1">
				<li><a href='#fields'>Fields</a></li>
				<li><a href='#relations'>Relations</a></li>
				<li><a href='#indexes'>Indexes</a></li>
				<li><a href='#views'>Referenced in Views</a></li>
				<% //See if it has storage SQL
					var storageSQL = getStorageSQL();
					if(storageSQL != "") { %>
				<li><a href='#storage'>Storage</a></li>
				<% } %>
			</ul>
			<% var select_sql = "select * from table_" + type_name;
				 var encoded_select_sql = Server.URLEncode(select_sql);
			%>
			<a class="btn btn-primary btn-sm ml-3" href="sql.asp?sql=<%=encoded_select_sql%>&flag=no_query"><%=select_sql%></a>
			<div class="small pl-4 mt-2"><a id="helpLink" href="">Keyboard shortcuts available</a></div>
		</div>
	</div>

	<div class="row-fluid">
		<div id="fieldsContainer" class="">
<%
	//Fields Table:
	//Build the Table header:
	rw("<h5 id='fields'>Fields:</h5>");
	rw("<table class='tablesorter fullWidth'>");
	rw("<thead><tr class='headerRow'>");
	rw("<th>Field Name</th>");
	rw("<th>Common Type</th>");
	rw("<th>Database Type</th>");
	rw("<th type=Number>Generic Field ID</th>");
	rw("<th type=Number>Array Size</th>");
	rw("<th>Default</th>");
	rw("<th>Flags</th>");
	rw("<th>Comment</th>");
	rw("<th>Field Used in Views</th>");
	rw("</tr></thead>");
	rw("<tbody>");

	//Get the fields for this table
  TheSQL = "select * from " + FIELD_TABLE + " where " + ID_FIELD + " = ";
	TheSQL += type_id;
	TheSQL +=" order by field_name";
	rsTables = retrieveDataFromDB(TheSQL);

  var firstField = "";
  var foundObjid = false;

	while (!rsTables.EOF) {
   	FieldName = rsTables("field_name");

   	if(firstField == "") firstField = FieldName;
   	if(FieldName == "objid") foundObjid = true;

	  CmnDataType = rsTables(COMMON_TYPE_FIELD);
	  DBType = rsTables("db_type");
		//Translate the DB Data Type
		DBTypeStr = TranslateDBType(DBType);
	  CmnType = rsTables(COMMON_TYPE_FIELD);
		//Translate the Cmn Data Type
		CmnTypeStr = TranslateCommonType(CmnType);
    SpecFieldID = 0;
    GenFieldID = 0;
	  Comment = Server.HTMLEncode(rsTables(comment_field) + "") + EmptyString;
    if (Comment == "null" + EmptyString) Comment = EmptyString;
   	FldDefault = Server.HTMLEncode(rsTables(DEFAULT_FIELD) + "") + EmptyString;
    if (FldDefault == "null" + EmptyString) FldDefault = EmptyString;
   	ArraySize = rsTables(FIELD_LENGTH_FIELD);
   	TableNum = type_id;
   	Flags = rsTables("flags");
   	strFlags = GetFieldParams(Flags);

		//Special handling for binary array types
		if (strFlags.indexOf(BINARY_STR) >= 0){
		  DBTypeStr="";
		  CmnTypeStr="ARRAY";
		}

		SpecFieldID = rsTables("spec_field_id");
		GenFieldID = rsTables("gen_field_id");
		DecP = rsTables("dec_p");
		DecS = rsTables("dec_s");

   	//If this is a decimal, then build the precision info string
   	if (DBTypeStr == "decimal"){
   		DBTypeStr = DBTypeStr + " (" + DecP + "," + DecS + ")";
   	}

   	//If the GenFieldID = -1, then change it to an empty string
   	if (GenFieldID == "-1") GenFieldID = EmptyString;

   	//If the ArraySize = -1, then change it to an empty string
   	if (ArraySize == "-1") ArraySize = EmptyString;

   	//Now that all of our data is cool, build the data part of the table
   	rw("<tr>");
   	rw("<td>");
   	rw(FieldName);
		rw("</td><td>");
		rw(CmnTypeStr);
		rw("</td><td>");
   	rw(DBTypeStr);
		rw("</td><td>");
		rw(GenFieldID);
		rw("</td><td>");
   	rw(ArraySize);
		rw("</td><td>");
   	rw(FldDefault);
		rw("</td><td>");
   	rw(strFlags);
		rw("</td><td>");
   	rw(Comment);
   	rw("</td>");

   	//Hyperlink for "Where referenced in views"
   	ViewLink = "<a href=views.asp?type_id=";
   	ViewLink += TableNum;
   	ViewLink += "&spec_field_id=";
   	ViewLink += SpecFieldID;
   	ViewLink += "&field_name=";
   	ViewLink += FieldName;
   	ViewLink += ">Search"
   	ViewLink += "</a>";

	  var TheSQL = "select distinct from_obj_type, from_field_id, view_type_id  from adp_view_field_info where from_obj_type = " + TableNum;
		TheSQL += " and from_field_id = " + SpecFieldID;
	  var rsFieldViews = retrieveDataFromDB(TheSQL);
    var viewCount = rsFieldViews.RecordCount;
    var viewSearch = (viewCount > 0)? ViewLink + " (" + viewCount + ")" : "&nbsp;";
    rsFieldViews.Close;
	  rsFieldViews = null;

   	rw("<td>");
   	rw(viewSearch);
   	rw("</td>");
   	rw("</tr>");

   	rsTables.MoveNext();
	}

 	if(!foundObjid) orderByField = FieldName;

	rsTables.Close;
	rsTables = null;
	rw("</tbody>");
	rw("</table>");
  rf();
%>
		</div>
	</div>

	<div class="row-fluid">
		<div id="relationsContainer" class="span12">
<%
	//Build the Relations Table:
	//First, Build the Table header:
	rw("\n<h5 id='relations'>Relations:</h5>");

	rw("\n<table class='tablesorter fullWidth'>");
	rw("<thead><tr class='headerRow'>");
	rw("<th>Relation</th>");
	rw("<th>Type</th>");
	rw("<th>Target Object</th>");
	rw("<th>Inverse Relation</th>");
	rw("<th>Comment</th>");
	rw("<th>Flags</th>");
	rw("<th>MTM Table</th>");
	rw("<th>Used in Views</th>");

	//Check for exclusive relations
  TheSQL = "select count(*) from " + RELATION_TABLE + " where " + ID_FIELD + " = ";
	TheSQL += type_id;
	TheSQL +=" and rel_flags = 1";
	rsRelations = retrieveDataFromDBStatic(TheSQL);
	var hasExclusiveRelationSet = ((rsRelations(0) + 0) > 0);
	rsRelations.Close();

	if(hasExclusiveRelationSet) {
		if (GetClarifyVersion() > CLARIFY_85){
			rw("<th>Set Name</th>");
		}
		rw("<th>Type ID Stored in</th>");
		rw("<th>Objid Stored In</th>");
	}
	rw("</tr>");

	if(hasExclusiveRelationSet) {
		rw("<tr>");
		rw("<td colspan=8>&nbsp;</td>");
		var columns = (GetClarifyVersion() > CLARIFY_85)? 3 : 2;
		rw("<td colspan=" + columns + " class='exclusive'><b>Exclusive Set Relations</b></td>");
		rw("</tr>");
	}
	rw("</thead>");
	rw("<tbody>");

	//Get the relations
   TheSQL = "select * from " + RELATION_TABLE + " where " + ID_FIELD + " = ";
	TheSQL += type_id;
	TheSQL +=" order by " + TARGET_NAME_FIELD;
	rsRelations = retrieveDataFromDB(TheSQL);

	while (!rsRelations.EOF) {
		RelationName = rsRelations(REL_NAME_FIELD);
		RelationType = rsRelations(REL_TYPE_FIELD);
		RelationTypeStr = TranslateRelType(RelationType)
		TargetObject = rsRelations(TARGET_NAME_FIELD);
		TargetObjectID = GetTableNum(TargetObject);

		RelationSpecRelID = rsRelations("spec_rel_id");
		InverseRelation = rsRelations(INVERSE_RELATION_FIELD);

		Flags = rsRelations("flags") + "";
		strFlags = GetRelationParams(Flags);

		Comments = rsRelations(comment_field) + "";
		if (Comments == "null") Comments = "";
		Comments = Server.HTMLEncode(Comments) + EmptyString;

		//Build the MTM Table Name
		if (RelationTypeStr == "MTM")	{
			//First, Get the Spec Rel ID for the Inverse Relation
			TargetSpecRelID = GetSpecRelID(TargetObjectID,InverseRelation);
			//Put the lower table ID first
			if (type_id - 0  < TargetObjectID - 0){
				//We will break the MTM table name into 2 rows for nicer page formatting
				MTMTableName = "mtm_" + type_name + RelationSpecRelID + "_" + "<br>" + TargetObject + TargetSpecRelID;
			} else {
				MTMTableName = "mtm_" + TargetObject + TargetSpecRelID + "_"  + "<br>" + type_name + RelationSpecRelID;
			}
		} else {
			MTMTableName = EmptyString;
		}

		//Make the Target Object be a hyperlink:
		TargetObjectLink = "<a href=table.asp?type_id=";
		TargetObjectLink += TargetObjectID;
		TargetObjectLink += ">" + TargetObject;
		TargetObjectLink += "</a>";

		//Build the data section of the table
		rw("<tr>");
		rw("<td>" + RelationName + "</td>");
		rw("<td>" + RelationTypeStr + "</td>");
		rw("<td>" + TargetObjectLink + "</td>");
		rw("<td>" + InverseRelation + "</td>");
		rw("<td>" + Comments + "</td>");
		rw("<td>" + strFlags + "</td>");
		rw("<td>" + MTMTableName + "</td>");

   	//Hyperlink for "Where relation is in views"
   	ViewLink = "<a href=views.asp?type_id="+ type_id;
   	ViewLink += "&spec_rel_id=" + RelationSpecRelID;
   	ViewLink += "&rel_name=" + RelationName;
   	ViewLink += ">Search</a>";

		var TheSQL = "select distinct obj_type_id, obj_spec_rel_id, view_type_id from adp_view_join_info where obj_type_id = " + type_id;
		TheSQL += " and obj_spec_rel_id = " + RelationSpecRelID;
   	var rsRelationViews = retrieveDataFromDB(TheSQL);
    var viewCount = rsRelationViews.RecordCount;
    var viewSearch = (viewCount > 0)? ViewLink + " (" + viewCount + ")" : "&nbsp;";
    rsRelationViews.Close;
	  rsRelationViews = null;

   	rw("<td>");
   	rw(viewSearch);
   	rw("</td>");

		if(hasExclusiveRelationSet) {
			FocusField = rsRelations(FOCUS_FIELD) + EmptyString;
			RelPhyName = rsRelations(REL_PHY_NAME) + EmptyString;

			//Oracle returns these as null
			if (FocusField == "null" + EmptyString) FocusField = EmptyString;
			if (RelPhyName == "null" + EmptyString) RelPhyName = EmptyString;

			if (GetClarifyVersion() > CLARIFY_85){
				ExclusiveSet = rsRelations("exclusive_set") + EmptyString;
				if (ExclusiveSet == "null" + EmptyString) ExclusiveSet = EmptyString;
			}
			if (GetClarifyVersion() > CLARIFY_85){
				rw("<td>");
				rw(ExclusiveSet);
				rw("</td>");
			}
			rw("<td>");
			rw(FocusField);
			rw("</td>");
			rw("<td>");
			rw(RelPhyName);
			rw("</td>");
		}

		rw("</tr>");
		rsRelations.MoveNext();
	}
	rw("</tbody>");
	rw("</table>");
   rf();

	rsRelations.Close;
	rsRelations = null;
	rsSpecRelID = null;
%>
		</div>
	</div>
	<div class="row-fluid">
		<div id="indexesContainer" class="col-8 offset-2">
<%
	rw("<h5 id='indexes'>Indexes: (Defined in Clarify Schema)</h5>");
	rw("<table class='tablesorter'>");
	rw("<thead><tr>");
	rw("<th>Index Name</th>");
	rw("<th>Fields</th>");
	rw("<th>Flags</th>");
	if(ver > CLARIFY_125) rw("<th>Storage</th>");
	rw("</tr></thead>");
	rw("<tbody>");

	//Go get the data
	TheSQL = "select * from " + INDEX_TABLE + " where " + ID_FIELD + " = ";
	TheSQL += type_id;
	rsIndexes = retrieveDataFromDB(TheSQL);

	while (!rsIndexes.EOF) {
   	IndexName = rsIndexes("index_name");
   	FieldNames = rsIndexes(INDEX_FIELDS);

   	Flags = rsIndexes("flags");
   	strFlags = GetIndexParams(Flags);

   	//Build the data part of the table
   	rw("<tr>");
   	rw("<td>" + IndexName + "</td>");
   	rw("<td>" + FieldNames + "</td>");
   	rw("<td>" + strFlags + "</td>");
		if(ver > CLARIFY_125) {
			//Go get the storage for index
			if (dbType == "MSSQL"){
				TheSQL = "select generic_sql," + TheSQLStrName + " from adp_native_sql where objid = " + rsIndexes("storage_sql_str_id");
			}else{
				TheSQL = "select TO_CHAR(generic_sql) as generic_sql, TO_CHAR(" + TheSQLStrName + ") AS " + TheSQLStrName +"  from adp_native_sql where objid = " + rsIndexes("storage_sql_str_id");
			}

			var rsIndexStorage = retrieveDataFromDB(TheSQL);
			var TheStorageSQL = "&nbsp;";
			if(!rsIndexStorage.EOF) {
				TheStorageSQL = rsIndexStorage(TheSQLStrName) + "";
				if(TheStorageSQL == null || TheStorageSQL == "null" || TheStorageSQL == "") TheStorageSQL = rsIndexStorage("generic_sql") + "";
				if(TheStorageSQL == null || TheStorageSQL == "null") TheStorageSQL = "&nbsp;";
			}
			rsIndexStorage.Close();
			if(TheStorageSQL != "") rw("<td>" + TheStorageSQL + "</td>");
		}
   	rw("</tr>");
   	rsIndexes.MoveNext();
	}
	rsIndexes.Close;
	rsIndexes = null;
	rw("</tbody>");
	rw("</table>");
   rf();

	//Build the (database) Indexes Table:
	rw("<h5 id='db_indexes'>Indexes (Defined in Database):</h5>");
	rw("<table class='tablesorter'>");
	rw("<thead><tr class='headerRow'>");
	rw("<th>Index Name</th>");
	rw("<th>Fields</th>");
	rw("<th>Additional Information</th>");
	rw("</tr></thead>");
	rw("<tbody>");

	if (dbType == "MSSQL"){
		DisplayDatabaseIndexesMSSQL(type_name);
	}else{
		DisplayDatabaseIndexesOracle(type_name);
	}
	rw("</tbody>");
	rw("</table>");
  	rf();
%>
		</div>
	</div>
	<div class="row-fluid">
		<div id="viewsContainer" class="col-8 offset-2">
<%
	//Table for the List of views where this table is joined
	//First, build the Table header
	rw("<h5 id='views'>Referenced in Views:</h5>");
	rw("<table class='tablesorter'>");
	rw("<thead><tr class='headerRow'>");
	rw("<th>View ID</th>");
	rw("<th>View Name</th>");
	rw("<th>Tables</th>");
	rw("</tr></thead>");
	rw("<tbody>");

	//Get the list of views where this table is used
	TheSQL = "select distinct " + VIEW_ID + " from " + VIEW_TABLE + " where " + VIEW_FROM_TBL_ID + " = ";
	TheSQL += type_id;
   TheSQL +=" order by " + VIEW_ID;
	rsViews = retrieveDataFromDB(TheSQL);

	while (!rsViews.EOF)	{
	   ViewNum = rsViews(VIEW_ID);
	   ViewName = GetTableName(ViewNum);

	   //Build the data part of the table
	   rw("<tr>");
	   rw("<td>");
	   rw(ViewNum);
	   rw("</td>");
	   rw("<td>");

	   //The view name should be a hyperlink
	   TheLink = "<a href=view.asp?type_id=";
	   TheLink += ViewNum;
	   TheLink += ">" + ViewName;
	   TheLink += "</a>";
	   rw(TheLink);
	   rw("</td>");

	   rw("<td style='white-space: normal;'>");
		TheSQL = "select " + NAME_FIELD + ", " + ID_FIELD + " from " + TABLE_TABLE + " where " + ID_FIELD +
			" in (select distinct from_obj_type from " + VIEW_TABLE + " where " + VIEW_ID + " = " + ViewNum + ") order by " + NAME_FIELD;
		rsTargets = retrieveDataFromDB(TheSQL);
		var targets = [];
		while(!rsTargets.EOF) {
			linkedTableId = rsTargets(ID_FIELD);
			linkedTableName = rsTargets(NAME_FIELD);

			var TargetObjectLink = "<a href=table.asp?type_id=";
			TargetObjectLink += linkedTableId;
			TargetObjectLink += ">" + linkedTableName;
			TargetObjectLink += "</a>";

		   targets.push(" " + TargetObjectLink);
			rsTargets.MoveNext();
		}
		rw(targets);

	   rw("</td>");
	   rw("</tr>");

	   rsViews.MoveNext();
	}
	rsViews.Close;

	rsViews = null;
	rw("</tbody>");
	rw("</table>");

	//Print the storage
	if(storageSQL != "") {
		rw("<h5 id='storage'>Storage:</h5>");
		rw(storageSQL.replace(/\n/g, "<br>"));
	}
%>
		</div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->
</div>
<!--#include file="inc/help.inc"-->
<input type="button" style="display:none;" onclick="executeSql()" />
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript" src="js/addEvent.js"></script>
<script type="text/javascript">
function showHelp() {
  $("#help tr.object").removeClass("hidden-xs-up");
	$("#help").modal();
	return false;
}

function executeSql() {
	var url = "sql.asp?sql=<%=encoded_select_sql%>";
	window.location.href = url;
}
function executeTopSql() {
	var url = "sql.asp?sql=<%=getEncodedSelectTopSql()%>";
	window.location.href = url;
}
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";
	addEvent(window, "hashchange", function() { scrollBy(0, -50) });

	$("#helpLink").click(showHelp);
	$("body").keydown(function(evt) {
		if(evt.shiftKey && evt.which == 191) showHelp();
		if(evt.altKey && evt.which == 83) executeSql();
		if(evt.altKey && evt.which == 84) executeTopSql();
	});

  $(".tablesorter").tablesorter();
	$(".tablesorter tbody tr").click(function () {
	  $(this).children("td").toggleClass("highlight");
	});
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>
<%
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  ddonline.inc
//
// Description    :  Database utility code
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

var gCursorLocation = adUseClient;

//Globals
var TheSQLStrName = "mssql_sql";
var ver = GetClarifyVersion();

//////////////////////////////////////////////////////////////////////
// Constants
//////////////////////////////////////////////////////////////////////
var EmptyString = "&nbsp;";
var Dot = ".";
var Space = " ";

var USER_DEFINED_FIELD    = 4;
var DIRECT_FIELD          = 16
var BINARY_FIELD          = 32;
var ALLOW_NULL_FIELD      = 128;
var SEARCHABLE_FIELD      = 256;
var CHANGE_FIELD_FIELD    = 512;
var CHANGE_DATE_FIELD     = 1024;
var NO_CLIENT_FIELD       = 2048;
var NO_SERVER_FIELD       = 4096;
var CURRENCY_FIELD        = 8192;
var NON_UNIQUE_FIELD      = 1048576;
var CONSTANT_VALUE_FIELD  = 2097152;
var UNCNC_KEY_FIELD       = 4194304;
var FORCE_CASE_SENS_FIELD = 8388608;
var MULTILINGUAL_FIELD    = 16777216;
var NONBASE_LANG_FIELD    = 33554432;

var USER_DEFINED_STR      = "USER_DEFINED";
var DIRECT_STR            = "DIRECT";
var BINARY_STR            = "BINARY";
var ALLOW_NULL_STR        = "ALLOW_NULL";
var SEARCHABLE_STR        = "SEARCHABLE";
var CHANGE_FIELD_STR      = "CHANGE_FIELD";
var CHANGE_DATE_STR       = "CHANGE_DATE";
var NO_CLIENT_STR         = "DONT_DISTR_TO_CLIENT";
var NO_SERVER_STR         = "DONT_DISTR_TO_SERVER";
var CURRENCY_STR          = "CURRENCY";
var NON_UNIQUE_STR        = "NON_UNIQUE";
var CONSTANT_VALUE_STR    = "CONSTANT_VALUE";
var UNCNC_KEY_STR         = "PART_OF_UNCNC_KEY";
var FORCE_CASE_SENS_STR   = "FORCE_CASE_SENSITIVE";
var MULTILINGUAL_STR      = "MULTILINGUAL";
var NONBASE_LANG_STR      = "NONBASE_LANGUAGE";

var USER_DEFINED_RELATION_FLAG = 131072;
var REQUIRED_RELATION_FLAG     = 262144;
var UNIQUE_INDEX       = 1;

var DELETABLE_FLAG     = 64;
var DELETABLE_STR      = "DELETABLE";

var VIEW_OPTIMIZED_FLAG= 512;
var VIEW_OPTIMIZED_STR = "VIEW_OPTIMIZED";

var CACHEOBJIDS_FLAG   = 524288;
var CACHEOBJIDS_STR    = "CACHEOBJIDS";

var SQL_VIEW_FLAG      = 1048576;
var UNION_VIEW_FLAG    = 16777216;

var ALLOW_FLEX_FLAG    = 2097152;
var ALLOW_FLEX_STR     = "ALLOW_FLEX";

var FLEX_TABLE_FLAG    = 4194304;
var FLEX_TABLE_STR     = "FLEXIBLE_ATTRIBUTE";

var LOGICAL_TABLE_FLAG = 8388608;
var LOGICAL_TABLE_STR  = "LOGICAL_OBJECT";

var APP_OBJID_FLAG     = 67108864;
var APP_OBJID_STR      = "APP_OBJID";

var STR_OBJID_FLAG     = 134217728;
var STR_OBJID_STR      = "STR_OBJID";

var UNIQUE_INDEX_STR   = "UNIQUE";
var REQUIRED_STR       = "REQUIRED";
var COMMA_SPACE        = ", ";
var CLARIFY_70         = 51;
var CLARIFY_80         = 52;
var CLARIFY_85         = 53;
var CLARIFY_90         = 54;
var CLARIFY_10         = 55;
var CLARIFY_11         = 56;
var CLARIFY_112        = 57;
var CLARIFY_115        = 58;
var CLARIFY_12         = 59;
var CLARIFY_125        = 60;
var CLARIFY_131        = 62;
var AMDOCS_75          = 6600;

//////////////////////////////////////////////////////////////////////
// Globals
//////////////////////////////////////////////////////////////////////
var GLOBAL_HEADER_TABLE = ((ver > CLARIFY_125) ? "adp_header" : "adp_db_header");
var TABLE_TABLE = "adp_tbl_name_map";
var FIELD_TABLE = ((ver > CLARIFY_125) ? "adp_field" : "adp_sch_info");
var RELATION_TABLE = ((ver > CLARIFY_125) ? "adp_relation" : "adp_sch_rel_info");
var INDEX_TABLE = ((ver > CLARIFY_125) ? "adp_index" : "adp_sch_index");
var VIEW_TABLE = ((ver > CLARIFY_125) ? "adp_view_field" : "adp_view_field_info");
var JOIN_TABLE = ((ver > CLARIFY_125) ? "adp_join" : "adp_view_join_info");
var comment_field = "comments";
var ID_FIELD = "type_id";
var NAME_FIELD = "type_name";
var FLAGS_FIELD = "type_flags"
var VIEW_FIELD_BIT = 512;
var GROUP_FIELD = "obj_group"
var COMMON_TYPE_FIELD = "cmn_type";
var DEFAULT_FIELD = "fld_default";
var TABLE_RANK = "spec_field_id";
var FIELD_LENGTH_FIELD = "array_size";
var TARGET_NAME_FIELD = "target_name";
var REL_NAME_FIELD = "rel_name";
var REL_TYPE_FIELD = "rel_type";
var INVERSE_RELATION_FIELD = "inv_rel_name";
var FOCUS_FIELD = "focus_fldname";
var REL_PHY_NAME = "rel_phy_name";
var INDEX_FIELDS = "field_names";
var VIEW_ID = "view_type_id";
var VIEW_FROM_TBL_ID = "from_obj_type";
var VIEW_RANK = "view_spec_field_id";
var JOIN_FROM_TBL_ID = "obj_type_id";
var JOIN_PRIM_ALIAS = "palias";
var JOIN_SEC_ALIAS = "falias";

//Assume MSSQL
var dbType = "MSSQL";

// Figure out the name of the comment field
// Don't do this on the Admin Pages
// This allows access to the admin page even if the UDL file is bad or incomplete
var database_name = "";
var database_server = "";

if(sPageType != "Admin") {
	//Assume it is "comments"
	var comment_field = "comment";

	TheSQL = "select * from adp_sch_info where type_id = 0";
	rsFieldName = retrieveDataFromDB(TheSQL);
	TheFields = rsFieldName.Fields;

	var fldCount = rsFieldName.Fields.Count
	for(count=1;count <= fldCount;count++) {
		if(rsFieldName.Fields(count - 1).Name.toLowerCase() + "" == "comments") comment_field = "comments";
	}

	rsFieldName.Close();
	rsFieldName = null;

	//Figure out what kind of database this is
	//Oracle DBs have s_ fields

	TheSQL = "select s_title from table_case where objid = 0";
	rsFieldName = Server.CreateObject("ADODB.Recordset");
	rsFieldName.ActiveConnection = dbConnect;
	rsFieldName.CursorLocation = gCursorLocation;
	rsFieldName.Source = TheSQL;
	database_name = rsFieldName.ActiveConnection.DefaultDatabase;
	database_server = rsFieldName.ActiveConnection.Properties("Data Source") + "";

	try {
		rsFieldName.Open();
		dbType = "Oracle";
		TheSQLStrName = "oracle_sql";
	} catch (e) {}

	try {
		DisconnectRecordset(rsFieldName);
		rsFieldName.Close();
	} catch (e) {}

	rsFieldName = null;

	if(database_server == ".") database_server = "localhost";
	var connect_info = "Connected to: " + database_server + " - " + database_name;
	if(dbType == "Oracle") connect_info = "Connected to: " + database_server;
	if(database_server == "undefined" || database_server == "" ) connect_info = "&nbsp;";
}

//////////////////////////////////////////////////////////////////////
//displayDBAccessErrorPage - show db engine error response
//////////////////////////////////////////////////////////////////////
function displayDBAccessErrorPage(e,s) {
	Response.Clear();
	rw('<html>\n');
	rw('<head>\n');
	rw('<link href="css/bootstrap.css" rel="stylesheet">\n');
	rw('<link href="css/bootstrap-responsive.css" rel="stylesheet">\n');
	rw('<title>Error</title>\n');
	rw('</head>\n');
	rw('<body onload="if(window.history.length==0) {document.getElementById(\'backLink\').style.visibility=\'hidden\';}">\n');
	rw('<!--#include file="inc/navbar.inc"-->\n');
	rw('<div class="container-fluid">\n');
	rw('<div class="row-fluid topMargin">\n');
	rw('<div class="span2"></div>\n');
	rw('<div id="headerContainer" class="span8">\n');
	rw('<A HREF="http://www.dovetailsoftware.com"><img src="img/dovetail.png" alt="Dovetail Software"></a>\n');
	rw("<h3>Database Error</h3>\n");
	rw('<p>' + e.description + '</p>\n');
	rw('<p>' + s + '</p>\n');
	rw('<p><a id="backLink" href="javascript:window.history.back()">Back</a></p>');
	rw('<p><a href="javascript:window.location.reload()">Refresh</a></p>\n');
	rw('</div></div></div>\n');
	rw('<script type="text/javascript">');
	rw("if(window.document.title != 'Error') {document.getElementById('logo').style.display='none';document.getElementById('backLink').style.display='none';}");
	rw('</script>');
	rw('</body>\n');
	rw('</html>');
	Response.End();
}

//////////////////////////////////////////////////////////////////////
//retrieveDataFromDB - connect to db, execute SQL, return recordset
//////////////////////////////////////////////////////////////////////
function retrieveDataFromDB(TheSQL) {
	try {
		var aRecordSet = Server.CreateObject("ADODB.Recordset");
		aRecordSet.ActiveConnection = dbConnect;
		aRecordSet.CursorLocation = gCursorLocation;
		aRecordSet.Source = TheSQL;
		aRecordSet.Open();
		DisconnectRecordset(aRecordSet);

		return aRecordSet;
		// don't forget to Close() the recordset after use !

	} catch(e) {
		displayDBAccessErrorPage(e,TheSQL);
	}
}

//////////////////////////////////////////////////////////////////////
//retrieveDataFromDBStatic - connect to db, execute SQL, return recordset
//////////////////////////////////////////////////////////////////////
function retrieveDataFromDBStatic(TheSQL) {
	try {
		var aRecordSet = Server.CreateObject("ADODB.Recordset");
		//Note that we're using a static cursor here as we need to check the rowcount
		aRecordSet.CursorType = adOpenStatic;
		aRecordSet.ActiveConnection = dbConnect;
		aRecordSet.CursorLocation = gCursorLocation;
		aRecordSet.Source = TheSQL;
		aRecordSet.Open();
		DisconnectRecordset(aRecordSet);

		return aRecordSet;
	// don't forget to Close() the recordset after use !

	} catch(e) {
		displayDBAccessErrorPage(e,TheSQL);
	}
}

//////////////////////////////////////////////////////////////////////
//GetTableName - Given a Table ID, return its table name
//////////////////////////////////////////////////////////////////////
function GetTableName(TableNum) {
	//Get the Table Name
	TheSQL = "select type_name from adp_tbl_name_map where type_id = " + TableNum;
	rsTableName = retrieveDataFromDBStatic(TheSQL);

	TableName = rsTableName(0) + "";
	rsTableName.Close();

	return TableName;
}

//////////////////////////////////////////////////////////////////////
//Given a Table Name, return its table ID
//////////////////////////////////////////////////////////////////////
function GetTableNum(TableName) {
	TableNum = -1;
	//Get the Table Num
	TheSQL = "select type_id from adp_tbl_name_map where type_name = '" + TableName + "'";
	rsGetTableName = retrieveDataFromDBStatic(TheSQL);

	if(rsGetTableName.EOF || rsGetTableName.BOF) {
		TableNum = -1;
	} else {
		TableNum = rsGetTableName(0) - 0;
	}

	rsGetTableName.Close();

	return TableNum;
}

//////////////////////////////////////////////////////////////////////
//Translate Relation Types from an integer to the corresponding string
//////////////////////////////////////////////////////////////////////
function TranslateRelType(RelType) {
	switch (RelType + 0) {
		case 1:
			RelString = "OTM";
			break;
		case 2:
			RelString = "MTO";
			break;
		case 3:
			RelString = "OTOP";
			break;
		case 4:
			RelString = "OTOF";
			break;
		case 5:
			RelString = "MTM";
			break;
		case 10:
			RelString = "MTO";
			break;
		case 11:
			RelString = "OTOP";
			break;
		default:
			RelString = "&nbsp";
			break;
	}
	return RelString;
}

//////////////////////////////////////////////////////////////////////
//Translate Common Data Types from an integer to a string
//////////////////////////////////////////////////////////////////////
function TranslateCommonType(CommonType) {
	switch (CommonType + 0) {
		case 512:
			CommonString = "LONG";
			break;
		case 609:
			CommonString = "CLK_TIME";
			break;
		case 516:
			CommonString = "CHAR";
			break;
		case 514:
			CommonString = "FLOAT";
			break;
		case 766:
			CommonString = "DECIMAL";
			break;
		default:
			CommonString = "&nbsp";
			break;
	}
	return CommonString;
}

//////////////////////////////////////////////////////////////////////
//Translate Database Data Types from an integer to a string
//////////////////////////////////////////////////////////////////////
function TranslateDBType(DBType) {
	switch (DBType + 0) {
		case 0:
			DBString = "int";
			break;
		case 1:
			DBString = "smallint";
			break;
		case 2:
			DBString = "tinyint";
			break;
		case 3:
			DBString = "real";
			break;
		case 4:
			DBString = "double";
			break;
		case 6:
			DBString = "char";
			break;
		case 7:
			DBString = "varchar";
			break;
		case 8:
			//As of Clarify 12 on Oracle, clobs are used instead of text
			var ver = GetClarifyVersion();
			if((dbType == "Oracle") && (ver >= CLARIFY_12) ) {
				DBString = "clob";
			} else {
				DBString = "text";
			}
			break;
		case 9:
			DBString = "datetime";
			break;
		case 11:
			DBString = "decimal";
			break;
		default:
			DBString = "&nbsp";
			break;
	}
	return DBString;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Table
//////////////////////////////////////////////////////////////////////
function BuildTableURL(TableNum) {
	TheURL = "table.asp?type_id=";
	TheURL += TableNum;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a View
//////////////////////////////////////////////////////////////////////
function BuildViewURL(TableNum) {
	TheURL = "view.asp?type_id=";
	TheURL += TableNum;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a SQL View
//////////////////////////////////////////////////////////////////////
function BuildSQLViewURL(TableNum) {
	TheURL = "sql_view.asp?type_id=";
	TheURL += TableNum;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Union View
//////////////////////////////////////////////////////////////////////
function BuildUnionViewURL(TableNum) {
	TheURL = "union_view.asp?type_id=";
	TheURL += TableNum;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Button Action
//////////////////////////////////////////////////////////////////////
function BuildButtonURL(Objid) {
	TheURL = "button.asp?objid=";
	TheURL += Objid;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Child Form
//////////////////////////////////////////////////////////////////////
function BuildChildFormURL(FormID,ParentObjid) {
	TheURL = "childform.asp?id=";
	TheURL += FormID;
	TheURL += "&parent_objid=";
	TheURL += ParentObjid;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a HyperLink for a Child Form
//////////////////////////////////////////////////////////////////////
function BuildChildFormHyperLink(FormID,ParentObjid) {
	return BuildHyperLink(BuildChildFormURL(FormID,ParentObjid),FormID);
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Parent/Child Form
//////////////////////////////////////////////////////////////////////
function BuildParentChildFormURL(FormID,ParentObjid) {
	TheURL = "parentchildform.asp?id=";
	TheURL += FormID;
	TheURL += "&parent_objid=";
	TheURL += ParentObjid;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a Hyperlink for a parent/child form
//////////////////////////////////////////////////////////////////////
function BuildParentChildFormHyperLink(FormID,ParentObjid) {
	return BuildHyperLink(BuildParentChildFormURL(FormID,ParentObjid),FormID);
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a Parent Form
//////////////////////////////////////////////////////////////////////
function BuildParentFormURL(FormID,ChildObjid) {
	TheURL = "childform.asp?id=";
	TheURL += FormID;
	TheURL += "&parent_objid=";
	TheURL += ChildObjid;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// Build a HyperLink for a Parent Form
//////////////////////////////////////////////////////////////////////
function BuildParentFormHyperLink(FormID,ChildObjid) {
	return BuildHyperLink(BuildParentFormURL(FormID,ChildObjid),FormID);
}

//////////////////////////////////////////////////////////////////////
// Build a Hyperlink from a URL
//////////////////////////////////////////////////////////////////////
function BuildHyperLink(URL,Title,Target) {
	HyperLink = "<a href= ";
	HyperLink+= URL;

	if(Target == "top") HyperLink += " target=_top ";

	HyperLink += ">" + Title;
	HyperLink += "</a>";
	return HyperLink;
}

//////////////////////////////////////////////////////////////////////
// Build a Hyperlink for a View
//////////////////////////////////////////////////////////////////////
function BuildViewHyperLink(TableNum, Target) {
	TableName = GetTableName(TableNum);
	TheURL = BuildViewURL(TableNum, TableName);
	TheHyperLink = BuildHyperLink(TheURL, TableName, Target);
	return TheHyperLink;
}

//////////////////////////////////////////////////////////////////////
// Build a Hyperlink for a Table
//////////////////////////////////////////////////////////////////////
function BuildTableHyperLink(TableNum, Target) {
	TableName = GetTableName(TableNum);
	return BuildHyperLink(BuildTableURL(TableNum), TableName, Target);
}

//////////////////////////////////////////////////////////////////////
// Determine if a type id is a view or not
//////////////////////////////////////////////////////////////////////
function IsView(TypeID) {
	//Get the Table/View flags
	TheSQL = "select type_flags from adp_tbl_name_map where type_id = " + TypeID;
	rs = retrieveDataFromDB(TheSQL);
	Flags = 0;
	try {
		Flags = rs(0) - 0;
	} catch (e) { }

	//If the flag 512 bit is on, then this is a view
	Flags = Flags & VIEW_FIELD_BIT;

	rs.Close();

	return (Flags > 0);
}

//////////////////////////////////////////////////////////////////////
// Build a Hyperlink for a Table or for a view
//////////////////////////////////////////////////////////////////////
function MakeTableOrViewHyperLink(TableID) {
	//Need to find out of this is a view or a table
	if(IsView(TableID))
		return BuildViewHyperLink(TableID);
	else
		return BuildTableHyperLink(TableID);
}

//////////////////////////////////////////////////////////////////////
// Return the Field Name
//////////////////////////////////////////////////////////////////////
function GetFieldName(TableNum, SpecFieldID) {
	TheSQL = "select * from adp_sch_info where type_id = " + TableNum;
	TheSQL+= " and spec_field_id = " + SpecFieldID;
	TheSQL+= " and flags != 48 "; //ignore binary array fields
	rsFieldName = retrieveDataFromDB(TheSQL);
	FieldName = rsFieldName("field_name") + "";
	rsFieldName.Close();

	return FieldName;
}

//////////////////////////////////////////////////////////////////////
// Return the comment for a table
//////////////////////////////////////////////////////////////////////
function GetTableComment(TableName) {
	TheSQL = "select ";
	TheSQL += comment_field;
	TheSQL += " from " + TABLE_TABLE;
	TheSQL+= " where " + NAME_FIELD + "= '";
	TheSQL+= TableName;
	TheSQL+= "'";
	rsTable = retrieveDataFromDB(TheSQL);
	Comment = rsTable(comment_field) + "";
	rsTable.Close();

	return Comment;
}

//////////////////////////////////////////////////////////////////////
// Return the Group for a table
//////////////////////////////////////////////////////////////////////
function GetTableGroup(TableName) {
	TheSQL = "select " + GROUP_FIELD + " from " + TABLE_TABLE;
	TheSQL+= " where " + NAME_FIELD + " = '";
	TheSQL+= TableName;
	TheSQL+= "'";
	rsTable = retrieveDataFromDB(TheSQL);
	Group = rsTable(GROUP_FIELD) + "";
	rsTable.Close();
	return Group;
}

//////////////////////////////////////////////////////////////////////
// Build a URL for a form
//////////////////////////////////////////////////////////////////////
function BuildFormURL(Objid,Id) {
	TheURL = "form.asp?objid=";
	TheURL += Objid;
	TheURL += "&id=";
	TheURL += Id;
	return TheURL;
}

//////////////////////////////////////////////////////////////////////
// See if a Cobj is Clarify or User Defined
//////////////////////////////////////////////////////////////////////
function TranslateCobjDefined(behavior) {
	switch (behavior - 0) {
		case 0:
			DefinedString = "Clarify";
			break;
		case 16:
			DefinedString = "User";
			break;
		default:
			DefinedString = "&nbsp";
			break;
	}
	return DefinedString;
}

//////////////////////////////////////////////////////////////////////
// Translate the Cobj Type into a String
//////////////////////////////////////////////////////////////////////
function TranslateCobjType(iType) {
	switch (iType - 0) {
		//Primitive Types
		case 512:
			sType = "Long";
			break;
		case 514:
			sType = "Single";
			break;
		case 518:
			sType = "List";
			break;
		case 516:
			sType = "String";
			break;
		case 609:
			sType = "Date";
			break;
		case 636:
			sType = "Finale Found Pointer";
			break;
		case 5179:
			//This is an eLink only data type
			sType = "&nbsp";
			break;
		case 633:
			sType = "Ufct Reqd Pointer";
			break;
		case 610:
			sType = "elapsed time";
			break;
		case 734:
			sType = "Radiobutton group info for DGN";
			break;
		case 719:
			sType = "Field Array Column Info";
			break;
		case 728:
			sType = "Context. Object Info";
			break;
		//If we're still here, It must be a Database Type
		//Since this is a DB Table, it will be a hyperlink
		default:
			sType = MakeTableOrViewHyperLink(iType, GetTableName(iType));
			break;
	}

	return sType;
}

//////////////////////////////////////////////////////////////////////
// Translate the Control Type to a String
//////////////////////////////////////////////////////////////////////
function TranslateControlType(iType) {
	switch (iType - 0) {
	case 0:
		sType = "Static Text";
		break;
	case 2:
		sType = "Bitmap";
		break;
	case 3:
		sType = "Multi-Line Edit";
		break;
	case 4:
		sType = "Command Button";
		break;
	case 5:
		sType = "Option Button/Tab";
		break;
	case 6:
		sType = "Check Box";
		break;
	case 7:
		sType = "Dropdown List Box";
		break;
	case 9:
		sType = "List Box";
		break;
	case 11:
		sType = "Dropdown Combo Box";
		break;
	case 13:
		sType = "Grid";
		break;
	case 14:
		sType = "Group Box";
		break;
	case 18:
		sType = "Select CBX";
		break;
	case 19:
		sType = "Line";
		break;
	case 20:
		sType = "Active X Control";
		break;
	case 21:
		sType = "Graph";
		break;
	case 22:
		sType = "UpDown";
		break;
	case 23:
		sType = "Progress Bar";
		break;
	case 24:
		sType = "Slider";
		break;
	case 25:
		sType = "Animation";
		break;
	case 26:
		sType = "Tree View";
		break;
	default:
		sType = "&nbsp";
		break;
	}
	return sType;
}

//////////////////////////////////////////////////////////////////////
// Return the Number of Button Actions for a Command Button
//////////////////////////////////////////////////////////////////////
function GetNumButtonActions(CtlObjid) {
	//Get the Number of Button Actions
	TheSQL = "select objid from table_btn_action where btn_action2control_db = " + CtlObjid;
	rs = retrieveDataFromDBStatic(TheSQL);
	NumButtonActions = rs.RecordCount - 0;
	rs.Close();
	return NumButtonActions;
}

//////////////////////////////////////////////////////////////////////
// Return the Number of Priv Classes Where This Button Is Disabled
//////////////////////////////////////////////////////////////////////
function GetNumPrivClassesWhereThisButtonIsDisabled(CtlObjid) {
	//Get the Number of Button Actions
	TheSQL = "select objid from table_priv_controls where objid  = " + CtlObjid;
	rs = retrieveDataFromDBStatic(TheSQL);
	NumPrivClasses = rs.RecordCount - 0;
	rs.Close();
	return NumPrivClasses;
}


//////////////////////////////////////////////////////////////////////
// Translate the Button Action Type
//////////////////////////////////////////////////////////////////////
function TranslateBtnActionType(iType) {
	switch (iType - 0) {
		case 1:
			RelString = "Command Line";
			break;
		case 2:
			RelString = "Stored Procedure";
			break;
		default:
			RelString = "&nbsp";
			break;
	}
	return RelString;
}

//////////////////////////////////////////////////////////////////////
// Translate the Button Action Order to a String
//////////////////////////////////////////////////////////////////////
function TranslateBtnActionOrder(iOrder) {
	switch (iOrder - 0) {
		case -1:
			RelString = "Before";
			break;
		case 1:
			RelString = "After";
			break;
		default:
			RelString = "&nbsp";
			break;
	}
	return RelString;
}

//////////////////////////////////////////////////////////////////////
// Translate the Button Action Sync Behavior to a string
//////////////////////////////////////////////////////////////////////
function TranslateBtnActionSync(iSync) {
	switch (iSync - 0) {
		case 0:
			RelString = "Synchronous";
			break;
		case 1:
			RelString = "Asynchronous";
			break;
		default:
			RelString = "&nbsp";
			break;
	}
	return RelString;
}

//////////////////////////////////////////////////////////////////////
// Get the Objid for a particular child form in a RC
//////////////////////////////////////////////////////////////////////
function GetChildFormObjid(ChildID,RCObjid) {
	TheSQL = "select table_window_db.objid from mtm_window_db4_rc_config1, table_rc_config , table_window_db";
	TheSQL += " where table_window_db.objid = mtm_window_db4_rc_config1.window_db2rc_config";
	TheSQL += " AND mtm_window_db4_rc_config1.rc_config2window_db = table_rc_config.objid";
	TheSQL += " and table_rc_config.objid  = ";
	TheSQL += RCObjid;
	TheSQL += " and table_window_db.id = ";
	TheSQL += ChildID;
	rsChild = retrieveDataFromDB(TheSQL);

	if(rsChild.EOF) {
		ChildObjid = 0;
	} else {
		ChildObjid = rsChild("objid") - 0;
	}
	rsChild.Close();

	return ChildObjid;
}

//////////////////////////////////////////////////////////////////////
//Given a Resource Config Objid, Return its Name
//////////////////////////////////////////////////////////////////////
function GetRCName(RCObjid) {
	//Get the Table Name
	TheSQL = "select name from table_rc_config where objid = " + RCObjid;
	rsRCName = retrieveDataFromDB(TheSQL);

	RCName = rsRCName("name") + "";
	rsRCName.Close();
	rsRCName = null;

	return RCName;
}

//////////////////////////////////////////////////////////////////////
//return the string parameters parsed out of a field's flags
//////////////////////////////////////////////////////////////////////
function GetFieldParams(flags) {
	var sp_str = "";
	if((flags & CHANGE_DATE_FIELD) > 0) {
		sp_str = CHANGE_DATE_STR;
	}
	if((flags & USER_DEFINED_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += USER_DEFINED_STR;
	}
	if((flags & DIRECT_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += DIRECT_STR;
	}
	if((flags & BINARY_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += BINARY_STR;
	}
	if((flags & ALLOW_NULL_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += ALLOW_NULL_STR;
	}
	if((flags & SEARCHABLE_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += SEARCHABLE_STR;
	}
	if((flags & CHANGE_FIELD_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += CHANGE_FIELD_STR;
	}
	if((flags & NO_CLIENT_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += NO_CLIENT_STR;
	}
	if((flags & NO_SERVER_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += NO_SERVER_STR;
	}
	if((flags & CURRENCY_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += CURRENCY_STR;
	}
	if((flags & NON_UNIQUE_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += NON_UNIQUE_STR;
	}
	if((flags & CONSTANT_VALUE_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += CONSTANT_VALUE_STR;
	}
	if((flags & UNCNC_KEY_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += UNCNC_KEY_STR;
	}
	if((flags & FORCE_CASE_SENS_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += FORCE_CASE_SENS_STR;
	}
	if((flags & MULTILINGUAL_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += MULTILINGUAL_STR;
	}
	if((flags & NONBASE_LANG_FIELD) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += NONBASE_LANG_STR;
	}
	sp_str += EmptyString;

	return sp_str;
}

//////////////////////////////////////////////////////////////////////
//return the string parameters parsed out of a index's flags
//////////////////////////////////////////////////////////////////////
function GetIndexParams(flags) {
	var sp_str = "";
	if((flags & UNIQUE_INDEX) > 0) {
		sp_str = UNIQUE_INDEX_STR;
	}
	sp_str += EmptyString;

	return sp_str;
}

//////////////////////////////////////////////////////////////////////
//return the string parameters parsed out of a relation's flags
//////////////////////////////////////////////////////////////////////
function GetRelationParams(flags) {
	var sp_str = "";
	if((flags & USER_DEFINED_RELATION_FLAG) > 0) {
		sp_str = USER_DEFINED_STR;
	}
	if((flags & REQUIRED_RELATION_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str += REQUIRED_STR;
	}
	sp_str += EmptyString;

	return sp_str;
}

//////////////////////////////////////////////////////////////////////
// Return the Database Name
//////////////////////////////////////////////////////////////////////
function GetDBName() {
	rsFieldName = Server.CreateObject("ADODB.Recordset");
	rsFieldName.ActiveConnection = dbConnect;
	DBName = rsFieldName.ActiveConnection.DefaultDatabase;

	rsFieldName = null;

	return DBName;
}

//////////////////////////////////////////////////////////////////////
// Return the Clarify Version (Schema Rev)
//////////////////////////////////////////////////////////////////////
function GetClarifyVersion() {
	var TheSQL = "select schema_rev from adp_db_header";
	var rsSchema = retrieveDataFromDB(TheSQL);

	if(rsSchema) {
		SchemaRev = rsSchema(0) - 0;
		rsSchema.Close();

		return SchemaRev;
	}
}

//////////////////////////////////////////////////////////////////////
// Return the Clarify Version (Release Number)
//////////////////////////////////////////////////////////////////////
function GetClarifyRelease() {
  var SchemaRev = GetClarifyVersion();
  switch (SchemaRev + "") {
		case CLARIFY_70 + "":
			return "7.x"
			break;
		case CLARIFY_80 + "":
			return "8.x"
			break;
		case CLARIFY_85 + "":
			return "8.5"
			break;
		case CLARIFY_90 + "":
			return "9.x"
			break;
		case CLARIFY_10 + "":
			return "10.x"
			break;
		case CLARIFY_11 + "":
			return "11.x"
			break;
		case CLARIFY_112 + "":
			return "11.2"
			break;
		case CLARIFY_115 + "":
			return "11.5"
			break;
		case CLARIFY_12 + "":
			return "12.0"
			break;
		case CLARIFY_125 + "":
			return "12.5"
			break;
		case CLARIFY_131 + "":
			return "Amdocs CRM6"
			break;
		case AMDOCS_75 + "":
			return "Amdocs CRM 7.5"
			break;
		default:
			return "Unknown";
  }
}

//////////////////////////////////////////////////////////////////////
// Get the Spec Rel ID for a relation
//////////////////////////////////////////////////////////////////////
function GetSpecRelID(TargetObjectID,InverseRelation) {
	TheSQL = "select spec_rel_id from adp_sch_rel_info where type_id = ";
	TheSQL += TargetObjectID;
	TheSQL += " and rel_name = '";
	TheSQL += InverseRelation + "'";
	rsSpecRelID = retrieveDataFromDB(TheSQL);
	SpecRelID = rsSpecRelID("spec_rel_id") - 0;
	rsSpecRelID.Close();
	rsSpecRelID = null;

	return SpecRelID;
}

//////////////////////////////////////////////////////////////////////
// Update the Cookie Collection
//////////////////////////////////////////////////////////////////////
function UpdateCookies() {
	in_list = false;
	var position = 0;

	for(var i = 1; i<=12; i++) {
		if(Request.Cookies("bolt_recent")("recent" + i) == type_name) {
			in_list = true;
			position = i;
		}
	}

	Response.Cookies("bolt_recent").Expires = "2020-01-01";

	if(in_list) {
		for(i = 12; i >= position; i--) {
			//These stay in the same position
			Response.Cookies("bolt_recent")("recent" + i) = Request.Cookies("bolt_recent")("recent" + i) + "";
			Response.Cookies("bolt_recent")("recent" + i + "id") = Request.Cookies("bolt_recent")("recent" + i + "id") + "";
		}
		for(i = position - 1; i >= 1; i--) {
			//These move down one
			Response.Cookies("bolt_recent")("recent" + (i + 1) ) = Request.Cookies("bolt_recent")("recent" + i ) + "";
			Response.Cookies("bolt_recent")("recent" + (i + 1) + "id") = Request.Cookies("bolt_recent")("recent" + i + "id") + "";
		}
	} else {
		for(i = 12; i > 1; i--) {
			Response.Cookies("bolt_recent")("recent" + i) = Request.Cookies("bolt_recent")("recent" + (i - 1)) + "";
			Response.Cookies("bolt_recent")("recent" + i + "id") = Request.Cookies("bolt_recent")("recent" + (i-1) + "id") + "";
		}
	}

	Response.Cookies("bolt_recent")("recent1") = type_name;
	Response.Cookies("bolt_recent")("recent1id") = type_id;
}

//////////////////////////////////////////////////////////////////////
// Formats a seconds value as "d h:m"
//////////////////////////////////////////////////////////////////////
function FormatSeconds(nSeconds) {
	// Break the seconds into days, hours and minutes
	var nDays = Math.floor(nSeconds / (60 * 60 * 24));
	var nHours = Math.floor((nSeconds / (60 * 60)) - (nDays * 24));
	var nMinutes = Math.floor((nSeconds / 60) - (nDays * 24 * 60) - (nHours * 60));

	// add the leading zeros
	if(nDays <= 9) {
		nDays = '00' + nDays;
	} else if(nDays >= 10 && nDays <= 99) {
		nDays = '0' + nDays;
	}

	if(nHours <= 9) nHours = '0' + nHours;
	if(nMinutes <= 9) nMinutes = '0' + nMinutes;

	// return the formatted values
	return nDays + ' ' + nHours + ':' + nMinutes;
}

//////////////////////////////////////////////////////////////////////
//Translate Time Types from an integer to the corresponding string
//////////////////////////////////////////////////////////////////////
function TranslateTimeType(TimeType) {
	switch (TimeType - 0) {
		case 0:
			TimeString = "event creation";
			break;
		case 1:
			TimeString = "contract response";
			break;
		case 2:
			TimeString = "subcase commit";
			break;
		case 3:
			TimeString = "subcase warning";
			break;
		case 4:
			TimeString = "commitment time";
			break;
		case 50:
			TimeString = "renew notification";
			break;
		case 51:
			TimeString = "quote expiration";
			break;
		case 52:
			TimeString = "earliest svc end date";
			break;
		case 53:
			TimeString = "support pgm response";
			break;
		case 54:
			TimeString = "commitment warning";
			break;
		case 150:
			TimeString = "renew notification";
			break;
		case 151:
			TimeString = "quote expiration";
			break;
		case 152:
			TimeString = "earliest svc end date";
			break;
		case 153:
			TimeString = "support pgm response";
			break;
		case 154:
			TimeString = "commitment warning";
			break;
		default:
			TimeString = TimeType + '&nbsp';
			break;
	}
	return TimeString;
}

//////////////////////////////////////////////////////////////////////
//Translate Time Units from an integer to the corresponding string
//////////////////////////////////////////////////////////////////////
function TranslateTimeUnits(TimeType) {
	switch (TimeType - 0) {
		case 0:
			TimeString = "Elapsed Time";
			break;
		case 1:
			TimeString = "Cust Bus Hrs";
			break;
		case 2:
			TimeString = "Sppt Bus Hrs";
			break;
		case 50:
			TimeString = "Cust Spt Prog Hrs";
			break;
		case 51:
			TimeString = "Int Spt Prog Hrs";
			break;
		case 150:
			TimeString = "Cust Spt Prog Hrs";
			break;
		case 151:
			TimeString = "Int Spt Prog Hrs";
			break;
		default:
			TimeString = TimeType + '&nbsp';
			break;
	}
	return TimeString;
}

//////////////////////////////////////////////////////////////////////
//Translate Rule Operators from an integer to the corresponding string
//////////////////////////////////////////////////////////////////////
function TranslateRuleOperator(RuleOperator) {
	switch (RuleOperator - 0) {
		case 0:
			CondOperator = ' > ';
			break;
		case 1:
			CondOperator = ' >= ';
			break;
		case 2:
			CondOperator = ' < ';
			break;
		case 3:
			CondOperator = ' <= ';
			break;
		case 4:
			CondOperator = ' = ';
			break;
		case 5:
			CondOperator = ' != ';
			break;
		case 6:
			CondOperator = ' starts with ';
			break;
		case 7:
			CondOperator = ' ends with ';
			break;
		case 8:
			CondOperator = ' does not start with ';
			break;
		case 9:
			CondOperator = ' does not end with ';
			break;
		case 10:
			CondOperator = ' contains ';
			break;
		case 11:
			CondOperator = ' does not contain ';
			break;
		case 12:
			CondOperator = ' is in ';
			break;
		case 13:
			CondOperator = ' is between ';
			break;
		default:
			CondOperator = ' ? ';
			break;
	}

	return CondOperator;
}

//////////////////////////////////////////////////////////////////////
//Translate Nulls into empty strings
//////////////////////////////////////////////////////////////////////
function CleanUpString(inString) {
	//If it's Null, make it an empty string
	//Then add the HTML non-breaking space to it
	outString = inString;
	if(String(inString + "") == "null") outString = "";
	if(outString.length == 0) outString = EmptyString;
	return outString;
}

function rw(inString) {
	Response.Write(inString);
}

function rf() {
	Response.Flush();
}

function re() {
	Response.End();
}

//////////////////////////////////////////////////////////////////////
//return the string parameters parsed out of a table's flags
//////////////////////////////////////////////////////////////////////
function GetTableParams(table_id) {
	TheSQL = "select " + FLAGS_FIELD + " from " + TABLE_TABLE + " where " + ID_FIELD + " = " + table_id;
	rs = retrieveDataFromDB(TheSQL);
	flags = rs(FLAGS_FIELD);

	var sp_str = "";
	if((flags & CACHEOBJIDS_FLAG) > 0) {
		sp_str = CACHEOBJIDS_STR;
	}
	if((flags & VIEW_OPTIMIZED_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= VIEW_OPTIMIZED_STR;
	}
	if((flags & ALLOW_FLEX_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= ALLOW_FLEX_STR;
	}
	if((flags & FLEX_TABLE_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= FLEX_TABLE_STR;
	}
	if((flags & LOGICAL_TABLE_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= LOGICAL_TABLE_STR;
	}
	if((flags & APP_OBJID_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= APP_OBJID_STR;
	}
	if((flags & STR_OBJID_FLAG) > 0) {
		if(sp_str != "") sp_str += COMMA_SPACE;
		sp_str+= STR_OBJID_STR;
	}
	sp_str += EmptyString;

	rs.Close();
	rs = null;

	return sp_str;
}

var the_class = "";

//////////////////////////////////////////////////////////////////////
// Swap the css class name
//////////////////////////////////////////////////////////////////////
function SwapClass(the_class) {
	if(the_class=="odd") the_class="even"; else the_class="odd";
	return the_class;
}

//For proper rendering of PNG Images in IE
function renderImage(id,path,alt,height,width,onclick) {
	if(new String(Request.servervariables("HTTP_USER_AGENT")+"").indexOf('MSIE') > 0) {
		rw('<img id=' + id + ' src="empty.gif" onclick="' + onclick + '" alt="' + alt + '" style="cursor:hand;height:' + height + ';width:' + width + ';filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + path + '\', sizingMethod=scale) ">');
	} else {
		rw('<img src="' + path + '" alt="' + alt + '" onclick="' + onclick + '" style="cursor:hand;height:' + height + ';width:' + width + ';" >');
	}
}

///////////////////////////////////////////////////////////////////////////////////
//Function to trim leading and trailing spaces
///////////////////////////////////////////////////////////////////////////////////
function FCTrim(strItem) {
	strItem += "";
	strItem = strItem.replace(/^\s*/, "").replace(/\s*$/, "");
	return strItem;
}

///////////////////////////////////////////////////////////////////////////////////
//Add variables for each QueryString item
///////////////////////////////////////////////////////////////////////////////////
function BuildQueryStringVariables(){
  for(var e = new Enumerator(Request.QueryString); !e.atEnd(); e.moveNext()) {
      eval(e.item() + " = FCTrim(unescape('" + escape(Request.QueryString(e.item())) + "'));");
	  }
}

///////////////////////////////////////////////////////////////////////////////////
//Get the base table link for a view
///////////////////////////////////////////////////////////////////////////////////
function getBaseTableLink() {
	TheSQL = "select from_obj_type from " + VIEW_TABLE + " where " + VIEW_ID + " = " + type_id;
	rsView = retrieveDataFromDB(TheSQL);

	if(rsView.RecordCount > 0) {
		var TableNum = rsView('from_obj_type') + "";
	} else {
		TableNum = -1;
	}
	rsView.Close();
	rsView = null;

	var TheLink = "";
	//Make the Base Table Name be a hyperlink:
	if(TableNum >= 0) TheLink = BuildTableHyperLink(TableNum);

	return TheLink;
}

///////////////////////////////////////////////////////////////////////////////////
//Get the filter sql for a view
///////////////////////////////////////////////////////////////////////////////////
function getFilterSQL() {
	var TheFilterSQL = "";
	if(ver > CLARIFY_125) {
		if(dbType == "MSSQL") {
			var TheSQL = "select ans.generic_sql,ans." + TheSQLStrName + " from adp_object ao left outer join adp_native_sql ans on ao.filter_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
		} else {
			var TheSQL = "select TO_CHAR(ans.generic_sql) AS generic_sql,TO_CHAR(ans." + TheSQLStrName + ") AS " + TheSQLStrName + " from adp_object ao left outer join adp_native_sql ans on ao.filter_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
		}

		rsView = retrieveDataFromDB(TheSQL);
		if(!rsView.EOF) {
			TheFilterSQL = rsView(TheSQLStrName) + "";
			if(TheFilterSQL == null || TheFilterSQL == 'null' || TheFilterSQL == "") TheFilterSQL = rsView('generic_sql') + "";
			if(TheFilterSQL == null || TheFilterSQL == 'null') TheFilterSQL = "";
		}
		rsView.Close;
		rsView = null;
	}
	return TheFilterSQL;
}

///////////////////////////////////////////////////////////////////////////////////
//Get a list of views where this view is contributing to a UNION
///////////////////////////////////////////////////////////////////////////////////
function getUnionViewsList(vid) {
	var ViewArray = [];
	if(ver > CLARIFY_125) {
		TheSQL = "select ao.type_name, ao.type_id from adp_object ao join adp_join aj on aj.view_type_id = ao.type_id join adp_object ac on aj.obj_type_id = ac.type_id where aj.join_flag >= 10 and aj.obj_type_id = " + vid;
		rsView = retrieveDataFromDB(TheSQL);
		var row = 0;
		while (!rsView.EOF) {
			ViewArray[row] = new Array(rsView("type_id")+0,rsView("type_name")+"");
			row++;
			rsView.MoveNext();
		}
		rsView.Close();
		rsView = null;
	}

	return ViewArray;
}

///////////////////////////////////////////////////////////////////////////////////
//Get the storage sql for a table
///////////////////////////////////////////////////////////////////////////////////
function getStorageSQL() {
	var TheStorageSQL = "";
	if(ver > CLARIFY_125) {
		if(dbType == "MSSQL") {
			var TheSQL = "select ans.generic_sql,ans." + TheSQLStrName + " from adp_object ao left outer join adp_native_sql ans on ao.storage_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
		} else {
			var TheSQL = "select TO_CHAR(ans.generic_sql) AS generic_sql,TO_CHAR(ans." + TheSQLStrName + ") AS " + TheSQLStrName + "  from adp_object ao left outer join adp_native_sql ans on ao.storage_sql_str_id = ans.objid where ao.type_name = '" + type_name + "'";
		}

		rs = retrieveDataFromDB(TheSQL);
		if(!rs.EOF) {
			TheStorageSQL = rs(TheSQLStrName) + "";
			if(TheStorageSQL == null || TheStorageSQL == 'null' || TheStorageSQL == "") TheStorageSQL = rs('generic_sql') + "";
			if(TheStorageSQL == null || TheStorageSQL == 'null') TheStorageSQL = "";
		}
		rs.Close();
		rs = null;
	}
	return TheStorageSQL;
}
%>

<script Runat=Server Language=VBscript>
function ReplaceStr (TextIn,SearchStr, Replacement, CompMode)
	Dim WorkText
	Dim Pointer
	If IsNull(TextIn) Then
		ReplaceStr = Null
	Else
		WorkText = TextIn
		Pointer = InStr(1, WorkText, SearchStr, CompMode)
		Do While Pointer > 0
			WorkText = Left(WorkText, Pointer - 1) & Replacement & Mid(WorkText, Pointer + Len(SearchStr))
			Pointer = InStr(Pointer + Len(Replacement), WorkText, SearchStr, CompMode)
		Loop
		ReplaceStr = WorkText
	End If
End Function

function SQLFixup(TextIn)
	SQLFixup = ReplaceStr(TextIn, "'", "''", 0)
End Function
</script>

<script LANGUAGE="VBscript" RUNAT="SERVER">
Sub DisconnectRecordset(rs)
	Set rs.ActiveConnection = Nothing
End Sub
</script>

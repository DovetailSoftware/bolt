<%
///////////////////////////////////////////////////////////////////////////////////
//Output header for a view
///////////////////////////////////////////////////////////////////////////////////
function outputViewHeader(ViewKind,TheLink) {
	rw("<table class='fullWidth top'>");
   rw("<tr>");
   rw("<td width='20%'>");
   rw(ViewKind+"View Name: ");
   rw("</td>");
   rw("<td>");
   rw(type_name );
   rw("</td>");
   rw("</tr>");
   rw("<tr>");
   rw("<td class='padRight'>");
   rw(ViewKind+"View Number:" );
   rw("</td>");
   rw("<td>");
   rw(type_id);
   rw("</td>");
   rw("</tr>");
   rw("<tr>");
   rw("<td>");
   rw("Group: ");
   rw("</td>");
   rw("<td>");
   rw(GetTableGroup(type_name) );
   rw("</td>");
   rw("</tr>");
   if(TheLink.length > 0){
      rw("<tr>");
      rw("<td>");
      rw("Base Table: ");
      rw("</td>");
      rw("<td>");
      rw(TheLink);
      rw("</td>");
      rw("</tr>");
   }
   rw("<tr>");
   rw("<td>");
   rw("Description: ");
   rw("</td>");
   rw("<td>");
   rw(Server.HTMLEncode(GetTableComment(type_name)));
   rw("</td>");
   rw("<tr>");
   rw("<td>");
   rw("Flags:");
   rw("</td>");
   rw("<td>");
   rw(GetTableParams(type_id));
   rw("</td>");
   rw("</tr>");
   rw("<tr>");
   rw("<td class='padRight'>");
   var BC = "Baseline";
   type_id = type_id - 0;
   if((type_id >= 2000 && type_id <= 4999) ||
      (type_id >= 430  && type_id <= 511)) BC = "Custom";
   rw("Baseline/Custom:");
   rw("</td>");
   rw("<td>");
   rw(BC );
   rw("</td>");
   rw("</tr>");
   rw("</table>");
}

function hyperlinksTable() {
	rw("<table class='fullWidth'>");
	rw("<table class='fullWidth'>");
	rw("<tr>");
	rw("<td>");
	rw("<a href='#fields'>Fields</a>");
	rw("</td>");
	rw("<td>");
	rw("<a href='#joins'>Joins</a>");
	rw("</td>");
	if(filterSQL != "") {
	   rw("<td>");
	   rw("<a href='#filters'>Filters</a>");
	   rw("</td>");
	}
	if(unionViewsList.length > 0) {
	   rw("<td>");
	   rw("<a href='#contribs'>Union Views Which This View Contributes To</a>");
	   rw("</td>");
	}
	var select_sql = "select * from table_" + type_name;
	var encoded_select_sql = Server.URLEncode(select_sql);
	rw("<td colspan=2><a href=sql.asp?sql=" + encoded_select_sql + "&flag=no_query>" + select_sql + "</a></td>");
	rw("</table>");
}

///////////////////////////////////////////////////////////////////////////////////
//Output all fields for a view
///////////////////////////////////////////////////////////////////////////////////
function outputViewFields() {
//Build an array of all the info
//Then we'll just print the columns of the array that we want
//The array structure will look like:
//  Column 0: View_spec_field_id
//  Column 1: Field Name
//  Column 2: From Object Type
//  Column 3: From Object Name
//  Column 4: Field ID
//  Column 5: Field Name
//  Column 6: Comments
//  Column 7: Flags
//  Column 8: Alias

   TheSQL = "select * from " + VIEW_TABLE + " where " + VIEW_ID + " = " + type_id;
   TheSQL+= " and flags = (select MIN(flags) from " + VIEW_TABLE + " where " + VIEW_ID + " = " + type_id + ")";
   TheSQL+= " order by " + VIEW_RANK;
   rsView = retrieveDataFromDB(TheSQL);

   var ViewArray = [];
   var row = 0;

   rw("<h4>Fields:</h4>");
   rw("<table id='fields' class='tablesorter fullWidth'>");
	rw("<table class='tablesorter fullWidth'>");
   rw("<thead><tr class='headerRow'>");

   if(rsView.RecordCount > 1) {
      while (!rsView.EOF){
         ViewSpecFieldID = rsView(VIEW_RANK);
         FromObjType = rsView(VIEW_FROM_TBL_ID);
         FromFieldID = rsView("from_field_id");
         ViewAlias   = FCTrim(rsView("alias")) + "";

         //We need to subtract a higher order bit to get the correct field ID
         if(FromFieldID >= 16384) FromFieldID = FromFieldID - 16384;

         Comment = Server.HTMLEncode(rsView(comment_field)+"") + EmptyString;
         if(Comment == "null" + EmptyString) Comment = EmptyString;

         Flags = rsView("flags");

         ViewArray[row] = [];
         ViewArray[row][0] = ViewSpecFieldID + "";
         ViewArray[row][2] = FromObjType + "";
         ViewArray[row][4] = FromFieldID + "";
         ViewArray[row][6] = Comment + "";
         ViewArray[row][7] = Flags + "";
         ViewArray[row][8] = ViewAlias + "";

         if(FromObjType != -1) {
            TableName = GetTableName(FromObjType);
            FieldName = GetFieldName(FromObjType, FromFieldID);
         } else {
            TableName = "CONSTANT FIELD";
            //Get the fields for this table
            TheSQL = "select " + DEFAULT_FIELD + " from " + FIELD_TABLE + " where " + ID_FIELD + " = " + type_id;
            TheSQL+= " and " + TABLE_RANK + " = " + ViewSpecFieldID;
            rsTable = retrieveDataFromDB(TheSQL);
            FieldName = 'VALUE="' + Server.HTMLEncode(rsTable(DEFAULT_FIELD) + "") + '"';
         }

         ViewArray[row][3] = TableName + "";
         ViewArray[row][5] = FieldName + "";

         row++;
         rsView.MoveNext();
      }
      rsView.Close();
      rsView = null;

      //Get all of the View field names
      TheSQL = "select * from adp_sch_info where type_id = ";
      TheSQL+= type_id;
      TheSQL+=" order by spec_field_id";
      rsViewFields = retrieveDataFromDB(TheSQL);

      row = 0;
      while (!rsViewFields.EOF){
         ViewFieldName = rsViewFields("field_name");
         ViewArray[row][1] = ViewFieldName + "";

         genFieldId = "";
         if(rsViewFields("gen_field_id") - 0 > 0){
          genFieldId=rsViewFields("gen_field_id") + "";
         }
         if(genFieldId == 3){
          genFieldId+= " (UNIQUE)";
         }

         ViewArray[row][9] = genFieldId;

         row = row + 1;
         rsViewFields.MoveNext();
      }
      rsViewFields.Close();
      rsViewFields = null;

   	//Print the Table of view fields
      //Build the Table header
      rw("<th>");
      rw("View Field Name");
      rw("</th>");
      rw("<th>");
      rw("Table Name");
      rw("</th>");
      rw("<th>");
      rw("Field Name");
      rw("</th>");
      rw("<th>");
      rw("Comment");
      rw("</th>");
      rw("<th>Generic Field Id</th>");
      rw("</tr></thead>");
      rw("<tbody>");

      //Build the data part of the table
      nFields = ViewArray.length;
      for(row = 0; row < nFields; row++){
         ViewFieldName = ViewArray[row][1];
         TableName = ViewArray[row][3];
         FieldName = ViewArray[row][5];
         Comments = ViewArray[row][6];
         TableNum = ViewArray[row][2];
         ViewAlias = ViewArray[row][8];
         GenFieldId = ViewArray[row][9];

			rw("<tr>");
         rw("<td>");
         rw(ViewFieldName);
         rw("</td>");
         rw("<td>");

         //Make the Table Name be a hyperlink:
         TheLink = (TableName == "CONSTANT FIELD") ? TableName : MakeTableOrViewHyperLink(TableNum,TableName);

         //If there's an alias, show the alias, and put the real table in parens & hyperlinked
         if(ViewAlias != "null" && ViewAlias != "") TheLink = ViewAlias + "(" + TheLink + ")";

         rw(TheLink);
         rw("</td>");
         rw("<td>");
         rw(FieldName);
         rw("</td>");
         rw("<td>");
         rw(Comments);
         rw("</td>");
         rw("<td>");
         rw(GenFieldId);
         rw("</td>");
         rw("</tr>");
      }

   } else {

      rw("<th>");
      rw("Field Name");
      rw("</th>");
      rw("<th>");
      rw("Common Type");
      rw("</th>");
      rw("<th>");
      rw("Database Type");
      rw("</th>");
      rw("<th Type=Number>");
      rw("Generic Field ID");
      rw("</th>");
      rw("<th Type=Number>");
      rw("Array Size");
      rw("</th>");
      rw("<th>");
      rw("Default");
      rw("</th>");
      rw("<th>");
      rw("Flags");
      rw("</th>");
      rw("<th>");
      rw("Comment");
      rw("</th>");
      rw("</th></thead>");
      rw("<tbody>");

      //Get the fields for this table
      TheSQL = "select * from " + FIELD_TABLE + " where " + ID_FIELD + " = ";
      TheSQL+= type_id;
      TheSQL+=" order by field_name";
      rsTables = retrieveDataFromDB(TheSQL);

      while (!rsTables.EOF){
         FieldName = rsTables("field_name");
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
         if(Comment == "null" + EmptyString) Comment = EmptyString;
         FldDefault = Server.HTMLEncode(rsTables(DEFAULT_FIELD) + "") + EmptyString;
         if(FldDefault == "null" + EmptyString) FldDefault = EmptyString;
         ArraySize = rsTables(FIELD_LENGTH_FIELD);
         TableNum = type_id;
         Flags = rsTables("flags");
         strFlags = GetFieldParams(Flags);

         SpecFieldID = rsTables("spec_field_id");
         GenFieldID = rsTables("gen_field_id");
         DecP = rsTables("dec_p");
         DecS = rsTables("dec_s");

         //If this is a decimal, then build the precision info string
         if(DBTypeStr == "decimal"){
            DBTypeStr = DBTypeStr + " (" + DecP + "," + DecS + ")";
         }

         //If the GenFieldID = -1, then change it to an empty string
         if(GenFieldID == "-1") GenFieldID=EmptyString;

         //If the ArraySize = -1, then change it to an empty string
         if(ArraySize == "-1") ArraySize=EmptyString;

         //Now that all of our data is cool, build the data part of the table
         rw("<tr>");
         rw("<td>");
         rw(FieldName);
         rw("</td>");
         rw("<td>");
         rw(CmnTypeStr);
         rw("</td>");
         rw("<td>");
         rw(DBTypeStr);
         rw("</td>");
         rw("<td>");
         rw(GenFieldID);
         rw("</td>");
         rw("<td>");
         rw(ArraySize);
         rw("</td>");
         rw("<td>");
         rw(FldDefault);
         rw("</td>");
         rw("<td>");
         rw(strFlags);
         rw("</td>");
         rw("<td>");
         rw(Comment);
         rw("</td>");
         rw("</tr>");

         rsTables.MoveNext();
      }
      rsTables.Close();
      rsTables = null;
      rw("<tbody>");
      rw("</table>");
   }
   rw("<tbody>");
   rw("</table>");
   Response.Flush();
}
%>
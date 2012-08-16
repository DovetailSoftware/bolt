<%@ language="JavaScript" %>
<% Response.Buffer = true %>

<%
var sPageTitle = "Details for View";
var sPageType = "Schema";
%>

<!--#include file="config.inc"-->
<!--#include file="adojavas.inc"-->
<!--#include file="ddonline.inc"-->
<!--#include file="json.asp"-->

<%
function LoadHgbstListFromDatabase(listName, level1value, level2value, level3value, level4value) {
   var level = 0;
   var boHgbstList = null;
   var boHgbstShow = [];
   var boHgbstElm = [];

   try { var lName = unescape(listName); listName = lName; } catch(e) {}

   var levelValue = [];
   levelValue[1] = (level1value) ? level1value : "";
   levelValue[2] = (level2value) ? level2value : "";
   levelValue[3] = (level3value) ? level3value : "";
   levelValue[4] = (level4value) ? level4value : "";
   levelValue[5] = "";

   var theSQL = "select objid, title, hgbst_lst2hgbst_show from table_hgbst_lst where title = '" + listName + "'";
   boHgbstList = retrieveDataFromDB(theSQL);

   var showObjid = boHgbstList("hgbst_lst2hgbst_show") - 0;
   boHgbstList.Close();

   theSQL = "select objid, title from table_hgbst_show where objid = " + showObjid;
   boHgbstShow[0] = retrieveDataFromDB(theSQL);

   theSQL = "select objid, title, state from table_hgbst_elm where objid in (select hgbst_elm2hgbst_show from mtm_hgbst_elm0_hgbst_show1 where hgbst_show2hgbst_elm = " + showObjid + ")";
   theSQL += " AND state != 'Inactive'";
   theSQL += ((levelValue[1] > "") ? " AND title = '" + levelValue[1] + "'" : "");
   theSQL += " order by rank asc";
   boHgbstElm[0] = retrieveDataFromDB(theSQL);

   if(levelValue[1] > "") level = 1;

   for(i = 1; i <= 4 && boHgbstElm[i-1] && !boHgbstElm[i-1].EOF; i++) {
      if(levelValue[i] > "") {
         theSQL = "select objid, title from table_hgbst_show where objid != " + boHgbstShow[i-1]("objid");
         theSQL += " AND objid in (select hgbst_show2hgbst_elm from mtm_hgbst_elm0_hgbst_show1 where hgbst_elm2hgbst_show = " + boHgbstElm[i-1]("objid") + ")";
         boHgbstShow[i] = retrieveDataFromDB(theSQL);

         if(boHgbstShow[i] && !boHgbstShow[i].EOF) {
            theSQL = "select objid, title, state from table_hgbst_elm where objid in (select hgbst_elm2hgbst_show from mtm_hgbst_elm0_hgbst_show1 where hgbst_show2hgbst_elm = " + boHgbstShow[i]("objid") + ")";
            theSQL += " AND state != 'Inactive'";
            theSQL += " AND objid != " + boHgbstElm[i-1]("objid");
            theSQL += ((levelValue[i+1] > "") ? " AND title = '" + levelValue[i+1] + "'" : "");
            theSQL += " order by rank asc";
            boHgbstElm[i] = retrieveDataFromDB(theSQL);

            if(levelValue[i+1] > "") level = i+1;
         }
      }
   }

   var UDPLLevel = { "defaultValue":"" };
   var rowCounter = 0;

   if(boHgbstElm[level] && !boHgbstElm[level].EOF) {
      UDPLLevel.defaultValue = boHgbstElm[level]("title")+"";
      while(!boHgbstElm[level].EOF) {
         var row = {};
         row["title"] = encodeURIComponent(escape(boHgbstElm[level]("title")));
         row["state"] = boHgbstElm[level]("state")+"";
         if(boHgbstElm[level]("state") == "Default") UDPLLevel.defaultValue = boHgbstElm[level]("title")+"";
         UDPLLevel[rowCounter++] = row;
         boHgbstElm[level].MoveNext();
      }
   }

   for(i = 1; i <= 4 && boHgbstElm[i-1]; i++) boHgbstElm[i-1].Close();
   for(i = 1; i <= 4 && boHgbstShow[i-1]; i++) boHgbstShow[i-1].Close();

   UDPLLevel.rowCount = rowCounter;
   return UDPLLevel;
}

function addLevelToJsonObject(whichLevel,jsonGeneric,value) {
   var property = "level" + whichLevel + "Value";
   jsonObject[property] = encodeURIComponent(escape(value));

   property = "level" + whichLevel;
   jsonObject[property] = [];

   for(i in jsonGeneric) {
      jsonObject[property][i] = jsonGeneric[i].title;
   }
}

try {
   Response.Clear();
   BuildQueryStringVariables();

   if(level1value) try { var l1val = unescape(level1value); level1value = l1val; } catch(e) {}
   if(level2value) try { var l2val = unescape(level2value); level2value = l2val; } catch(e) {}
   if(level3value) try { var l3val = unescape(level3value); level3value = l3val; } catch(e) {}
   if(level4value) try { var l4val = unescape(level4value); level4value = l4val; } catch(e) {}

   var jsonObject = {
      "level1Value"     :"", "level1":[],
      "level2Value"     :"", "level2":[],
      "level3Value"     :"", "level3":[],
      "level4Value"     :"", "level4":[],
      "level5Value"     :"", "level5":[],
      "listName"        :listName,
      "selectElement1Id":selectElement1Id
   };

   //Level 1:
   var level = LoadHgbstListFromDatabase(listName);
   var level1default = level.defaultValue;
   if (level1value == "") level1value = level1default;
   addLevelToJsonObject(1, level, level1value);

   //Level 2:
   level = LoadHgbstListFromDatabase(listName, level1value);
   if(level.rowCount > 0) {
      var level2default = level.defaultValue;
      if (level2value == "") level2value = level2default;
      addLevelToJsonObject(2, level, level2value);

      //Level 3:
      level = LoadHgbstListFromDatabase(listName, level1value, level2value);
      if(level.rowCount > 0) {
         var level3default = level.defaultValue;
         if (level3value == "") level3value = level3default;
         addLevelToJsonObject(3, level, level3value);

         //Level 4:
         level = LoadHgbstListFromDatabase(listName, level1value, level2value, level3value);
         if(level.rowCount > 0) {
            var level4default = level.defaultValue;
            if (level4value == "") level4value = level4default;
            addLevelToJsonObject(4, level, level4value);

            //Level 5:
            level = LoadHgbstListFromDatabase(listName, level1value, level2value, level3value, level4value);
            if(level.rowCount > 0) {
               var level5default = level.defaultValue;
               if (level5value == "") level5value = level5default;
               addLevelToJsonObject(5, level, level5value);
            }
         }
      }
   }
   var jsonText = JSON.stringify(jsonObject);
   rw(jsonText);

   jsonObject = null;

} catch(e) { rw(e.description); }
%>
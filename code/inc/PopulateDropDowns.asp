<%
function LoadHgbstListFromDatabase(listName, level1value, level2value, level3value, level4value) {
   var level = 0;
   var boHgbstShow = [];
   var boHgbstElm = [];

   try { var lName = unescape(listName); listName = lName; } catch(e) {}

   var levelValue = [];
   levelValue[1] = level1value;
   levelValue[2] = level2value;
   levelValue[3] = level3value;
   levelValue[4] = level4value;
   levelValue[5] = "";

//   var boHgbstLst = FCSession.CreateGeneric("hgbst_lst");
//   boHgbstLst.AppendFilter("title", "=", listName);
//   boHgbstLst.BulkName = "hgbst_" + new Date().toString();
//
//   boHgbstShow[0] = FCSession.CreateGeneric("hgbst_show");
//   boHgbstShow[0].TraverseFromParent(boHgbstLst, "hgbst_lst2hgbst_show");
//   boHgbstShow[0].Bulk = boHgbstLst.Bulk;
//
//   boHgbstElm[0] = FCSession.CreateGeneric("hgbst_elm");
//   boHgbstElm[0].TraverseFromParent(boHgbstShow[0], "hgbst_show2hgbst_elm");
//   boHgbstElm[0].Bulk = boHgbstLst.Bulk;
//   boHgbstElm[0].DataFields = "title,state,rank";
//   if(level1value > "") {
//      level = 1;
//      boHgbstElm[0].AppendFilter("title", "=", level1value);
//   }
//   boHgbstElm[0].AppendSort("rank", "asc");
//   boHgbstElm[0].AppendFilter("state", "!=", "Inactive");
//
//   boHgbstLst.Bulk.Query();

   for(i = 1; i <= 4; i++) {
      if(levelValue[i] > "") {
//         boHgbstShow[i] = FCSession.CreateGeneric("hgbst_show");
//         boHgbstShow[i].TraverseFromParent(boHgbstElm[i-1], "hgbst_elm2hgbst_show");
//         boHgbstShow[i].AppendFilter("objid", "!=", boHgbstShow[i-1]("objid").value);
//         boHgbstShow[i].Bulk = boHgbstLst.Bulk;
//
//         boHgbstElm[i] = FCSession.CreateGeneric("hgbst_elm");
//         boHgbstElm[i].TraverseFromParent(boHgbstShow[i], "hgbst_show2hgbst_elm");
//         boHgbstElm[i].AppendFilter("objid", "!=", boHgbstElm[i-1]("objid").value);
//         boHgbstElm[i].Bulk = boHgbstLst.Bulk;
//         boHgbstElm[i].DataFields = "title,state,rank";
//         if(levelValue[i+1] > "") {
//            level = i+1;
//            boHgbstElm[i].AppendFilter("title", "=", levelValue[i+1]);
//         }
//         boHgbstElm[i].AppendFilter("state", "!=", "Inactive");
//         boHgbstElm[i].AppendSort("rank", "asc");
      }

//      boHgbstLst.Bulk.Query();
   }

   var UDPLLevel = { "defaultValue":"" };
   var rowCounter = 0;

//   if(boHgbstElm[level].Count() > 0) {
//      UDPLLevel.defaultValue = boHgbstElm[level]("title").value;
//      while(!boHgbstElm[level].EOF) {
//         var row = {};
//         row["title"] = encodeURIComponent(escape(boHgbstElm[level]("title").value));
//         row["state"] = boHgbstElm[level]("state").value;
//         if(boHgbstElm[level]("state").value == "Default") UDPLLevel.defaultValue = boHgbstElm[level]("title").value;
//         UDPLLevel[rowCounter++] = row;
//         boHgbstElm[level].MoveNext();
//      }
//   }
//   FCSession.CloseAllGenerics();

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

function populateDropDowns(listName, selectElement1Id, level1value, level2value, level3value, level4value, level5value) {
	try {

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
   	var level = LoadHgbstListFromDatabase(listName, level1value);
   	if(level.rowCount > 0) {
   	   var level2default = level.defaultValue;
   	   if (level2value == "") level2value = level2default;
   	   addLevelToJsonObject(2, level, level2value);

	 	   //Level 3:
   	   var level = LoadHgbstListFromDatabase(listName, level1value, level2value);
   	   if(level.rowCount > 0) {
   	      var level3default = level.defaultValue;
   	      if (level3value == "") level3value = level3default;
   	      addLevelToJsonObject(3, level, level3value);

   	      //Level 4:
   	      var level = LoadHgbstListFromDatabase(listName, level1value, level2value, level3value);
   	      if(level.rowCount > 0) {
   	         var level4default = level.defaultValue;
   	         if (level4value == "") level4value = level4default;
   	         addLevelToJsonObject(4, level, level4value);

   	         //Level 5:
   	         var level = LoadHgbstListFromDatabase(listName, level1value, level2value, level3value, level4value);
   	         if(level.rowCount > 0) {
   	            var level5default = level.defaultValue;
   	            if (level5value == "") level5value = level5default;
   	            addLevelToJsonObject(5, level, level5value);
   	         }
   	      }
   	   }
   	}

		var jsonText = JSON.stringify(jsonObject);
		Response.Write(jsonText);

	   jsonObject = null;

	} catch(e) { Response.Write(e.description); }
}
%>
function multiLevelListHelper(_listName, _elementIds, _values){
   this.listName = _listName;
   this.values = _values;
   this.elementIds = _elementIds;
   this.whichSelectElementIdChanged = '';
   this.pathToPopulateDropDowns = '../inc/PopulateDropDowns.asp';

   //Add an on change event to all but the last drop-down
   for( var i = 0; i < this.elementIds.length - 1; i++ ) {
      var ddlObj = document.getElementById(this.elementIds[i]);
      ddlObj.listObject = this;
      ddlObj.level = i+1;
      ddlObj.onchange = onDropDownChange;
   }
}

multiLevelListHelper.prototype.populate = function() {
   var url=this.pathToPopulateDropDowns;
   url+="?listName="    + encodeURIComponent(escape(this.listName));
   url+="&level1value=" + encodeURIComponent(escape(this.values[0]));
   url+="&level2value=" + encodeURIComponent(escape(this.values[1]));
   url+="&level3value=" + encodeURIComponent(escape(this.values[2]));
   url+="&level4value=" + encodeURIComponent(escape(this.values[3]));
   url+="&level5value=" + encodeURIComponent(escape(this.values[4]));
   url+="&selectElement1Id=" + encodeURIComponent(escape(this.elementIds[0]));
   var self = this;

   this.xmlHttp=GetXmlHttpObject();
   this.xmlHttp.onreadystatechange=function() {
      if (self.xmlHttp.readyState==4 || self.xmlHttp.readyState=="complete") {
         if (self.xmlHttp.status != 200) {
            alert('Unexpected Error:' + self.xmlHttp.responseText);
            return false;
         }

         var jsonObject = $.parseJSON(self.xmlHttp.responseText);
         var selectElement1 = document.getElementById(jsonObject.selectElement1Id);
         var listObject = selectElement1.listObject;

         addOptionsToSelectList(listObject.elementIds[0],jsonObject.level1,jsonObject.level1Value);
         addOptionsToSelectList(listObject.elementIds[1],jsonObject.level2,jsonObject.level2Value);
         addOptionsToSelectList(listObject.elementIds[2],jsonObject.level3,jsonObject.level3Value);
         addOptionsToSelectList(listObject.elementIds[3],jsonObject.level4,jsonObject.level4Value);
         addOptionsToSelectList(listObject.elementIds[4],jsonObject.level5,jsonObject.level5Value);
      }
   }

   this.xmlHttp.open("GET", url , true);
   this.xmlHttp.send(null);
}

function onDropDownChange() {
   listObject = this.listObject;
   var whichLevelChanged = this.level;

   var selectElement1 = document.getElementById(listObject.elementIds[0]);
   var selectElement2 = document.getElementById(listObject.elementIds[1]);
   var selectElement3 = document.getElementById(listObject.elementIds[2]);
   var selectElement4 = document.getElementById(listObject.elementIds[3]);

   listObject.values[0] = '';
   listObject.values[1] = '';
   listObject.values[2] = '';
   listObject.values[3] = '';
   listObject.values[4] = '';

   if (whichLevelChanged >= 1){
      listObject.values[0] = selectElement1.options[selectElement1.selectedIndex].text;
   }
   if (whichLevelChanged >= 2){
      listObject.values[1] = selectElement2.options[selectElement2.selectedIndex].text;
   }
   if(whichLevelChanged >= 3){
      listObject.values[2] = selectElement3.options[selectElement3.selectedIndex].text;
   }
   if(whichLevelChanged >= 4){
      listObject.values[3] = selectElement4.options[selectElement4.selectedIndex].text;
   }

   listObject.populate();
}

function addOptionsToSelectList(elementId,ArrayOfOptionValues,selectedValue) {
   if(! document.getElementById(elementId)){
      return false;
   }
   document.getElementById(elementId).options.length = 0;
   for(var i = 0; i<ArrayOfOptionValues.length;i++) {
      var optionValue = ArrayOfOptionValues[i];
      if(optionValue) try { var ovalue = decodeURIComponent(unescape(optionValue)); optionValue = ovalue; } catch(e) {}
      var option = new Option(optionValue,optionValue);
      document.getElementById(elementId).add(option);
   }
   if(selectedValue) try { var svalue = decodeURIComponent(unescape(selectedValue)); selectedValue = svalue; } catch(e) {}
   document.getElementById(elementId).value = selectedValue;
   document.getElementById(elementId).disabled = (document.getElementById(elementId).options.length == 0);
}

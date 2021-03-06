function GetXmlHttpObject(handler) {
   var objXmlHttp = null;

   if(navigator.userAgent.indexOf("MSIE") >= 0) {
      var strName="Msxml2.XMLHTTP";
      if(navigator.appVersion.indexOf("MSIE 5.5") >= 0) {
         strName="Microsoft.XMLHTTP";
      }
      try {
         objXmlHttp = new ActiveXObject(strName);
         if (handler){objXmlHttp.onreadystatechange=handler;}
         return objXmlHttp;
      } catch(e) {
         alert("Error. Scripting for ActiveX might be disabled");
         return;
      }
   }
   if(navigator.userAgent.indexOf("Mozilla") >= 0) {
      objXmlHttp = new XMLHttpRequest();
      if(handler) {
         objXmlHttp.onload = handler;
         objXmlHttp.onerror= handler;
      }
      return objXmlHttp;
   }
}

function multiLevelListHelper(_listName, _elementIds, _values) {
   this.listName = _listName;
   this.values = _values;
   this.elementIds = _elementIds;
   this.whichSelectElementIdChanged = '';
   var loc = window.location.href;
   var pos = loc.lastIndexOf("/");
   this.pathToPopulateDropDowns = loc.substr(0,pos) + '/inc/PopulateDropDowns.asp';

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

         addOptionsToSelectList(listObject.elementIds[0],jsonObject.level1,jsonObject.level1Value,jsonObject.local1,jsonObject.id1);
         addOptionsToSelectList(listObject.elementIds[1],jsonObject.level2,jsonObject.level2Value,jsonObject.local2,jsonObject.id2);
         addOptionsToSelectList(listObject.elementIds[2],jsonObject.level3,jsonObject.level3Value,jsonObject.local3,jsonObject.id3);
         addOptionsToSelectList(listObject.elementIds[3],jsonObject.level4,jsonObject.level4Value,jsonObject.local4,jsonObject.id4);
         addOptionsToSelectList(listObject.elementIds[4],jsonObject.level5,jsonObject.level5Value,jsonObject.local5,jsonObject.id5);
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

   $('select.local').remove();
   listObject.populate();
}

function addOptionsToSelectList(elementId,ArrayOfOptionValues,selectedValue,ArrayOfLocalizations,ArrayOfIds) {
   if(! document.getElementById(elementId)){
      return false;
   }
   document.getElementById(elementId).options.length = 0;
   for(var i = 0; i<ArrayOfOptionValues.length;i++) {
      var optionValue = getValue(ArrayOfOptionValues[i]);
      var option = new Option(optionValue,optionValue);
      option.title = ArrayOfIds[i];
      document.getElementById(elementId).add(option);
   }
   if(ArrayOfLocalizations != undefined) {
      if(ArrayOfLocalizations.length > 0) {
         var $localSelect = $('<select class="local"></select>')
         for(var i = 0; i<ArrayOfLocalizations.length;i++) {
            var optionValue = getValue(ArrayOfOptionValues[i]);
            var optionText = getValue(ArrayOfLocalizations[i]);
            var optionTitle = ArrayOfIds[i];
            $localSelect.append('<option value="'+optionValue+'">'+optionText+'</option>');
         }
         $localSelect.insertAfter('#'+elementId);
      }
   }
   if(selectedValue) try { var svalue = decodeURIComponent(unescape(selectedValue)); selectedValue = svalue; } catch(e) {}
   document.getElementById(elementId).value = selectedValue;
   document.getElementById(elementId).disabled = (document.getElementById(elementId).options.length == 0);
}

function getValue(optionValue) {
   if(optionValue) try { var ovalue = decodeURIComponent(unescape(optionValue)); optionValue = ovalue; } catch(e) {}
   return optionValue;
}
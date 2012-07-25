<%
function WriteReport(rs) {
	var alternatingRowClassName;
	rs.Sort = "fired DESC, create_activity_log DESC"
	if(rs.EOF) return;
	rs.MoveFirst();
	while(!rs.EOF) {
		alternatingRowClassName=SwapClass(alternatingRowClassName);
		rw("<tr class='" + alternatingRowClassName + "'>");
		rw("<td>");
		rw("<a href='select_biz_rules2.asp?operator=%3D&filter2=&forceDisplay=1&filter=" + Server.URLEncode(rs("rulename")) + "'>");
		rw(rs("rulename") + "");
		rw("</a>");
		rw("</td>");
		rw("<td>");
		rw(rs("action") + "");
		rw("</td>");
		rw("<td class='centerMiddle'>");
		rw(rs("fired") + "");
		rw("</td>");
		rw("<td>");
		if(rs("create_activity_log") == 0) {
			rw("<img src='img/icon-warning.png' alt='warning' title='This rule action has its Create Activity Log option set to No, so firings of this rule will not show up in this report. See note at bottom of page for more info.' style='float:right;cursor:hand;' />");
		}
		rw("</td>");
		rw("</tr>");
		rs.MoveNext();
	}
}

function FillRecordSetWithRulesThatFired(rs, start, end) {
	if(dbType == "Oracle") {
		var sql = "select addnl_info, count(*)  from table_act_entry where act_code = 8500";
		sql += " and entry_time >= TO_DATE('" + start + "','YYYY-MM-DD HH24:MI:SS') and entry_time <= TO_DATE('" + end + "','YYYY-MM-DD HH24:MI:SS') ";
		sql += " group by addnl_info order by count(*) desc";
	} else {
		var sql = "select addnl_info, count(*)  from table_act_entry where act_code = 8500 ";
		sql += "and entry_time >= '" + start + "' and entry_time <= '" + end + "'";
		sql += " group by addnl_info order by count(*) desc";
	}

	var records = retrieveDataFromDBStatic(sql);
	var addnl_info;
	var action;
	var index1;
	var index2;
	while(!records.EOF) {
		//Parse the rulename and action title from the additional info string
		addnl_info = records("addnl_info") + "";
		addnl_info = addnl_info.replace(/Action /i, "");
		index1 = addnl_info.indexOf("of rule");
		action = addnl_info.slice(0,index1);
		index2 = addnl_info.lastIndexOf("fired");
		rule = addnl_info.slice(index1 + 8, index2); //8 = length of (" of rule ");

		//Add this data to the recordset
		rs.AddNew();
		rs("rulename") = FCTrim(rule);
		rs("action") = FCTrim(action);
		rs("fired") = records(1);
		rs("create_activity_log") = 1;
		rs("objid") = 0;

		totalRulesFired+=records(1)-0;
		numberOfRuleActions++;
	records.MoveNext();
	}
	records.Close();

}

function FillRecordSetWithRemainingRules(rs) {
	var action;
	var actionFlags;
	var ruleTitle;
	var sql = "select title, objid from table_com_tmplte where type = 1 and flags = 0";  //flags = 0 means active rules
	var ruleRecords = retrieveDataFromDBStatic(sql);

	while(!ruleRecords.EOF) {
		ruleTitle = ruleRecords("title") + "";

		var sql2 = "select * from table_com_tmplte where escal_act2com_tmplte =" + ruleRecords("objid");
		var actionRecords = retrieveDataFromDBStatic(sql2);

		while(!actionRecords.EOF) {
			action = actionRecords("title") + "";
			if(!rs.EOF && !rs.BOF) rs.MoveFirst();

			actionFilter = action.replace("'", "''");
			ruleTitleFilter = ruleTitle.replace("'","''");
			rs.Filter = "rulename = '" + ruleTitleFilter + "' AND action = '" + actionFilter + "'";

			if(rs.EOF || rs.BOF) {
				rs.AddNew();
				rs("fired") = 0;
				rs("rulename") = FCTrim(ruleTitle);
				rs("action") = FCTrim(action);

				if((actionRecords("flags") & 1024) > 0) {
					rs("create_activity_log") = 1;
				} else {
					rs("create_activity_log") = 0;
				}
			}

			rs("objid") = ruleRecords("objid") - 0;
			rs.Filter = "";
			numberOfRuleActions++;
			actionRecords.MoveNext();
		}
		actionRecords.Close();
		ruleRecords.MoveNext();
	}
	ruleRecords.Close();
}

function BuildTimeFilter(timePeriod, displayString, when) {
	if(when == timePeriod) {
		rw("<span>" + displayString + "</span>");
	} else {
		rw("<a href=\"javascript:DisplayReport('" + timePeriod + "');\">" + displayString + "</a>");
	}
}

function ensureValidDate(in_date) {
	if(vbIsNull(in_date) ||  new String(in_date).replace(/\s/g,"").length == 0 || in_date == "null" || in_date == "undefined")
		return "1/1/1753";
	else
		return in_date;
}

///////////////////////////////////////////////////////////////////////////////////
//Function to pretty-up a date to be consistent with the Clarify fat client
///////////////////////////////////////////////////////////////////////////////////
function PrettyDate(in_date) {
	return vbPrettyDate(isoFormatDate(new Date(ensureValidDate(in_date))));
}

///////////////////////////////////////////////////////////////////////////////////
//Function to pretty-up a date to be consistent with the Clarify fat client (without the time)
///////////////////////////////////////////////////////////////////////////////////
function PrettyDateOnly(in_date) {
	return vbPrettyDateOnly(isoFormatDate(new Date(ensureValidDate(in_date))));
}

function isoFormatDate(date) {
	return ("000" + date.getFullYear()).slice(-4) +
		"-" + ("0" + (date.getMonth() + 1)).slice(-2) +
		"-" + ("0" + date.getDate()).slice(-2) +
		" " + ("0" + date.getHours()).slice(-2) +
		":" + ("0" + date.getMinutes()).slice(-2) +
		":" + ("0" + date.getSeconds()).slice(-2);
		// + "." + ("00" + date.getMilliseconds()).slice(-3);
}

//////////////////////////////////////////////////
//  global arrays
//////////////////////////////////////////////////
var dayOfWeekArray = new Array("S", "M", "T", "W", "T", "F", "S");
var monthArray = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
var noDaysArray = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var monthAbbreviationArray = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec");

function getNumDaysInMonth(month,year) {
	var firstOfMonth = new Date(month + "/1/" + year);
	var day = - firstOfMonth.getDay();

	// determine number of days in month
	var noDays = noDaysArray[month]
  	if(month == 2) {
		if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) noDays = 29;
	}

  	return noDays;
}

function whenString(when) {
   if(when == "this_month") return "This Month";
   if(when == "this_year") return "This Year";
   if(when == "last_year") return "Last Year";
   if(when == "last_month") return "Last Month";
   if(when == "last_7_days") return "in Last 7 Days";
   if(when == "last_30_days") return "in Last 30 Days";
   if(when == "last_365_days") return "in Last 365 Days";
   return "";
}

//////////////////////////////////////////////////
// get start date
//////////////////////////////////////////////////
function getStartDate(when) {
   var curr_year = new Date().getFullYear();
   var curr_month = new Date().getMonth();
   var start = new Date();

   start.setHours(0);
   start.setMinutes(0);
   start.setSeconds(0);
   start.setMilliseconds(0);

   if(when == "this_month") start.setDate(1);

   if(when == "this_year") {
      start.setDate(1);
      start.setMonth(0);
   }

   if(when == "last_year") {
      start.setDate(1);
      start.setMonth(0);
      start.setFullYear(curr_year - 1);
   }

   if(when == "last_month") {
      var year = curr_year;
      var last_month = curr_month - 1;

      if(last_month == - 1) {
         last_month = 11;
         year = curr_year-1;
      }

      start.setDate(1);
      start.setMonth(last_month);
      start.setFullYear(year);
   }

   if(when == "last_7_days") start = new Date(vbDateAdd("d", -7, PrettyDateOnly(new Date())));
   if(when == "last_30_days") start = new Date(vbDateAdd("d", -30, PrettyDateOnly(new Date())));
   if(when == "last_365_days") start = new Date(vbDateAdd("d", -365, PrettyDateOnly(new Date())));

  	return isoFormatDate(start);
}

//////////////////////////////////////////////////
// get end date
//////////////////////////////////////////////////
function getEndDate(when) {
   var curr_year = new Date().getFullYear();
   var curr_month = new Date().getMonth();
   var end = new Date();

   end.setHours(23);
   end.setMinutes(59);
   end.setSeconds(59);
   end.setMilliseconds(999);

   if(when == "this_month") end.setDate(getNumDaysInMonth(curr_month, curr_year));

   if(when == "this_year") {
      end.setDate(31);
      end.setMonth(11);
   }

   if(when == "last_year") {
      end.setDate(31);
      end.setMonth(11);
      end.setFullYear(curr_year - 1);
   }

   if(when == "last_month") {
      var year = curr_year;
      var last_month = curr_month - 1;
      if(last_month == - 1) {
         last_month = 11;
         year = curr_year-1;
      }

      end.setDate(getNumDaysInMonth(last_month, year));
      end.setMonth(last_month);
      end.setFullYear(year);
   }
	return isoFormatDate(end);
}
%>
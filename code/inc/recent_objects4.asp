<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  recent_objects.asp
//
// Description    :  Table used to display recent objects
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
	<div class="row-fluid justify-content-md-center mt-3">
		<div class="col-8 card bg-faded offset-2">
			<div class="card-block py-1">
				<h5 class="card-title my-1">My Recent Objects</h5>
				<table class="table table-condensed">
					<tr>
					<% var bolt_recent = Request.Cookies("bolt_recent") + "";
						if(bolt_recent == "") bolt_recent = "None";

						var recent1   = Request.Cookies("bolt_recent")("recent1") + "";
						var recent2   = Request.Cookies("bolt_recent")("recent2") + "";
						var recent3   = Request.Cookies("bolt_recent")("recent3") + "";
						var recent4   = Request.Cookies("bolt_recent")("recent4") + "";
						var recent5   = Request.Cookies("bolt_recent")("recent5") + "";
						var recent6   = Request.Cookies("bolt_recent")("recent6") + "";
						var recent7   = Request.Cookies("bolt_recent")("recent7") + "";
						var recent8   = Request.Cookies("bolt_recent")("recent8") + "";
						var recent9   = Request.Cookies("bolt_recent")("recent9") + "";
						var recent10  = Request.Cookies("bolt_recent")("recent10") + "";
						var recent11  = Request.Cookies("bolt_recent")("recent11") + "";
						var recent12  = Request.Cookies("bolt_recent")("recent12") + "";

						var recent1id = Request.Cookies("bolt_recent")("recent1id") + "";
						var recent2id = Request.Cookies("bolt_recent")("recent2id") + "";
						var recent3id = Request.Cookies("bolt_recent")("recent3id") + "";
						var recent4id = Request.Cookies("bolt_recent")("recent4id") + "";
						var recent5id = Request.Cookies("bolt_recent")("recent5id") + "";
						var recent6id = Request.Cookies("bolt_recent")("recent6id") + "";
						var recent7id = Request.Cookies("bolt_recent")("recent7id") + "";
						var recent8id = Request.Cookies("bolt_recent")("recent8id") + "";
						var recent9id = Request.Cookies("bolt_recent")("recent9id") + "";
						var recent10id = Request.Cookies("bolt_recent")("recent10id") + "";
						var recent11id = Request.Cookies("bolt_recent")("recent11id") + "";
						var recent12id = Request.Cookies("bolt_recent")("recent12id") + "";

						for (var i=1; i <=12; i++) { 
							%>
           		<td class="w-25 my-0 py-0">
							<%
							if ( eval("recent" + i + "id") != "undefined" ) {
								var table_num = GetTableNum(eval("recent" + i));
								//If this table exists in this database, and its ID number is the same, then its good
								if ((table_num  >= 0) && (table_num == eval("recent" + i + "id"))) {
									rw(MakeTableOrViewHyperLink(eval("recent" + i + "id") , eval("recent" + i)));
								} else {
									rw(eval("recent" + i));
								}
							} else {
								rw("&nbsp;");
							}
							%>
           		</td>
							<%
							if((i % 4) == 0 && i < 12) {
								rw("</tr>");
								rw("<tr>");
							}
						}
						%>
				</table>
			</div>
		</div>
	</div>

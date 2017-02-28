<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  quick_links.asp
//
// Description    :  Table used to display quicklinks
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
	<div class="row-fluid justify-content-md-center mt-2">
		<div class="col-8 card bg-faded offset-2">
			<div class="card-block py-1">
				<h5 class="card-title my-1">Quick Links</h5>
				<table class="table table-condensed">
					<tr>
					<% var j = 0;
						for (var i = 1; i < LinkArray.length; i++) {
							if(++j == 5) {
								j = 1;
								rw("</tr><tr>");
							}

							//If this table exists in this database, then its good
							var table_num = GetTableNum(LinkArray[i][1]);
							if((table_num  >= 0) && (table_num == LinkArray[i][2])) {
								if(IsView(LinkArray[i][2])) { %>
	             		<td class='w-25 my-0 py-0'><a href="view.asp?type_id=<%=LinkArray[i][2]%>"> <%=LinkArray[i][1]%> </a></td>
								<% } else { %>
									<td class='w-25 my-0 py-0'><a href="table.asp?type_id=<%=LinkArray[i][2]%>"> <%=LinkArray[i][1]%> </a></td>
								<% }
		        		} else {
		           		rw("<td class='w-25 my-0 py-0'>" + LinkArray[i][1] + "</td>");
		        		}
			     		} %>
					</tr>
				</table>
			</div>
		</div>
	</div>

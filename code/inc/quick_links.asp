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
	<h3>Quick Links</h3>
	<table id="quickLinks" class="fullWidth">
		<tr>
		<% var j = 0;
			for (var i = 1; i < LinkArray.length; i++) {
				j = j + 1;
				if(j == 5) {
					j = 1;
					rw("</tr><tr>");
				}

				//If this table exists in this database, then its good
				var table_num = GetTableNum(LinkArray[i][1]);
				if((table_num  >= 0) && (table_num == LinkArray[i][2])) {
					if(IsView(LinkArray[i][2])) { %>
              		<td><a href="view.asp?type_id=<%=LinkArray[i][2]%>&type_name=<%=LinkArray[i][1]%> "> <%=LinkArray[i][1]%> </a></td>
					<% } else { %>
						<td><a href="table.asp?type_id=<%=LinkArray[i][2]%>&type_name=<%=LinkArray[i][1]%> "> <%=LinkArray[i][1]%> </a></td>
					<% }
        		} else {
           		rw("<td>" + LinkArray[i][1] + "</td>");
        		}
     		} %>
		</tr>
	</table>
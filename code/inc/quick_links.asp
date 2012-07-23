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
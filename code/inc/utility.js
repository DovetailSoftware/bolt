<%
function rw(foo) {
  Response.Write(foo);
}

function rf(){
  Response.Flush();
}

function re(){
  Response.End();
}

function FCTrim(strItem) {
  strItem+='';
  strItem = strItem.replace(/^\s*/, '').replace(/\s*$/, '');
  return strItem;
}
%>
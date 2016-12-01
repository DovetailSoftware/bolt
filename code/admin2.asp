<%@ language="JavaScript" %>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  admin2.asp
//
// Description    :  Server page that updates the database information
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
<!--#include file="inc/config.inc"-->
<!--#include file="inc/json.asp"-->
<%
var result = {};
result.success = true;
result.message = "";
result.errorMessage = "";

try {

	var Provider = Request("Provider");
	var UserID   = Request("UserID");
	var Password = Request("Password");
	var Database = Request("Database");
	var DBServer = Request("DBServer");

	var FSO = Server.CreateObject("Scripting.FileSystemObject");

	//Build up the new UDL Info String
	var UDLString = "Provider=";
	UDLString += Provider;
	UDLString += ";Password=";
	UDLString += Password;
	UDLString += ";User ID=";
	UDLString += UserID;
	UDLString += ";Data Source=";
	UDLString += DBServer;
	UDLString += ";Persist Security Info=True";

//Initial File Name="";Server SPN=""

	result.message = "Database set to: ";

	if(Provider == "SQLOLEDB.1" || Provider == "SQLNCLI11.1") {
  	UDLString += ";Initial Catalog=";
  	UDLString += Database;
  	result.message += Database + " on Server: " + DBServer;
	} else {
		result.message += DBServer;
	}

	if(Provider == "SQLNCLI11.1") {
		UDLString += ";Initial File Name=\"\";Server SPN=\"\"";
	}

	//Get the Connection String & extract the actual file name
	var TheFile = dbConnect;
	TheFile = TheFile.replace("File Name=", "");

	//Create a new Text File (file_name,overwrite,unicode)
	UDL = FSO.CreateTextFile(TheFile,true,true);

	//Write out the info to the new UDL file
	UDL.WriteLine("[oledb]");
	UDL.WriteLine("; Everything after this line is an OLE DB initstring");
	UDL.WriteLine(UDLString);

	//Close the File
	UDL.Close();

	//Cleanup
	UDL = null;
	FSO = null;

} catch(e) {
   result.success = false;
   result.errorMessage = e.description;
}

Response.Clear();
Response.Write(JSON.stringify(result));
%>
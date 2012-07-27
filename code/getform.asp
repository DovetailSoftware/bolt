<%@ language="JavaScript" %>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  getform.asp
//
// Description    :  Form Finder
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
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Form";
var sPageType = "Forms";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<%
	var id = Request("id");
	var ver_clarify = Request("ver_clarify");
	var ver_customer = Request("ver_customer");

	var TheSQL  = "select * from table_window_db where id = " + id;
	TheSQL += " and ver_clarify='" + ver_clarify + "'";
	TheSQL += " and ver_customer='" + ver_customer + "'";

	rsForms = retrieveDataFromDBStatic(TheSQL);

	if (rsForms.RecordCount == 1) {
		FormObjid = rsForms("objid");
		FormId = rsForms("id");
		TheLink = BuildFormURL(FormObjid, FormId)
		Response.Redirect(TheLink);
	} else {
		rw("<h3>Form not found</h3>");
		rw("Unable to find a form with id =" + id + " and clarify version = " + ver_clarify + " and customer version = " + ver_customer);
		re();
	}
%>
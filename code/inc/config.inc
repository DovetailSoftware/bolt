<%
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  First Choice Development Series(tm)
//
// Name           :  config.inc
//
// Description    :  Customer Specific Configuration Information
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
// Copyright (C)  2001-2009 Dovetail Software, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////

//Customer Specific Configuration Information
var udlDirectory = Request.ServerVariables("APPL_PHYSICAL_PATH").Item;
var dbConnect = "File Name=" + udlDirectory + "bolt.udl";
var allowConnectionSaves = true;
%>

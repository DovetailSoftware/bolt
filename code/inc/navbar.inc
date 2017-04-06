<!--
///////////////////////////////////////////////////////////////////////////////
// Product			 :	Online Tools(tm)
//
// Series				 :	Dovetail Software Development Series(tm)
//
// Name					 :	navbar.inc
//
// Description   :	Shared menu bar
//
// Author				 :	Dovetail Software, Inc.
//									 4807 Spicewood Springs Rd, Bldg 4 Suite 200
//									 Austin, TX 78759
//									 (512) 610-5400
//									 EMAIL: support@dovetailsoftware.com
//									 www.dovetailsoftware.com
//
// Platforms		 :	This version supports Clarify 9.0 and later
//
// Copyright (C) 2001-2012 Dovetail Software, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////
-->
<nav class="navbar navbar-toggleable-md navbar-inverse bg-inverse py-0 mb-3 sticky-top">
  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#boltNavbar" aria-controls="boltNavbar" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <a class="navbar-brand text-info" href="index.asp"><img src="/bolt/img/logo.png" height="20" class="mb-1" /> Bolt</a>
  <div class="collapse navbar-collapse" id="boltNavbar">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item"><a class="nav-link" href="index.asp">Schema</a></li>
      <li class="nav-item"><a class="nav-link" href="formsonline.asp">Forms</a></li>
      <li class="nav-item"><a class="nav-link" href="bizrules.asp">Business Rules</a></li>
      <li class="nav-item"><a class="nav-link" href="dbInfo.asp">Database Info</a></li>
      <li class="nav-item"><a class="nav-link" href="sql.asp">SQL</a></li>
      <li class="nav-item"><a class="nav-link" href="lists.asp">Lists</a></li>
      <li class="nav-item"><a class="nav-link" href="licenses.asp">Licenses</a></li>
      <li class="nav-item"><a class="nav-link" href="about.asp">About</a></li>
    </ul>
    <span class="navbar-text">
      <a class="connected text-nowrap text-right text-info small" href="admin.asp" title="Change Connection"></a>
    </span>
  </div>
</nav>

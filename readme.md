<img src="http://www.dovetailsoftware.com/sites/default/files/dovetail_logo.png" alt="Dovetail Software, Inc." style="margin: 0 0 -2em 0;border: 0;" />
Dovetail Bolt
=============

## Introduction

### Dovetail Bolt gives you real-time access to your Clarify data from a set of easy-to-use web pages and provides the data tools you need:

* Schema: Search for and view your customized schema in real-time, including tables, views, relations, joins, and indexes.
* Forms: Search for your Clarify Classic Client Forms, and see details about the form's contextual objects, controls, child forms, tabs, and parent forms.
* Business Rules: Search for and view all aspects of a business rule at one time. Aspects include the business rule title, rule set, description, rule status, objects, start events, cancel events, conditions, and actions.
* Database Info: View how your database is set up, including ADP database header information, database flags, ADO information, and other miscellaneous database information.
* SQL: Submit SQL queries to your database.
* <b>Clarify Licenses</b>: View your Clarify License information in an easily readable format.

## Support

### Installing Bolt

Configure the web server to support Dovetail Bolt:

* If you are using IIS7 (on Windows 7 or Windows Server 2008), refer to the [IIS7 Setup Instructions](bolt/iis7.md)
* If you are using IIS6 (on Windows Server 2003), refer to the [IIS6 Setup Instructions](bolt/iis6.md)


### Getting Help

If you need additional help beyond this user guide, you can use any of the following resources:

* [Dovetail SelfService](http://support.dovetailsoftware.com/selfservice/) - Use our online customer support site to notify us of a support issue, to manage your Dovetail products, to seek sales support, or to search the knowledge base.
* [Knowledge Base Articles](http://support.dovetailsoftware.com/selfservice/solutions/search) - Search our online knowledge base for existing issue resolutions.
* [Product Documentation](http://support.dovetailsoftware.com/selfservice/products/list) - Find Dovetail's most up-to-date product documentation.
* [Dovetail Blog Posts](http://www.dovetailsoftware.com/dovetailconnectblog) - Dovetail developers often publish useful posts.
* Contact Us - Contact us directly if you need further assistance.
 * email: support@dovetailsoftware.com
 * phone: 800-684-2055 or 512-610-5400

## Using Bolt

###Schema

In the Schema section, you can view your customized schema in real-time, including tables, views, relations, joins, and indexes.

To search for and view schema objects:

1. From Bolt, select Schema.
1. Enter search criteria in one of the search fields and click Search.
1. Find the object in the list and click the name.


### User-Defined Table and View IDs

From Bolt, within the Schema section, click on the More information about User-Defined Table and View IDs link.

This page provides more information about user-defined table and view IDs, including:

* the available ranges for user-defined IDs
* which IDs have been used within each range
* the lowest available ID within each range
* a link to view the IDs that have been used within each range

This information is useful for determining an ID when adding a new custom table or view to the schema.


### Forms and Controls

In the Forms section, you have read-only access to your Clarify Classic Client Forms. After searching for a form, you can view the form details which include the form's contextual objects, controls, child forms, tabs, and parent forms.

To search for and view forms:

1. From Bolt, select Forms.
1. Enter search criteria and click Search.
1. Find the form in the list and click the title.


### Controls

In the Forms section, you also have read-only access to your Clarify Classic Client Form Controls. After searching for a control you can view details about the control such as control type, name, label, as well as click to view the details of the form that this control is part of.

If the control is a command button, you can click to view the details of the command button, including the privileges for the button, as well as any defined button actions.

To search for and view forms:

1. From Bolt, select Forms.
1. Click on the search for a particular control link.
1. Enter search criteria and click Search.


### Business Rules

In the Business Rules section, you can view all aspects of a business rule at one time. Aspects include the business rule title, rule set, description, rule status, objects, start events, cancel events, conditions, and actions.

To search for business rules:

1. From Bolt, select Business Rules.
1. Enter one or more search criteria and click Search.

	<pre><code>Note: All search filters are ANDed together.</code></pre>


### Database Info

From Bolt, select Database Info to view how your database is set up, including ADP database header information, database flags, ADO information, and other miscellaneous database information.

### SQL

From the SQL page, you can submit SQL queries to your database.

To submit an SQL query:

1. From Bolt, select SQL.
1. Enter the SQL code and click Submit Query. The results are displayed at the bottom of the page.


### Clarify Licenses

The Clarify Licenses section lists all of your Clarify License information in an easily readable format. It contains the same information that would be returned by the following SQL query:

	select * from table_lic_count


### Database Connection

From the administration page, you can configure the database connection:

1. From the Bolt homepage, click Administration page.
1. Select the Provider and enter your User ID, Password, Server, and Database.

	<pre><code>Note: You only need to specify a database if you are using SQL Server.</code></pre>

1. Click Submit.

	<pre><code>Note: If you get an error message after clicking Submit, the user running Bolt may not have permission to modify the connection information. This information is stored in the bolt.udl file. For more information about this problem, see the Knowledge Base article [Changing the login info in Bolt results in a Permission denied error](http://support.dovetailsoftware.com/selfservice/solutions/show/277).</code></pre>


### Customizing CSS

You can use Bolt's style sheet, <i>style.css</i>, to customize Bolt's look and feel.

### Customizing Bolt Quick Links

You can customize the Quick Links shown on the Schema page (schema.asp), which are global and seen by all Bolt users. By default, they link to a set of tables and views.

You can modify <i>inc/quicklinks.inc</i> with any text editor. The file is an array. Each element in the array is an object name and its object ID.

For example:

	LinkArray[LinkIndex] = [];
	LinkArray[LinkIndex][1]= "rol_contct";
	LinkArray[LinkIndex++][2]= "289";

You can remove any of the existing links, and add any of your own.

For example, to add the address table, you would use:

	LinkArray[LinkIndex] = [];
	LinkArray[LinkIndex][1]= "address";
	LinkArray[LinkIndex++][2]= "47";

## Copyright Notice and Trademarks

### Copyright ©2012 Dovetail Software, Inc. All Rights Reserved.

Dovetail Software intends the information in this document solely for its licensees and to aid prospective customers in evaluating Dovetail Software products. Any other use is prohibited. Dovetail Software makes a written warranty to its licensees, as is stated in its written license agreement. Dovetail Software makes no warranty to any other party regarding the accuracy or usefulness of the information contained in this document. Dovetail Software reserves the right to modify the content of this document without obligation to notify any party. Dovetail Software is not liable for consequential or incidental damages.

Dovetail Software develops and supplies software and customizations to the following Clarify products: ClearSupport, ClearQuality, ClearHelpDesk, ClearContracts, Policies and Customers, ClearSales, ProductManager, ClearCallCenter, and ClearLogistics.

ManyDovetail Software products use the following Clarify tools: User Interface Editor, ClearBasic Exchange, Data Dictionary Editor, ClearBasic Batch, Data Exchange, Clarify Business Objects, RuleManager, eBusiness Framework, ClearBasic, and Clarify Low-Level API©.

Clarify, its product names, and tools are trademarks of Amdocs, which may include the following: AmdocsCRM, ClearConfigurator, SalesBasic, ClearConfigurator Workshop, Notifier, eSupport, Classification Engine, eOrder Routing Server, eResponse Manager, ClearEnterprise, Email Clerk, Email Manager, Traveler, e.link, Diagnosis Engine, and Flexible Deployment.

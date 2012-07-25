## IIS7

### Enable Classic ASP, Server Side Includes, and ASP.NET

When you are adding the Web Server (IIS) role to Windows Server 2008 that the ASP feature is not added by default.

Start Server Manager select the Web Server (IIS) Role. Click on Add Role Services. Make sure you have ASP and Server Side Includes and ASP.NET selected.

Also select the IIS 6 Management Compatibility features which are found near the bottom of the list of features.

### Create a Application Pool

You need to run each of your Dovetail web applications in their own Application Pool.

1. To open IIS Manager, select Start - type IIS, and select Internet Information Services (IIS) Manager
1. Click on your computer host name to expand the top-level node.
1. Click on Application Pools
1. Right-click on Application Pools and choose Add Application Pool
1. Enter a name, such as DovetailBolt_AppPool
1. Set the Managed Pipeline Mode to Classic
1. Set the .NET Framework Version to version 2. If version 2 is not available, select version 3.5.
1. If you are running a 64bit operating system, and using the 32-bit Dovetail SDK, you will need to Enable 32-Bit Applications for the Application Pool. Click on Advanced Settings… Set Enable 32-Bit Applications to True. Note that his is not the recommendation configuration.
1. The recommendation is to use the 64-bit Dovetail SDK on 64-bit systems, and leave the Enable 32-Bit Applications application pool setting set to False.

### Create the web application(s)

1. To open IIS Manager, select Start - type IIS, and select Internet Information Services (IIS) Manager
1. Click on your computer host name to expand the top-level node.
1. Right-click Default Web Site and select Add Application
1. In the Alias text box, type a short name (alias) for the directory into which the Dovetail Bolt product was installed (i.e. Bolt). The alias is what users see as part of the URL path when they are browsing to the Dovetail Bolt web application (for example, http://www.MyCompany.com/<Bolt>).
1. Enter the path, or browse to the directory which contains the Dovetail Bolt web application files (the pages folder under the installation directory).
1. Select the Application Pool that you created earlier
1. Select OK.
1. Close the <b>ISM</b>.

### Enable Parent Paths
Parent Paths need to be enabled when an asp page includes a script with a path containing a ".." An example would be:

<!--#include file="../include/inc_room.asp"-->

Dovetail Bolt does use parent paths.
1. Navigate to your web application in IIS7 Manager.
1. Click on <b>ASP</b>.
1. Set <b>Enable Parent Paths</b> to <b>True</b>.
1. Click on Apply.

### Send Script Errors To The Browser

When you try to browse your web application you may run into this message telling you... "Something went going wrong but sorry I won't tell you what." That error looks like this:"

An error occurred on the server when processing the URL. Please contact the system administrator.

If you are the system administrator please click here to find out more about this error.

To see the actual error, you can configure the application to send errors to the browser. This is helpful when debugging a problem.
1. Navigate to your web application in IIS7 Manager.
1. Click on <b>ASP</b>.
1. Expand the <b>Debugging</b> section
1. Set <b>Send Errors to Browser</b> to <b>True</b>.
1. Click on Apply.

Additional Information on [configuring ASP applications on IIS7 is available online](http://blogs.dovetailsoftware.com/blogs/kmiller/archive/2008/08/19/installing-classic-asp-web-applications-on-iis7.aspx).
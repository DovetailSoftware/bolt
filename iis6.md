## IIS6

<pre><code>Note: The following assumes IIS version 6.0 on Microsoft Windows 2003. Your system may vary slightly.</code></pre>

### Install IIS

First, in order to run ASP applications, you must have the Internet Information Server installed. This is installed as part of the "Application Server" role.

1. Open the Manage Server Console (Start menu->Manage Your Server in the upper-left of the Start Menu)
1. If the "Application Server" role is not already listed, click "Add or Remove role" and select the <b>Application Server</b> role.

### Enable Classic ASP, Server Side Includes, and ASP.NET

ASP is disabled by default on Windows 2003. You must explicitly enable ASP and Server Side Includes.

1. Open the IIS Manager(Start->Administrative Tools->Internet Information Services (IIS) Manager)
1. Expand the <b>Internet Information Services (IIS) Manager</b> in the tree view on the left and then expand your computer's tree node.
1. Click on the "<b>Web Service Extensions</b>" node.
1. Click on "<b>Active Server Pages</b>" then click the "Allow" button.
1. Click on "<b>Server Side Includes</b>" then click the "Allow" button.

### Create an Application Pool

1. Open <b>Internet Information Services (IIS) Manager</b>
1. Click on your computer host name to expand the top-level node.
1. Click on Application Pools
1. Right-click on Application Pools and choose Add Application Pool
1. Enter a name, such as Dovetail Bolt_AppPool

### Create the web application

1. Open <b>Internet Information Services (IIS) Manager</b>
1. Click the tree node icon on your computer host name (or double-click the computer host name) to expand the top-level node.
1. Within the Web Sites node, right-click <b>Default Web Site</b> and select <b>New</b> and <b>Virtual Directory</b>.
1. In the <b>Virtual Directory Creation Wizard</b>, select <b>Next</b> to continue.
1. In the <b>Alias text box</b>, type a short name (<b>alias</b>) for the directory into which the Dovetail Bolt product was installed (i.e. Bolt). The alias is what users see as part of the URL path when they are browsing to the Dovetail Bolt web application, for example:
	<pre>http://www.MyCompany.com/Bolt</pre>
1. Select <b>Next</b>.
1. Enter the path, or browse to the directory which contains the Dovetail Bolt web application files (the 'pages' folder under the installation directory).
1. Select <b>Next</b> and set the access permissions to <b>Read</b> and <b>Run Scripts</b>.
1. Select <b>Next</b> and then <b>Finish</b>.
1. In the left pane of the <b>Internet Information Services (IIS) Manager</b>, select <b>Default Web Site</b>, and then press the F5 key to refresh the list of virtual folders.
1. Right-click on the root of your Dovetail Bolt web application, choose Properties. In the Application Pool drop-down list, select the application pool created above. Choose <b>OK</b>.

	<pre><code>Note: Notice that the virtual folder of your newly created application appears under the alias name you supplied previously. Also note that the icon for your virtual folder appears as a yellow gear icon. This means that your application is set up and ready to host ASP pages.</code></pre>

### Enable Parent Paths

Parent Paths need to be enabled when an ASP page includes a script with a path containing a ".." An example would be:

	<!--#include file="../include/inc_room.asp"-->

Dovetail Bolt does use parent paths.

1. Navigate to your web application in IIS Manager.
1. Right click on the virtual root(s) you created for Dovetail Bolt and select Properties
1. On the "Virtual Directory" tab of the property page that appears, click the "Configuration" button under the "Application Settings" section.
1. Click on the "Options" tab of the new property page that appears
1. Check the <b>Enable Parent Paths</b> checkbox.

### Send Script Errors To The Browser

When you try to browse your web application you may run into this message telling you... "Something went going wrong but sorry I won't tell you what." That error looks like this:"

	An error occurred on the server when processing the URL. Please contact the system administrator.
	If you are the system administrator please click here to find out more about this error.

To see the actual error, you can configure the application to send errors to the browser. This is helpful when debugging a problem.

1. Navigate to your web application in IIS Manager.
1. Right click on the virtual root(s) you created for Dovetail Bolt and select Properties
1. On the "Virtual Directory" tab of the property page that appears, click the "Configuration" button under the "Application Settings" section.
1. Click on the "Debugging" tab of the new property page that appears
1. Click on the <b>Send detailed ASP messages to client</b> option.

### Grant filesystem permissions to the IUSR_[COMPUTERNAME] user

1. Open My Computer or an Explorer window and navigate to the location which you installed Dovetail Bolt.
1. Right-click on the directory and click Properties.
1. Click the "Security' tab.
1. Click "Add" to add a new group/user.
1. For the object name to select, type: [COMPUTERNAME]\IUSR_[COMPUTERNAME] where [COMPUTERNAME] is the Windows computer/host name of your Server (i.e. WEBSVR01).
1. Click OK.
1. Highlight that user in the list of Groups or users with permissions to this folder and verify that the IUSR_* user has "Read & Execute", "List Folder Contents", and "Read" permissions.

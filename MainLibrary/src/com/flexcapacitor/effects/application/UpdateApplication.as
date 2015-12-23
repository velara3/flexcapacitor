

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.UpdateApplicationInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.utils.ClassUtils;
	
	import flash.events.Event;
	
	import mx.effects.Effect;
	
	/**
	 * Dispatched just before installing the update (cancellable) 
	 ***/
	[Event(name="beforeInstall", type="air.update.events.UpdateEvent")]
	
	/**
	 * Dispatched just before the update process begins 
	 **/
	[Event(name="checkForUpdate", type="air.update.events.UpdateEvent")]
	
	/** 
	 * Dispatched when the download of the update file is complete 
	 ***/
	[Event(name="downloadComplete", type="air.update.events.UpdateEvent")]
	
	/** 
	 * Dispatched when an error occured while downloading the update file 
	 ***/
	[Event(name="downloadError", type="air.update.events.DownloadErrorEvent")]
	
	/** 
	 * Dispatched when the download of the update file begins 
	 ***/
	[Event(name="downloadStart", type="air.update.events.UpdateEvent")]
	
	/** 
	 * Dispatched if something goes wrong with our knowledge. 
	 * This is a generic catch all event for all the errors this class dispatches. 
	 ***/
	[Event(name="error", type="flash.events.Event")]
	
	/** 
	 * Dispatched when an error occured while trying to parse the AIR file from installFromAIRFile call 
	 ***/
	[Event(name="fileUpdateError", type="air.update.events.StatusFileUpdateErrorEvent")]
	
	/** 
	 * Dispatched when status information is available after parsing the AIR file from 
	 * installFromAIRFile call (cancellable if an update is available)
	 ***/
	[Event(name="fileUpdateStatus", type="air.update.events.StatusFileUpdateEvent")]
	
	/**
	 * Dispatched on first run 
	 ***/
	[Event(name="firstRun", type="flash.events.Event")]

	/**
	 * Dispatched at the initialization phase.
	 ***/
	[Event(name="initialize", type="flash.events.Event")]
	
	/**
	 * Dispatched after the initialization is complete 
	 ***/
	[Event(name="initialized", type="air.update.events.UpdateEvent")]
	
	/**
	 * Dispatched after the initialization is complete
	 ***/
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched when an error occured while trying to download or parse the update descriptor 
	 ***/
	[Event(name="updateError", type="air.update.events.StatusUpdateErrorEvent")]
	
	/**
	 * Dispatched when status information is available after parsing the update descriptor 
	 * (cancellable if an update is available)
	 ***/
	[Event(name="updateStatus", type="air.update.events.StatusUpdateEvent")]
	
	/**
	 * Dispatched when an update is available
	 * @see updateNotAvailable
	 * @see updateStatus
	 ***/
	[Event(name="updateAvailable", type="flash.events.Event")]
	
	/**
	 * Dispatched when an update is not available
	 * @see updateAvailable
	 * @see updateStatus
	 ***/
	[Event(name="updateNotAvailable", type="flash.events.Event")]
	
	
	/**
	 * Checks for updates and then optionally starts the update wizard to update the application
	 * from the web. Also, lets you know if an app has run for the first time. You can get the 
	 * app version from the currentVersion property at any time.<br/><br/>
	 *
	 * Instructions when using an updateConfig.xml file:<br/><br/>
	 * 
	 * 1. Create a text file named UpdateConfig.xml in your project directory and add the following to it:
<pre>
&lt;?xml version="1.0" encoding="utf-8"?> 
&lt;configuration xmlns="http://ns.adobe.com/air/framework/update/configuration/2.5"> 
	&lt;url>http://example.com/updates/update.xml&lt;/url> 
	&lt;delay>1&lt;/delay>
&lt;/configuration>
</pre>
	 * 2. Set the URL element of the updateConfig.xml to the eventual location of the update descriptor file on your web server (more info below). <br/>
	 * 3. Set the delay element of the updateConfig.xml to the number of days the application waits between checks for updates. Values like ".25" are allowed. <br/>
	 * 4. Set the updateConfigPath property to the location of the file you just created. The default value is, "app:/updateConfig.xml".<br/><br/>
	 * 
	 * Instructions when NOT using an updateConfig.xml file:<br/><br/>
	 * 
	 * 1. Set the updateURL property to the eventual location of the update descriptor file on your web server (more info below).<br/>
	 * 2. Optionally, set the delay property to the number of days the application waits between checks for updates. Default is 1. Values like .25 are allowed.<br/><br/>
	 * 
	 * Instructions continued:<br/><br/>
	 * 1. Create a text file typically named UpdateDescriptor.xml with the following contents and copy it to the server. 
	 * Note: Replace the information in this file with information relative to your application.  
<pre>
&lt;?xml version="1.0" encoding="utf-8"?> 
&lt;update xmlns="http://ns.adobe.com/air/framework/update/description/2.5"> 
	&lt;version>1.1.1&lt;/version> 
	&lt;url>http://example.com/updates/sample_1.1.1.air&lt;/url> 
	&lt;description>&lt;![CDATA[List the changes in this version here]]>
	&lt;/description> 
&lt;/update>
</pre>
	 * 2. Be sure to update the version string of the UpdateDescriptor.xml to the same version of your AIR application file
	 * you will upload to your web server. You can check your AIR application version number in your Flex 
	 * application-app.xml descriptor file.<br/>
	 * 2.1 Create a release build of your application. Upload it to the server. <br/>
	 * 3. Set the URL in the UpdateDescriptor.xml to the location of the AIR application file you uploaded to your web server.<br/>
	 * 4. Optionally set the description in the UpdateDescriptor.xml with the changes in your app.<br/><br/>
	 * 
	 * <b>USAGE:</b><br/> 
	 * Example using a UpdateConfig.xml:
<pre>
&lt;fc:UpdateApplication updateConfigPath="app:/UpdateConfig.xml" />
</pre>
	 * Example NOT using a updateConfig.xml:
<pre>
&lt;fc:UpdateApplication updateDescriptorPath="http://www.example.com/updates/updateDescriptor.xml" />
</pre>
 * 
 * Another example setting the update descriptor path, not using UI and canceling any updates:
<pre>
&lt;handlers:EventHandler eventName="initialize">
	&lt;local:UpdateApplication id="updateApplication"
				 traceEvents="false" 
				 useUI="false"
				 cancelBeforeUpdate="true"
				 updateURL="http://www.mysite.com/updates/UpdateDescriptor.xml" 
				 beforeInstall="trace(event.type + ':' + event);"
				 checkForUpdate="trace(event.type + ':' + event);"
				 downloadComplete="trace(event.type + ':' + event);"
				 downloadError="trace(event.type + ':' + event);"
				 downloadStart="trace(event.type + ':' + event);"
				 error="trace(event.type + ':' + event)"
				 fileUpdateError="trace(event.type + ':' + event);"
				 fileUpdateStatus="trace(event.type + ':' + event);"
				 firstRun="trace(event.type + ':' + event);"
				 initialize="trace(event.type + ':' + event);"
				 initialized="trace(event.type + ':' + event);"
				 progress="trace(event.type);"
				 updateError="trace(event.type + ':' + event);"
				 updateStatus="trace(event.type + ':' + event);"
				 updateAvailable="trace(event.type + ':' + event);"
				 updateNotAvailable="trace(event.type + ':' + event);"
				 >
		&lt;local:firstRunEffect>
			&lt;status:ShowStatusMessage message="First time run"/>
		&lt;/local:firstRunEffect>
		&lt;local:updateAvailableEffect>
			&lt;status:ShowStatusMessage message="An update is available" 
									  location="bottom" 
									  matchDurationToTextContent="true"
									  data="{'Current version: ' + updateApplication.currentVersion + '. Remote version: ' + updateApplication.remoteVersion}"/>
		&lt;/local:updateAvailableEffect>
		&lt;local:updateNotAvailableEffect>
			&lt;status:ShowStatusMessage message="An update is not available" location="top"/>
		&lt;/local:updateNotAvailableEffect>
		&lt;local:errorEffect>
			&lt;status:ShowStatusMessage showBusyIcon="false" 
									  data="{updateApplication.errorEvent}"
									  matchDurationToTextContent="true" duration="6000"
									  textAlignment="left"
									  useObjectUtilToString="true"/>
		&lt;/local:errorEffect>
	&lt;/local:UpdateApplication>
&lt;/handlers:EventHandler>
</pre>
 * Another example setting the update descriptor path, using UI and tracing all events in the console:
<pre>
&lt;handlers:EventHandler eventName="applicationComplete">
	&lt;local:UpdateApplication id="updateApplication"
							 traceEvents="true" 
							 useUI="true"
							 updateURL="http://www.mysite.com/updates/UpdateDescriptor.xml" 
							 >
		&lt;local:firstRunEffect>
			&lt;status:ShowStatusMessage message="First time run"/>
		&lt;/local:firstRunEffect>
		&lt;local:updateAvailableEffect>
			&lt;status:ShowStatusMessage message="An update is available" 
									  matchDurationToTextContent="true"
									  data="{'Current version: ' + updateApplication.currentVersion + '. Remote version: ' + updateApplication.remoteVersion}"/>
		&lt;/local:updateAvailableEffect>
		&lt;local:updateNotAvailableEffect>
			&lt;status:ShowStatusMessage message="An update is not available" location="top"/>
		&lt;/local:updateNotAvailableEffect>
		&lt;local:errorEffect>
			&lt;status:ShowStatusMessage showBusyIcon="false" 
									  data="{updateApplication.errorEvent}"
									  matchDurationToTextContent="true" duration="6000"
									  textAlignment="left"
									  useObjectUtilToString="true"/>
		&lt;/local:errorEffect>
	&lt;/local:UpdateApplication>
&lt;/handlers:EventHandler>
</pre>

 	 * 
	 * NOTE: When testing an application using the AIR Debug Launcher (ADL) application, attempting to update 
	 * the application results in a IllegalOperationError exception.<br/><br/>
	 * 
	 * <b>Notable Events:</b><br/> 
	 * StatusUpdateEvent.UPDATE_STATUS (updateEvent) — The updater has downloaded and interpreted the update 
	 * descriptor file successfully. This event has these properties:<br/><br/>
	 * 
	 * 	- available — A Boolean value. Set to true if there is a different version available than that 
	 * 		of the current application; false otherwise (the version is the same).<br/>
	 *  - version — A String. The version from the application descriptor file of the update file<br/>
	 *  - details — An Array. If there are no localized versions of the description, 
	 * 		this array returns an empty string ("") as the first element and the description as the second element.<br/><br/>
	 * 
	 * These properties are also set on this effect instance called remoteVersion, available, description and details.<br/><br/>
	 * 
	 * <b>Notable Errors:</b><br/>
	 * [StatusUpdateErrorEvent: (type=updateError text=Invalid HTTP status code: 404 id=16820 + subErrorID=404)]<br/>
	 * - The AIR application file is not found in the location specified in the URL tag in the 
	 * UpdateDescriptor.xml. Check the updateDescriptorPath property on the instance and verify it
	 * by copying it and pasting it into a browser. If the file starts to download 
	 * then it is the correct path. If not you may need to upload it to your server.<br/><br/>
	 * 
	 * [ErrorEvent type="error" Cannot update (from remote)" errorID=16828]<br/>
	 * - Cannot update application, usually because the application is running in the AIR Debug Launcher (ADL).<br/><br/>
	 * 
	 * [DownloadErrorEvent (type=downloadError text= id=16800 subErrorID=2032)]<br/>
	 * - Occurs during validating the downloaded update file. The subErrorID property may contain additional information.<br/>
	 * - Possibly because the application is running in the AIR Debug Launcher (ADL)?<br/><br/>
	 * 
	 * A list of additional error ID codes can be found here, http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/air/update/ApplicationUpdater.html#event:downloadError.
	 * <br/><br/>
	 * 
	 * More info - http://help.adobe.com/en_US/AIR/1.5/devappsflex/WS5b3ccc516d4fbf351e63e3d118666ade46-7ff2.html#WS5b3ccc516d4fbf351e63e3d118666ade46-7c57<br/><br/>
	 * 
	 * Badge installer - http://help.adobe.com/en_US/AIR/1.5/devappsflex/WS5b3ccc516d4fbf351e63e3d118666ade46-7e15.html#WS5b3ccc516d4fbf351e63e3d118666ade46-7c88<br/>
	 * Badge flashvars - 'flashvars','appname=MyApp&appurl=http://www.mysite.com/updates/MyApp_1.0.0.air&airversion=2.5&imageurl=badge_icon.png'
	 * */
	public class UpdateApplication extends ActionEffect {
		
		public static const FIRST_RUN:String = "firstRun";
		public static const INITIALIZE:String = "initialize";
		public static const UPDATE_AVAILABLE:String = "updateAvailable";
		public static const UPDATE_NOT_AVAILABLE:String = "updateNotAvailable";
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function UpdateApplication(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = UpdateApplicationInstance;
			
		}
		
		/**
		 * Reference to the ApplicationUpdater or ApplicationUpdaterUI object. You do not set this.
		 * */
		[Bindable]
		public var updater:Object;
		
		/**
		 * If you want to use the ApplicationUpdaterUI class (which provides a user interface), set this to true. 
		 * Default is true.
		 * */
		public var useUI:Boolean = true;
		
		/**
		 * A Number. Represents an interval of time given in days (values like 0.25 are allowed) for checking for updates. 
		 * A value of 0 (which is the default value) specifies that the updater does not perform an automatic periodical check.
		 * */
		public var delay:Number;
		
		/**
		 * Path to the config path. If your config file is in the root directory of 
		 * your project the path would be "app:/updateConfig.xml". 
		 * */
		public var configurationFilePath:String;
		
		/**
		 * Represents the location of the update descriptor on the remote server. Any valid URLRequest location is allowed. 
		 * Default is null. 
		 * */
		public var updateURL:String;
		
		/**
		 * Indicates if the Check for Update, No Update, and Update Error dialog boxes are visible
		 * @see #useUI
		 * */
		public var isCheckForUpdateVisible:Boolean = false;
		
		/**
		 * Indicates if the Download Update dialog box is visible
		 * @see #useUI
		 * */
		public var isDownloadUpdateVisible:Boolean = true;
		
		/**
		 * Indicates if the Download Progress and Download Error dialog boxes are visible
		 * @see #useUI
		 * */
		public var isDownloadProgressVisible:Boolean = true;
		
		/**
		 * Indicates if the Install Update dialog box is visible
		 * @see #useUI
		 * */
		public var isInstallUpdateVisible:Boolean = true;
		
		/**
		 * Indicates if the File Update, File No Update, and File Error dialog boxes are visible
		 * @see #useUI
		 * */
		public var isFileUpdateVisible:Boolean = true;
		
		/**
		 * Indicates if the Unexpected Error dialog box is visible
		 * @see #useUI
		 * */
		public var isUnexpectedErrorVisible:Boolean = true;
		
		/**
		 * Contains the current state of the updater. This only works when
		 * the NOT showing the ApplicationUpdater UI. In other words if useUI is false. 
		 * Valid values are:<br/><br/>
		 * 
		 * "UNINITIALIZED"—The updater has not been initialized.<br/> 
		 * "INITIALIZING"—The updater is initializing.<br/> 
		 * "READY"—The updater has been initialized<br/> 
		 * "BEFORE_CHECKING"—The updater has not yet checked for the update descriptor file.<br/> 
		 * "CHECKING"—The updater is checking for an update descriptor file.<br/> 
		 * "AVAILABLE"—The updater descriptor file is available.<br/> 
		 * "DOWNLOADING"—The updater is downloading the AIR file.<br/> 
		 * "DOWNLOADED"—The updater has downloaded the AIR file.<br/> 
		 * "INSTALLING"—The updater is installing the AIR file.<br/> 
		 * "PENDING_INSTALLING"—The updater has initialized and there are pending updates.<br/>
		 * 
		 * @see useUI 
		 * */
		[Bindable]
		public var currentState:String;
		
		/**
		 * A function that the updater should use to perform version comparisons. 
		 * By default, the update framework does a version comparison to detect whether the 
		 * version from the remote site is newer than the version of the installed application. 
		 * However, sometimes the default comparison does not match the developer's versioning scheme. 
		 * Set this property to provide a new function that does the comparison.<br/><br/>
		 * 
		 * The default comparision function accepts versions like x.y.z, where x, y, and z can contain 
		 * letters and digits. There are some special conditions that the default comparision function 
		 * recognizes. If the test function finds "alpha", "beta", or "rc" in the version strings, the 
		 * order is alpha < beta < rc.
<pre>
public function customFunction (currentVersion:String, updateVersion:String):Boolean 
{
    return updateVersion > currentVersion;
}
</pre>
		 * */
		public var versionCompareFunction:Function;
		
		private var _currentVersion:String;

		[Bindable]
		/**
		 * Contains the current version of your application. 
		 * You do not set this it is set when this effect is run
		 * */
		public function get currentVersion():String {
			if (!_currentVersion) {
				var definition:Object = ClassUtils.getDefinition("flash.desktop.NativeApplication");
				
				if (definition) {
			    	var appXML:XML = definition.nativeApplication.applicationDescriptor;
			    	var ns:Namespace = appXML.namespace();
			    	var version:String = appXML.versionNumber;
			    	_currentVersion = appXML.ns::versionNumber;
				}
			}
			
			return _currentVersion;
		}

		/**
		 * @private
		 */
		public function set currentVersion(value:String):void {
			_currentVersion = value;
		}

		
		/**
		 * The previous version of the application. This property is set during a call 
		 * to the initialize() method. Returns the previous version of the application 
		 * before the upgrade (set only if isfirstRun is true); otherwise it is set to null. 
		 * You do not set this it is set when this effect is run.
		 * */
		[Bindable]
		public var previousVersion:String;
		
		/**
		 * The content of the update descriptor file downloaded from the update URL. 
		 * This property is non-null only the updater object dispatches an updateStatus event. 
		 * */
		[Bindable]
		public var updateDescriptor:XML;
		
		/**
		 * Contains the error number if an error was thrown. 
		 * You do not set this it is set when this effect is run.
		 * @copy air.update.ApplicationUpdater#errorID
		 * */
		[Bindable]
		public var errorID:int;
		
		/**
		 * Contains the error text if an error was thrown. 
		 * You do not set this it is set when this effect is run.
		 * */
		[Bindable]
		public var errorText:String;
		
		/**
		 * Contains the error event if an error was thrown. 
		 * You do not set this it is set when this effect is run.
		 * Can be of type air.update.events.StatusUpdateErrorEvent.FILE_UPDATE_ERROR<br/>
		 * air.update.events.StatusUpdateErrorEvent.UPDATE_ERROR<br/>
		 * or flash.events.ErrorEvent.ERROR
		 * */
		[Bindable]
		public var errorEvent:Event;
		
		/**
		 * This value is true if there was a previous pending update. 
		 * You do not set this it is set when this effect is run.
		 * @copy air.update.ApplicationUpdater#wasPendingUpdate
		 * */
		[Bindable]
		public var wasPendingUpdate:Boolean;
		
		/**
		 * The version mentioned in the remote update descriptor file.
		 * */
		[Bindable]
		public var remoteVersion:String;
		
		/**
		 * The version label value mentioned in the remote update descriptor file.
		 * */
		[Bindable]
		public var versionLabel:String;
		
		/**
		 * The description mentioned in the remote update descriptor file.
		 * This is set when the update descriptor is loaded from the server.
		 * */
		[Bindable]
		public var versionDescription:String;
		
		/**
		 * The url to the AIR application file mentioned in the remote update descriptor file.
		 * This is set when the update descriptor is loaded from the server.
		 * */
		[Bindable]
		public var versionURL:String;
		
		/**
		 * Contains details about the update
		 * */
		public var versionDetails:Array;
		
		/**
		 * Indicates an update is available. Set to true if available or false otherwise.
		 * Default is null
		 * @see remoteVersion
		 * @see updateAvailableEffect
		 * @see updateNotAvailableEffect
		 * */
		[Bindable]
		public var isUpdateAvailable:Object;
		
		/**
		 * Effect that is played if on initialized event
		 * */
		public var initializedEffect:Effect;
		
		/**
		 * Effect that is played if error event
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Effect that is played if on first run
		 * */
		public var firstRunEffect:Effect;
		
		/**
		 * Effect that is played if a pending update was available
		 * */
		public var pendingUpdateEffect:Effect;
		
		/**
		 * Effect that is played on status update event
		 * */
		public var statusUpdateEffect:Effect;
		
		/**
		 * Effect that is played when an update is available
		 * @see remoteVersion
		 * @see updateAvailable
		 * */
		public var updateAvailableEffect:Effect;
		
		/**
		 * Effect that is played when an update is not available
		 * @see remoteVersion
		 * @see updateAvailable
		 * */
		public var updateNotAvailableEffect:Effect;
		
		/**
		 * Prevents the update if a new version is available. 
		 * This is for when you want to check if a new version is available
		 * but require the users to login to download or perform an update.
		 * */
		public var cancelBeforeUpdate:Boolean;
		
	}
}
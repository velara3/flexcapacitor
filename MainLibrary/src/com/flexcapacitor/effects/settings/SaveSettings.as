

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.SaveSettingsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.SharedObject;
	
	import mx.effects.Effect;
	
	/**
	 * Event when there is an error during save
	 * */
	[Event(name="error", type="flash.events.Event")]

	/**
	 * Event when save is successful
	 * */
	[Event(name="saved", type="flash.events.Event")]
	
	/**
	 * Event when save is pending
	 * 
	 * */
	[Event(name="pending", type="flash.events.Event")]

	/**
	 * Saves a object or some of an objects name and values to disk using Shared Objects. <br/><br/>
	 * 
	 * You can give it an existing object and list a set of properties and 
	 * it will create an new object with the properties you listed and 
	 * copy the values from the existing object and then save it to disk. <br/><br/>
	 * 
	 * The saveImmediately option saves the data immediately rather than the 
	 * default which is to defer it until the browser or application closes.<br/><br/>
	 *  
	 * The localPath property is the path to the shared object. 
	 * By default this value is null. <br/><br/>
	 * 
	 * The propertiesStatus indicates if the properties listed to be included or excluded. 
	 * By default this is "inclusive". <br/><br/>
	 * 
	 * <b>Usage:</b><br/>
	 * 
	 * The following example saves the value "Hello world" to the shared object, "general" and saves 
	 * it immediately. 
 * <pre>
 * &ltSaveSettings data="Hello World" name="general" saveImmediately="true" />
 * </pre>
	 * 
	 * The following example saves an object to the shared object named, "user" with the 
	 * properties, "name" and "age". 
 * <pre>
 * &ltObject id="person" name="John" age="30" weight="160" />
 * 
 * &ltSaveSettings name="user" data="{person}" propertiesStatus="inclusive" saveImmediately="true">
 * 	&ltproperties>
 * 		&ltArray>
 * 			&ltString>name&lt/String>
 * 			&ltString>age&lt/String>
 * 		&lt/Array>
 * 	&lt/properties>
 * &lt/SaveSettings>
 * </pre>
	 * 
	 * Using the example above, you can later retrieve the shared object 
	 * with the name, "user" and it will return an object with the properties, 
	 * "name" and "age" and values "John" and "30" respectively.
	 * 
	 * To get the settings:
<pre>
	&lt;settings:GetSettings id="settings" name="user" traceDataToConsole="true">
		&lt;settings:valueNotSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Shared object not found with that name"/>
			&lt;/s:Sequence>
		&lt;/settings:valueNotSetEffect>
		&lt;settings:valueSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Shared object found {settings.data}"/>
			&lt;/s:Sequence>
		&lt;/settings:valueSetEffect>
		&lt;settings:errorEffect>
			&lt;s:Sequence >
				&lt;status:ShowStatusMessage message="Error getting settings"
										  location="bottom"
										  data="{getSettings.errorEvent}"
										  textAlignment="left"/>
			&lt;/s:Sequence>
		&lt;/settings:errorEffect>
	&lt;/settings:GetSettings>
</pre>
	 * For errors see http://www.actionscripterrors.com/?p=806
	 * 
 	 * @see SaveSetting
 	 * @see GetSetting
 	 * @see GetSettings
	 * @see RemoveSetting
	 * */
	public class SaveSettings extends ActionEffect {
		
		public static const ERROR:String = "error";
		public static const SAVED:String = "saved";
		public static const PENDING:String = "pending";
		
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
		public function SaveSettings(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = SaveSettingsInstance;
			
		}
		
		
		/**
		 * Reference to the shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of the setting.
		 * */
		public var name:String = "general";
		
		/**
		 * Name of local path. Optional. 
		 * The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
		 *  
		 * The value is passed in to getLocal()<br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * If this parameter is set to true, creates a new secure settings file 
		 * (ie shared object) or gets a reference to an existing secure shared object. 
		 * 
		 * If your SWF file is delivered over a non-HTTPS connection and you try to set 
		 * this parameter to true, the creation of a new shared object (or the access of 
		 * a previously created secure shared object) fails and null is returned. <br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var secure:Boolean;
		
		/**
		 * Saves the settings immediately. Locally persistent shared object equals setting. <br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var saveImmediately:Boolean = true;
		
		/**
		 * Minimum amount of space in bytes to request when more space is needed. 
		 * Default is 0.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var minimumSettingsSpace:int;
		
		/**
		 * Should contain an object with key value pairs to be saved as settings.
		 * Use the properties array to specify what properties on this object
		 * to use if not using all of them (default). 
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * List of properties on the data object to include or exclude.
		 * */
		[Bindable]
		public var properties:Array = [];
		
		/**
		 * Defines if the names of the properties set in the properties array 
		 * are inclusive or exclusive. Default is inclusive.
		 * */
		public var propertiesStatus:String = "inclusive";
		
		/**
		 * If an error occurs it contains the error event
		 * Typed as Object because error could cause Error or Event
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		[Bindable]
		public var errorEvent:Object;
		
		/**
		 * Effect to play when the save is pending. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var pendingEffect:Effect;
		
		/**
		 * Effect to play when the save is successful. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var savedEffect:Effect;
		
		/**
		 * Effect to play when an error during save occurs. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
	}
}
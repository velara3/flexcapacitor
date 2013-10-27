

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.GetSettingsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.SharedObject;
	
	import mx.effects.Effect;
	
	/**
	 * Event dispatched when the group with the name given is set
	 * */
	[Event(name="valueSet", type="flash.events.Event")]

	/**
	 * Event dispatched when the setting group with the name given 
	 * is not set or null
	 * */
	[Event(name="valueNotSet", type="flash.events.Event")]
	
	/**
	 * Event when there is an error during save
	 * */
	[Event(name="error", type="flash.events.Event")]

	/**
	 * Gets all settings by name. This uses Shared Objects to save data. <br/><br/>
	 * 
	 * If a shared objects exists by the name given the valueSetEffect is run 
	 * and the data from the shared object is placed in the data property. 
	 * If a shared object does not exist or the data in it is null 
	 * the valueNotSetEffect is run. <br/><br/>
	 * 
	 * All of the properties on the shared object are placed in the properties array. <br/><br/>
	 * 
	 * The localPath is the path to the shared object. This can be null, "/" or another value.<br/><br/> 
	 * 
	 * <b>Usage<b><br/>

	 * The following example saves an object to the shared object named, "user" with the 
	 * properties, "name" and "age". 
	 * 
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
	&lt;settings:GetSettings id="getSettings" name="user" traceDataToConsole="true">
		&lt;settings:valueNotSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Shared object not found with that name"/>
			&lt;/s:Sequence>
		&lt;/settings:valueNotSetEffect>
		&lt;settings:valueSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Shared object found" data="{getSettings.data}"/>
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
	 * 
	 * For errors see http://www.actionscripterrors.com/?p=806
	 * 
	 * <br/><br/>
 	 * @see GetSetting
 	 * @see SaveSetting
 	 * @see SaveSettings
	 * @see RemoveSetting
	 * */
	public class GetSettings extends ActionEffect {
		
		/**
		 * Name of event dispatched when an error occurs
		 * */
		public static const ERROR:String = "error";
		
		/**
		 * Name of event dispatched when value is null
		 * */
		public static const VALUE_NOT_SET:String = "valueNotSet";
		
		/**
		 * Name of event dispatched when value is not null
		 * */
		public static const VALUE_SET:String = "valueSet";
		
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
		public function GetSettings(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = GetSettingsInstance;
			
		}
		
		
		/**
		 * Reference to the shared object<br/>
		 * @copy flash.net.SharedObject
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of the settings. Required. Cannot contain spaces. 
		 * */
		public var name:String;
		
		/**
		 * Optional. Default is null. 
		 * Required. The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
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
		 * a previously created secure shared object) fails and null is returned. <br/><br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var secure:Boolean;
		
		/**
		 * Group of settings. You do not set this. 
		 * If the group is not set then this value is null and the 
		 * valueNotSet effect is played (and the valueNotSet event is dispatched).
		 * If the value is not null then the valueSet effect is played and 
		 * the valueSet event is dispatched. 
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * If true then no error is thrown when the name is not set. 
		 * */
		public var allowNullName:Boolean;
		
		/**
		 * List of properties in the group
		 * */
		[Bindable]
		public var properties:Array;
		
		/**
		 * Trace the settings properties to the console
		 * */
		public var traceDataToConsole:Boolean;
		
		/**
		 * Reference to error event when a shared object error event occurs.
		 * */
		[Bindable]
		public var errorEvent:Object;
		
		/**
		 * Effect to play when an error occurs when attempting to get the settings. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Effect to play when the group is null. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var valueNotSetEffect:Effect;
		
		/**
		 * Effect to play when the group is not null
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var valueSetEffect:Effect;
		
	}
}
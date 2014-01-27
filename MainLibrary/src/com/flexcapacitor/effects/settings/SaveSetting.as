

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.SaveSettingInstance;
	import com.flexcapacitor.effects.settings.supportClasses.SettingsDefault;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
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
	 * Saves a setting to disk. This uses Shared Objects to save the setting value.<br/><br/>
	 * 
	 * The saveImmediately option saves the data immediately rather than the 
	 * default which is to defer it until the browser or application closes.<br/><br/>
	 *  
	 * The localPath property is the path to the shared object. 
	 * By default this value is null. <br/><br/>
	 * 
	 * <b>Usage:</b><br/>
	 * To save a score for a game use the following. 
<pre>
&ltsettings:SaveSetting name="MyGameSettings" 
					  property="score" 
					  data="1000" >
	&ltsettings:savedEffect>
		&ltstatus:ShowStatusMessage message="Value is was saved successfully"/>
	&lt/settings:savedEffect>
	&ltsettings:pendingEffect>
		&ltstatus:ShowStatusMessage message="Value will be saved on exit"/>
	&lt/settings:pendingEffect>
	&ltsettings:errorEffect>
		&ltstatus:ShowStatusMessage message="An error occured when attempting to save!"/>
	&lt/settings:errorEffect>
&lt/settings:SaveSetting>
</pre>
 * 
	 * To get that setting later use:
<pre>
&lt;settings:GetSetting id="getSetting" name="MyGameSettings" property="score" traceDataToConsole="true">
	&lt;settings:valueNotSetEffect>
		&lt;debugging:Trace message="No settings available"/>
	&lt;/settings:valueNotSetEffect>
	&lt;settings:valueSetEffect>
		&lt;debugging:Trace message="Settings found." data="{getSetting.data}"/>
	&lt;/settings:valueSetEffect>
	&lt;settings:errorEffect>
		&lt;status:ShowStatusMessage message="An error occured when attempting to get settings" data="{getSetting.errorEvent}"/>
	&lt;/settings:errorEffect>
&lt;/settings:GetSetting>
</pre>
	 * 
	 * See <a href="http://www.actionscripterrors.com/?p=806" target="_blank">http://www.actionscripterrors.com/?p=806</a> for more information on errors. 
	 * 
	 * @see SaveSettings
	 * @see GetSetting
	 * @see GetSettings
	 * @see RemoveSetting
	 * */
	public class SaveSetting extends ActionEffect {
		
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
		public function SaveSetting(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = SaveSettingInstance;
			
		}
		
		
		/**
		 * Reference to the shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of setting. Required.
		 * */
		public var name:String = SettingsDefault.DEFAULT_NAME;
		
		/**
		 * Property on the saved data object. Optional. 
		 * */		
		public var property:String;
		
		/**
		 * Optional.Default is general. 
		 * Required. The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
		 *  
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * Value of setting. Required.
		 * To remove a setting use remove setting. 
		 * */
		[Bindable]
		public var data:Object;
		
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
		 * Saves the setting. Locally persistent shared object equals setting. <br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var applyImmediately:Boolean = true;
		
		/**
		 * Value can be null or empty.
		 * */
		public var valueCanBeNull:Boolean = true;
		
		/**
		 * Minimum amount of space in bytes to request when more space is needed. 
		 * Default is 0.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var minimumSettingsSpace:int;
		
		/**
		 * Reference to AsyncErrorEvent when an AsyncError event occurs.
		 * */
		[Bindable]
		public var asyncErrorEvent:AsyncErrorEvent;
		
		/**
		 * Reference to NetStatusEvent when an NetStatus event occurs.
		 * */
		[Bindable]
		public var netStatusEvent:NetStatusEvent;
		
		/**
		 * Reference to error event when a shared object error event occurs.
		 * */
		[Bindable]
		public var errorEvent:Object;
		
		/**
		 * Object encoding. Default is ObjectEncoding.AMF3
		 * */
		public var objectEncoding:uint = ObjectEncoding.AMF3;
		
		/**
		 * Trace the shared object data to the console
		 * */
		public var traceDataToConsole:Boolean;
		
		/**
		 * Removes property or setting when the data supplied is null. 
		 * Default is to set the property or data to an empty string.
		 *  
		 * @see RemoveSetting
		 * */
		public var removeSettingWhenDataIsNull:Boolean;
		
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
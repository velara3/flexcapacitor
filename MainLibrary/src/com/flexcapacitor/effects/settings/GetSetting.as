

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.GetSettingInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	import mx.effects.Effect;
	
	/**
	 * Event dispatched when the value is set (as opposed to being null)
	 * */
	[Event(name="valueSet", type="flash.events.Event")]

	/**
	 * Event dispatched when the value is not set or null
	 * */
	[Event(name="valueNotSet", type="flash.events.Event")]
	
	/**
	 * Event when there is an error during save
	 * */
	[Event(name="error", type="flash.events.Event")]

	/**
	 * Gets a setting previously saved on clients disk. 
	 * This uses Shared Objects to get the setting value. 
	 * The group option is also the path to the shared object. <br/><br/>
	 * 
	 * Usage:
<pre>
	&lt;settings:GetSetting id="initialViewSetting" name="initialView" traceDataToConsole="true">
		&lt;settings:valueNotSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Initial view not found"/>
			&lt;/s:Sequence>
		&lt;/settings:valueNotSetEffect>
		&lt;settings:valueSetEffect>
			&lt;s:Sequence>
				&lt;debugging:Trace message="Initial view found {initialViewSetting.data}"/>
				&lt;states:ChangeStates target="{this}" state="{initialViewSetting.data}"/>
			&lt;/s:Sequence>
		&lt;/settings:valueSetEffect>
	&lt;/settings:GetSetting>
</pre>
	 * */
	public class GetSetting extends ActionEffect {
		
		/**
		 * Name of event dispatched when value is null
		 * */
		public static var VALUE_NOT_SET:String = "valueNotSet";
		
		/**
		 * Name of event dispatched when value is not null
		 * */
		public static var VALUE_SET:String = "valueSet";
		
		/**
		 * Name of event dispatched when an error occurs
		 * */
		public static const ERROR:String = "error";
		
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
		public function GetSetting(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = GetSettingInstance;
			
		}
		
		
		/**
		 * Reference to the shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of group for the setting. Default is general. 
		 * Required. The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
		 *  
		 * The group name equals the name passed in to getLocal()<br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var group:String = "general";
		
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
		 * Name of setting. Required.
		 * */
		public var name:String;
		
		/**
		 * Value of setting. You do not set this. 
		 * If the setting is null then this value is null and the 
		 * valueNotSet effect is played and the valueNotSet event is dispatched.
		 * If the value is not null then the valueSet effect is played and 
		 * the valueSet event is dispatched. 
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * Effect to play when an error occurs when attempting to get a setting. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Effect to play when the value is null 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var valueNotSetEffect:Effect;
		
		/**
		 * Effect to play when the value is not null
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var valueSetEffect:Effect;
		
		/**
		 * Optional.
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * Reference to AsyncErrorEvent when an AsyncError event occurs.
		 * */
		public var asyncErrorEvent:AsyncErrorEvent;
		
		/**
		 * Reference to NetStatusEvent when an NetStatus event occurs.
		 * */
		public var netStatusEvent:NetStatusEvent;
		
		/**
		 * Reference to error event when a shared object error event occurs.
		 * */
		public var errorEvent:Object;
		
		/**
		 * Object encoding. Default is ObjectEncoding.AMF3
		 * */
		public var objectEncoding:uint = ObjectEncoding.AMF3;
		
		/**
		 * Trace the shared object data to the console
		 * */
		public var traceDataToConsole:Boolean;
		
	}
}
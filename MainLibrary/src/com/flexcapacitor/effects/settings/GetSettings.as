

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
	 * Gets all settings by group name. 
	 * If the group exists the data property will be set to the group and the
	 * properties property will be set name of the settings in the group.
	 * If the group is set the valueSetEffect is run. If the group is not 
	 * set the valueNotSetEffect is run. 
	 * 
	 * This uses Shared Objects to get the settings data. 
	 * The group option is the path to the shared object. 
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
		 * Reference to the shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of group for the settings. Default is general. 
		 * Required. The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
		 *  
		 * The group name equals the name passed in to getLocal()<br/><br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var name:String = "general";
		
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
		
		/**
		 * Optional.
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * List of properties in the group
		 * */
		public var properties:Array;
		
		/**
		 * Trace the settings properties to the console
		 * */
		public var traceDataToConsole:Boolean;
		
	}
}
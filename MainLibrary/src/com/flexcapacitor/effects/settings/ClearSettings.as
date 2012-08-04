

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.ClearSettingsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.SharedObject;
	
	import mx.effects.Effect;

	/**
	 * Gets a setting previously saved on clients disk. 
	 * This uses Shared Objects to get the setting value. 
	 * The group option is also the path to the shared object. 
	 * */
	public class ClearSettings extends ActionEffect {
		
		
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
		public function ClearSettings(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = ClearSettingsInstance;
			
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
		 * nullValue effect is played and the nullValue event is dispatched.
		 * If the value is not null then the valueSet effect is played and 
		 * the valueSet event is dispatched. 
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * Effect to play when an error occurs when attempting to clear a setting. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Optional.
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
	}
}


package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.RemoveSettingInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.SharedObject;
	
	import mx.effects.Effect;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	
	
	/**
	 * Event when there is an error during remove
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Event when a setting was removed successfully
	 * */
	[Event(name="removed", type="flash.events.Event")]
	
	/**
	 * Event when save is pending
	 * 
	 * */
	[Event(name="pending", type="flash.events.Event")]

	/**
	 * Removes a setting previously saved to disk
	 * This abstracts the Shared Object class. 
	 * The group option is another name for shared object path. 
	 * */
	public class RemoveSetting extends ActionEffect {
		
		public static const ERROR:String = "error";
		public static const REMOVED:String = "removed";
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
		public function RemoveSetting(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = RemoveSettingInstance;
			
		}
		
		/**
		 * Applies the remove immediately.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var applyImmediately:Boolean = true;
		
		
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
		 * Effect to play when an error occurs when attempting to remove a setting. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Optional.
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * Effect to play when the remove is pending. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var pendingEffect:Effect;
		
		/**
		 * Effect to play when the remove is successful. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var removedEffect:Effect;
		
		/**
		 * Minimum amount of space in bytes to request when more space is needed. 
		 * Default is 0.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var minimumSettingsSpace:int;
		public var errorEvent:Object;
		public var netStatusEvent:NetStatusEvent;
		public var asyncErrorEvent:AsyncErrorEvent;
		
	}
}
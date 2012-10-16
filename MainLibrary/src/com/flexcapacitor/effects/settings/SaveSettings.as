

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.SaveSettingsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.events.Event;
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
	 * Saves a setting to the client disk. This uses Shared Objects to save the setting
	 * value. The group option is also the path to the shared object. 
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
		 * Name of group for setting. Default is general. 
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
		 * Saves the setting. Locally persistent shared object equals setting. <br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var save:Boolean = true;
		
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
		
		/**
		 * Minimum amount of space in bytes to request when more space is needed. 
		 * Default is 0.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var minimumSettingsSpace:int;
		
		/**
		 * Optional.
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * If an error occurs it contains the error event
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var errorEvent:Event;
		
		/**
		 * Should contain an object with key value pairs to be saved as settings.
		 * Use the properties array to specify what properties on this object
		 * to use if not using all of them (default). 
		 * */
		public var data:Object;
		
		/**
		 * List of properties on the data object to include or exclude.
		 * */
		public var properties:Array = [];
		
		/**
		 * Defines if the names of the properties set in the properties array 
		 * are inclusive or exclusive. Default is inclusive.
		 * */
		public var propertiesStatus:String = "inclusive";
	}
}
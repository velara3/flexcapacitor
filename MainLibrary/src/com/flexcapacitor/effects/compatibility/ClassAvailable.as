

package com.flexcapacitor.effects.compatibility {
	
	import com.flexcapacitor.effects.compatibility.supportClasses.ClassAvailableInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when the class specified IS found.
	 * A reference to the class is placed in the classReference 
	 * property on the effect class.
	 * 
	 * The default action is to move to the next effect if the 
	 * class is found. 
	 * */
	[Event(name="classFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the class specified is NOT found. 
	 * The default action when the class is not found is to play 
	 * the classNotFoundEffect if defined.
	 * */
	[Event(name="classNotFound", type="flash.events.Event")]
	
	/**
	 * Checks if the class is available in the current application domain
	 * */
	public class ClassAvailable extends ActionEffect {
		
		/**
		 * Event name constant when class is found.
		 * */
		public static const CLASS_FOUND:String = "classFound";
		
		/**
		 * Event name constant when class is NOT found.
		 * */
		public static const CLASS_NOT_FOUND:String = "classNotFound";
		
		
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
		public function ClassAvailable(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ClassAvailableInstance;
			
		}
		
		/**
		 * Name of class to check for. For example, "flash.media.CameraRoll".
		 * The name of the class is searched for in the application domain. 
		 * */
		public var classDefinition:String;
		
		/**
		 * Effect that is played if defined if class is NOT found.
		 * */
		public var classNotFoundEffect:Effect;
		
		/**
		 * Reference to the class if it was found
		 * */
		public var classReference:Class;
		
		/**
		 * Effect that is played if defined if class is found.
		 * */
		public var classFoundEffect:Effect;
		
	}
}
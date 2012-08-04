

package com.flexcapacitor.effects.display {
	
	import com.flexcapacitor.effects.display.supportClasses.ShowElementInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Shows a display object. 
	 * Same as setting visible to true but allows include in layout 
	 * */
	public class ShowElement extends ActionEffect {
		
		
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
		public function ShowElement(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ShowElementInstance;
		}
		
		/**
		 * Prevents the element from being included in the layout
		 * */
		[Inspectable(enumeration="true,false")]
		public var includeInLayout:String;
		
		/**
		 * When set to true the element is shown. You can set this to false 
		 * to only apply include in layout. 
		 * Default is true.
		 * */
		public var display:Boolean = true;
		
	}
}
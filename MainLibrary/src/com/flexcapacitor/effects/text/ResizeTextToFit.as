

package com.flexcapacitor.effects.text {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.effects.text.supportingClasses.ResizeTextToFitInstance;
	
	import mx.core.IInvalidating;
	
	
	/**
	 * Resizes a Text component to fit a fixed pixel width or height by 
	 * lowering the font size. 
	 * 
	 * Set the desired font size as the max font size. 
	 * */
	public class ResizeTextToFit extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 **/
		public function ResizeTextToFit(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = ResizeTextToFitInstance;
		}
		
		/**
		 * The max width of the label
		 * */
		public var maxWidth:int;
		
		/**
		 * The max width of the label
		 * */
		public var maxHeight:int;
		
		/**
		 * Padding to subtract from the max width value
		 * */
		public var padding:int;
		
		/**
		 * The max width of the label
		 * */
		public var desiredFontSize:Number;
		
		/**
		 * The owner of the text component. Usually it's component.owner, component.parent or this.
		 * */
		public var textComponentOwner:IInvalidating;
		
		/**
		 * Minimum font size
		 * */
		public var minimumFontSize:Number = 6;
		
		/**
		 * Amount to subtract from the existing font size per step when reducing the font size
		 * */
		public var stepSize:int = 3;
	}
}
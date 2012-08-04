

package com.flexcapacitor.effects.view {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.effects.view.supportClasses.RemoveViewInstance;
	
	import spark.transitions.ViewTransitionBase;

	/**
	 * Removes the target view from the view stack. 
	 * If the previous view looks like it's been recreated it probably was.
	 * Set the destruction policy on it to never to preserve it.
	 *  @copy spark.components.ViewNavigator#popView()
	 * */
	public class RemoveView extends ActionEffect {
		
		
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
		public function RemoveView(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = RemoveViewInstance;
			
		}
		
		
		/**
		 * The type of transition to play while switching views.
		 * The transition is applied to the previous view 
		 * Optional. Default is slide, flip, zoom, crossFade 
		 * */
		[Inspectable(enumeration="slide,flip,zoom,crossFade")]
		public var transitionType:String = "slide";
		
		/**
		 * The duration of the transition if defined.  
		 * */
		public var transitionDuration:int = -1;
		
		/**
		 * The mode of the transition if defined. Be default it's cover. 
		 * Slide - cover, push, uncover
		 * Zoom - in, out
		 * Flip - card, cube 
		 * Optional. 
		 * @see FlipViewTransitionMode
		 * @see SlideViewTransition
		 * @see ZoomViewTransition
		 * */
		public var transitionMode:String = "cover";
		
		/**
		 * The direction of the transition if defined. Be default it's slide uncover.
		 * Directions are left, right, down, up 
		 * Slide - cover, push, uncover
		 * Zoom - in, out
		 * Flip - card, cube 
		 * Optional. 
		 * @see FlipViewTransitionMode
		 * @see SlideViewTransition
		 * @see ZoomViewTransition
		 * */
		public var transitionDirection:String = "right";
		
		/**
		 * Used with the ZoomViewTransition. Optional. 
		 * @copy spark.transitions.ZoomViewTransition#minimumScale
		 * */
		public var minimumScale:Number = .25;
		
		
		/**
		 * Transition override. Let's you pass in your own transition. Optional. 
		 * */
		public var transition:ViewTransitionBase;
		
	}
}
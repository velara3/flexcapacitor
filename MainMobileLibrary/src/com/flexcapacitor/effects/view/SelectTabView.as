

package com.flexcapacitor.effects.view {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.effects.view.supportClasses.SelectTabViewInstance;
	
	import spark.components.View;
	import spark.effects.easing.IEaser;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.ViewTransitionBase;
	
	/**
	 *  @copy spark.components.TabbedViewNavigator
	 * */
	public class SelectTabView extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function SelectTabView(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = SelectTabViewInstance;
			
		}
		
		/**
		 * The class used to create the view. Required.
		 * This argument must reference a class that extends View container.
		 * */
		public var destinationViewClass:Class;
		
		/**
		 * An arbitrary object written to 
		 * the <code>ViewNavigator.context</code> property. 
		 * When the new view is created, it can reference this property 
		 * and perform an action based on its value. 
		 * For example, the view could display data in different ways based 
		 * on the value of <code>context</code>.
		 * Optional.
		 * */
		public var context:Object;
		
		/**
		 * The data object to pass to the view. 
		 * This argument is written to the <code>data</code> property of the new view.
		 * Optional
		 * */
		public var data:Object;
		
		/**
		 * The view transition to play while switching views. 
		 * Optional. ViewTransitionBase
		 * NOT IMPLEMENTED (possible memory leak)
		 * */
		public var transition:ViewTransitionBase;
		
		/**
		 * The type of transition to play while switching views. 
		 * Optional. Default is slide.
		 * slide, flip, zoom, crossFade 
		 * */
		[Inspectable(enumeration="slide,flip,zoom,crossFade")]
		public var transitionType:String;
		
		/**
		 * The mode of transition 
		 * Optional. 
		 * */
		[Inspectable(enumeration="card,cube,push,cover,uncover,in,out")]
		public var transitionMode:String;
		
		/**
		 * The direction of transition 
		 * Optional. 
		 * */
		[Inspectable(enumeration="up,down,left,right")]
		public var transitionDirection:String;
		
		/**
		 * The duration of transition 
		 * Optional. 
		 * */
		public var transitionDuration:int;
		
		/**
		 * The easer of transition 
		 * Optional. 
		 * */
		public var transitionEaser:IEaser;
		
		/**
		 * The start view. By default this value is not stored.
		 * NOT IMPLEMENTED (possible memory leak)
		 * */
		public var startView:View;
		
		/**
		 * The end view.
		 * NOT IMPLEMENTED (possible memory leak)
		 * */
		public var endView:View;
		
		/**
		 * @copy spark.components.TabbedViewNavigator#selectedIndex
		 * */
		public var selectedIndex:int = -1;
		
		/**
		 * Target must be a view or view navigator
		 * */
		override public function set target(value:Object):void {
			super.target = value;
		}
		
	}
}


package com.flexcapacitor.effects.view.supportClasses {
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.view.OpenView;
	import com.flexcapacitor.transitions.FlipViewTransition;
	import com.flexcapacitor.transitions.FlipViewTransitionMode;
	import com.flexcapacitor.transitions.ZoomViewTransition;
	import com.flexcapacitor.transitions.ZoomViewTransitionMode;
	
	import mx.core.mx_internal;
	
	import spark.components.View;
	import spark.components.ViewNavigator;
	import spark.transitions.CrossFadeViewTransition;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.SlideViewTransitionMode;
	import spark.transitions.ViewTransitionBase;
	
	use namespace mx_internal;
	
	/**
	 * @copy OpenView
	 * */  
	public class OpenViewInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function OpenViewInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play(); // dispatch startEffect
			
			var action:OpenView = OpenView(effect);
			var transition:ViewTransitionBase = action.transition;
			var destinationViewClass:Class = action.destinationViewClass;
			var transitionType:String = action.transitionType;
			var transitionMode:String = action.transitionMode;
			var transitionDirection:String = action.transitionDirection;
			var transitionDuration:int = action.transitionDuration;
			var minimumScale:Number = action.minimumScale;
			var navigator:ViewNavigator;
			var removePreviousViews:Boolean = action.removePreviousViews;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!destinationViewClass) { 
					errorMessage = "View class is required";
					dispatchErrorEvent(errorMessage);
				}
				
				if (!target) { 
					errorMessage = "Target is required";
					dispatchErrorEvent(errorMessage);
				}
				
				if (!(target is View) 
					&& !(target is ViewNavigator)) {
					dispatchErrorEvent("Target must be a View or ViewNavigator");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// Since view transitions can temporarily alter the display tree, we
			// need to end all view transitions so that the display tree is restored
			// to a correct state.
			ViewTransitionBase.endTransitions();
			
			
			
			if (!transition && transitionType) {
				if (transitionType=="flip") {
					transition = new FlipViewTransition();
					FlipViewTransition(transition).mode = transitionMode || FlipViewTransitionMode.CUBE;;
				}
				else if (transitionType=="slide") {
					transition = new SlideViewTransition();
					SlideViewTransition(transition).mode = transitionMode || SlideViewTransitionMode.UNCOVER;
					SlideViewTransition(transition).direction = transitionDirection;
				}
				else if (transitionType=="zoom") {
					transition = new ZoomViewTransition();
					ZoomViewTransition(transition).mode = transitionMode || ZoomViewTransitionMode.OUT;
					ZoomViewTransition(transition).minimumScale = minimumScale;
				}
				else if (transitionType=="crossFade") {
					transition = new CrossFadeViewTransition();
				}
				// more options are available but not enough time to add now
			}
			
			// set the transition duration
			if (transition && transitionDuration!=-1) {
				transition.duration = transitionDuration;
			}
			
			// get navigator
			if (target is View) {
				navigator = View(target).navigator;
			}
			else if (target is ViewNavigator) {
				navigator = ViewNavigator(target);
			}
			
			if (removePreviousViews) {// provide be separate effect
				navigator.popAll();
			}
			
			navigator.pushView(destinationViewClass, action.data, action.context, transition);
			
			// if view destruction policy exists we should remove references
			if ("destructionPolicy" in target && target.destructionPolicy!="never") {
				//target = null; // possibly make this an option
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
	
	
}
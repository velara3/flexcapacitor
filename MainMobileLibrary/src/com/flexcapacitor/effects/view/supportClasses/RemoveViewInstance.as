

package com.flexcapacitor.effects.view.supportClasses {
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.view.RemoveView;
	import com.flexcapacitor.transitions.FlipViewTransition;
	import com.flexcapacitor.transitions.FlipViewTransitionMode;
	import com.flexcapacitor.transitions.ZoomViewTransition;
	import com.flexcapacitor.transitions.ZoomViewTransitionMode;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.system.ApplicationDomain;
	
	import mx.core.FlexGlobals;
	import mx.managers.SystemManager;
	
	import spark.components.View;
	import spark.components.ViewNavigator;
	import spark.transitions.CrossFadeViewTransition;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.SlideViewTransitionMode;
	import spark.transitions.ViewTransitionBase;
	
	
	/**
	 *  @copy spark.components.ViewNavigator#popView()
	 * */  
	public class RemoveViewInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function RemoveViewInstance(target:Object) {
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
			
			var action:RemoveView = RemoveView(effect);
			var transitionType:String = action.transitionType;
			var transitionMode:String = action.transitionMode;
			var transitionDirection:String = action.transitionDirection;
			var transitionDuration:int = action.transitionDuration;
			var minimumScale:Number = action.minimumScale;
			var transition:ViewTransitionBase = action.transition;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				
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
			
			if (!transition && transitionType) {
				if (transitionType=="flip") {
					transition = new FlipViewTransition();
					FlipViewTransition(transition).mode = transitionMode || FlipViewTransitionMode.CUBE;
					FlipViewTransition(transition).direction = transitionDirection;
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
					/*CrossFadeViewTransition(transition).easer
					CrossFadeViewTransition(transition).endView;
					CrossFadeViewTransition(transition).startView;
					CrossFadeViewTransition(transition).transitionControlsWithContent;
					CrossFadeViewTransition(transition).suspendBackgroundProcessing;*/
				}
			}
			
			// set the transition duration
			if (transition && transitionDuration!=-1) {
				transition.duration = transitionDuration;
			}
			
			if (target is View) {
				View(target).navigator.popView(transition);
			}
			else if (target is ViewNavigator) {
				ViewNavigator(target).popView(transition);
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
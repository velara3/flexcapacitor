

package com.flexcapacitor.effects.view.supportClasses {
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.view.SelectTabView;
	import com.flexcapacitor.transitions.FlipViewTransition;
	import com.flexcapacitor.transitions.FlipViewTransitionMode;
	import com.flexcapacitor.transitions.ZoomViewTransition;
	import com.flexcapacitor.transitions.ZoomViewTransitionMode;
	
	import spark.components.TabbedViewNavigator;
	import spark.components.View;
	import spark.components.ViewNavigator;
	import spark.components.supportClasses.ViewNavigatorBase;
	import spark.transitions.CrossFadeViewTransition;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.SlideViewTransitionMode;
	import spark.transitions.ViewTransitionBase;
	
	
	/**
	 * @copy SelectTabView
	 * */  
	public class SelectTabViewInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SelectTabViewInstance(target:Object) {
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
			
			var action:SelectTabView = SelectTabView(effect);
			var destinationViewClass:Object = action.destinationViewClass;
			var transitionType:String = action.transitionType;
			var selectedIndex:int = action.selectedIndex;
			var parentNavigator:TabbedViewNavigator;
			var transition:ViewTransitionBase;
			var navigator:ViewNavigator;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!destinationViewClass && selectedIndex<0) { 
					errorMessage = "A destination view or tab index is required";
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
			
			if (transitionType) {
				if (transitionType=="flip") {
					transition = new FlipViewTransition();
					FlipViewTransition(transition).mode = FlipViewTransitionMode.CUBE;
				}
				else if (transitionType=="slide") {
					transition = new SlideViewTransition();
					SlideViewTransition(transition).mode = SlideViewTransitionMode.COVER;
				}
				else if (transitionType=="zoom") {
					transition = new ZoomViewTransition();
					ZoomViewTransition(transition).mode = ZoomViewTransitionMode.IN;
				}
				else if (transitionType=="crossFade") {
					transition = new CrossFadeViewTransition();
					//FlipViewTransition(transition).mode = ZoomViewTransitionMode.CARD;
				}
				// more options are available but not enough time to add now
			}
			
			// get navigator
			if (target is View) {
				navigator = View(target).navigator;
			}
			else if (target is ViewNavigator) {
				navigator = ViewNavigator(target);
			}
			
			if (navigator.parentNavigator) {
				parentNavigator = TabbedViewNavigator(navigator.parentNavigator);
				
				if (selectedIndex>-1) {
					parentNavigator.selectedIndex = selectedIndex;
					//parentNavigator.loadViewData(action.data);
					//navigator.pushView(destinationViewClass, action.data, action.context, transition);
				}
				else if (destinationViewClass) {
					var navigators:Vector.<ViewNavigatorBase> = parentNavigator.navigators;
					var length:int = navigators.length;
					
					// find destination view
					for (var i:int;i<length;i++) {
						if (ViewNavigator(navigators[i]).firstView == Class(destinationViewClass)) {
							parentNavigator.selectedIndex = i;
							break;
						}
					}
				}
				
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
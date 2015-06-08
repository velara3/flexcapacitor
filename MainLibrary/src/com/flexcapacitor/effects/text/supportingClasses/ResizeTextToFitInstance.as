

package com.flexcapacitor.effects.text.supportingClasses {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.text.ResizeTextToFit;
	
	import flash.utils.getTimer;
	
	import mx.core.IInvalidating;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.TextBase;
	
	
	/**
	 *  @copy ResizeTextToFit
	 * */
	public class ResizeTextToFitInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ResizeTextToFitInstance(target:Object) {
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
			super.play();
			
			var action:ResizeTextToFit = ResizeTextToFit(effect);
			var desiredFontSize:Number = action.desiredFontSize;
			var minimumFontSize:Number = action.minimumFontSize;
			var stepSize:int = action.stepSize;
			var textBase:UIComponent = target as UIComponent;
			var container:IInvalidating = action.textComponentOwner;
			var maxWidth:int = action.maxWidth;
			var maxHeight:int = action.maxHeight;
			var padding:int = action.padding;
			var targetHeight:int;
			var labelWidth:int;
			var time:int;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (textBase==null) {
					dispatchErrorEvent("Target cannot be null and must be TextBase");
				}
				
				if (container==null) {
					if (textBase.owner==null && textBase.owner && textBase.owner is IInvalidating) {
						container = textBase.owner as IInvalidating;
					}
					else {
						dispatchErrorEvent("Container cannot be null. Set the textComponentOwner property.");
					}
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			var fontSize:Number = textBase.getStyle('fontSize');
			
			// set size of label
			if (fontSize!=desiredFontSize) {
				textBase.setStyle('fontSize', desiredFontSize);
				fontSize = desiredFontSize;
			}
			
			// forces text field to remeasure itself (textfield.validateNow does not work)
			container.validateNow();
			
			
			if (maxWidth!=0) {
				// get size of label
				labelWidth = textBase.width - padding;
				
				time = getTimer();
				
				while (labelWidth>maxWidth && fontSize!=minimumFontSize) {
					fontSize = fontSize-stepSize;
					
					if (fontSize<minimumFontSize) {
						fontSize = minimumFontSize;
					}
					
					textBase.setStyle('fontSize', fontSize);
					// forces text field to remeasure itself (textfield.validateNow does not work)
					container.validateNow();
					// get size of label
					labelWidth = textBase.width;
				}
				
				time = getTimer()-time;
			}
			
			if (maxHeight!=0) {
				// get size of label
				targetHeight = textBase.height - padding;
				
				time = getTimer();
				
				while (targetHeight>maxHeight && fontSize!=minimumFontSize) {
					fontSize = fontSize-stepSize;
					
					if (fontSize<minimumFontSize) {
						fontSize = minimumFontSize;
					}
					
					textBase.setStyle('fontSize', fontSize);
					// forces text field to remeasure itself (textfield.validateNow does not work)
					container.validateNow();//RangeError: Property fontSize value 0 is out of range
					// get size of label
					targetHeight = textBase.height;
				}
				
				time = getTimer()-time;
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
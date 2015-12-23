

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CopyPreviousToNext;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.effects.IEffect;
	import mx.utils.ObjectUtil;
	
	/**
	 *  @copy CopyPreviousToNext
	 * */
	public class CopyPreviousToNextInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CopyPreviousToNextInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:CopyPreviousToNext = CopyPreviousToNext(effect);
			var sourceEffect:IEffect = action.previousEffectDistance!=1 ? getEffectByIndex(index-action.previousEffectDistance):getPreviousEffect();
			var targetEffect:IEffect = action.nextEffectDistance!=1 ? getEffectByIndex(index+action.nextEffectDistance):getNextEffect();
			var targetSubPropertyName:String = action.targetSubPropertyName;
			var sourceSubPropertyName:String = action.sourceSubPropertyName;
			var targetPropertyName:String = action.targetPropertyName;
			var sourcePropertyName:String = action.sourcePropertyName;
			var targetIndices:Object = action.targetEffectIndices;
			var valueType:Object = action.valueType;
			var sourceIndex:int;
			var targetIndex:int;
			var length:int;
			var value:*;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// effect must be part of a sequence (for before and after)
				if (parentEffect==null) {
					dispatchErrorEvent("Effect must be part of a sequence effect");
				}
				
				if (sourceEffect==null) {
					dispatchErrorEvent("Effect must exist before this effect");
				}
				
				if (targetEffect==null) {
					dispatchErrorEvent("Effect must exist after this effect");
				}
				
				// check if not first
				// check if not last
				if (sourceEffect==null || targetEffect==null) {
					dispatchErrorEvent("There must be an effect before this one");
				}
	
				// check if not last
				// check the value of the nextEffectDistance
				if (targetEffect==null) {
					dispatchErrorEvent("There must be an effect after this one");
				}
				
				// check source property name is set
				// check source property exists on source
				// by default the source property name is "data" 
				// you may need to set the subproperty name
				else if (sourcePropertyName && !(sourcePropertyName in sourceEffect)) {
					dispatchErrorEvent("The '" + sourcePropertyName + "' property is not on the source effect, " + sourceEffect.className);
				}
				
				// check target property name is set
				// check if target property exists on target
				else if (targetPropertyName && !(targetPropertyName in targetEffect)) {
					dispatchErrorEvent("The '" + targetPropertyName + "' property is not on the target effect, " + targetEffect.className);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// GET VALUE
			// if source property index is set we get the index
			if (action.sourcePropertyIndex!=-1) {
				value = sourceEffect[sourcePropertyName][action.sourcePropertyIndex];
			}
			else {
				if (sourceSubPropertyName) {
					value = sourceEffect[sourcePropertyName];// "data" is the default property
					
					if (sourceSubPropertyName in value) {
						value = value[sourceSubPropertyName];
					}
					else {
						dispatchErrorEvent("The sub property '" + sourceSubPropertyName + "' is not on the '" + sourcePropertyName + "' object of the source" );
					}
				}
				else {
					value = sourceEffect[sourcePropertyName];
				}
			}
			
			if (action.inspectValue) {
				traceMessage("value= " + ObjectUtil.toString(value));
			}
			
			if (targetIndices is String) {
				targetIndices = String(targetIndices).split(",");
				length = targetIndices.length;
			}
			else if (targetIndices is Array) {
				length = targetIndices.length;
			}
			
			
			// NOTE: We should put try catch blocks and 
			// allow them to be handled
			
			// set value type
			if (valueType!=null) {
				value = valueType(value);
			}
			
			// SET VALUE
			if (length>0) {
				for (var i:int;i<length;i++) {
					targetEffect = getEffectByIndex(index + int(targetIndices[i]));
					
					// SET VALUE
					// if target property index is set we get the index - used for arrays
					if (action.targetPropertyIndex!=-1) {
						targetEffect[targetPropertyName][action.targetPropertyIndex] = value;
					}
					else {
						
						// Error - TypeError: Error #1034: Type Coercion failed: cannot convert flash.display::Bitmap@358a609 to flash.display.BitmapData.
						// Solution - use the correct type - or cast to to the correct type with the valueType object
						if (targetSubPropertyName) {
							
							if (targetSubPropertyName in targetEffect[targetPropertyName]) {
								targetEffect[targetPropertyName][targetSubPropertyName] = value;
							}
							else {
								dispatchErrorEvent("The sub property '" + targetSubPropertyName + "' is not on the '" + targetPropertyName + "' object of the target");
							}
						}
						else {
							targetEffect[targetPropertyName] = value;
						}
					}
				}
			}
			else {
				// if target property index is set we get the index
				if (action.targetPropertyIndex!=-1) {
					targetEffect[targetPropertyName][action.targetPropertyIndex] = value;
				}
				else {
					// Error - TypeError: Error #1034: Type Coercion failed: cannot convert flash.display::Bitmap@358a609 to flash.display.BitmapData.
					// Solution - use the correct type
					
					if (targetSubPropertyName) {
						
						if (targetSubPropertyName in targetEffect[targetPropertyName]) {
							targetEffect[targetPropertyName][targetSubPropertyName] = value;
						}
						else {
							dispatchErrorEvent("The sub property " + targetSubPropertyName + " is not on the " + targetPropertyName + " object");
						}
					}
					else {
						targetEffect[targetPropertyName] = value;
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
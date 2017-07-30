

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CopyDataToTarget;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.utils.ObjectUtil;
	
	/**
	 * @copy CopyDataToTarget
	 * */  
	public class CopyDataToTargetInstance extends ActionEffectInstance {
		
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
		public function CopyDataToTargetInstance(target:Object) {
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
		 */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:CopyDataToTarget = CopyDataToTarget(effect);
			var targetSubPropertyName:String = action.targetSubPropertyName;
			var sourceSubPropertyName:String = action.sourceSubPropertyName;
			var targetPropertyName:String = action.targetPropertyName;
			var sourcePropertyName:String = action.sourcePropertyName;
			var valueType:Object = action.dataType;
			var source:* = action.source;
			var value:*;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (target==null) {
					errorMessage = "The target cannot be null";
					dispatchErrorEvent(errorMessage);
				}
				
				// check if target property exists on target
				if (targetPropertyName && !(targetPropertyName in action.target)) {
					errorMessage = "The '" + targetPropertyName + "' property does not exist on the target object";
					dispatchErrorEvent(errorMessage);
				}
				
				// check if source property exists on source
				if (sourcePropertyName && source && source is Object && !(sourcePropertyName in source)) {
					errorMessage = "The '" + sourcePropertyName + "' property is not in the source object";
					dispatchErrorEvent(errorMessage);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// GET VALUE
			if (action.source) {
				// if source property index is set we get the index
				if (action.sourcePropertyIndex!=-1) {
					value = action.source[sourcePropertyName][action.sourcePropertyIndex];
				}
				else {
					if (sourceSubPropertyName) {
						value = action.source[sourcePropertyName];// "data" is the default property
						
						if (value && sourceSubPropertyName in value) {
							value = value[sourceSubPropertyName];
						}
						else {
							dispatchErrorEvent("The sub property " + sourceSubPropertyName + " is not on the " + sourcePropertyName + " source object");
						}
					}
					else if (sourcePropertyName) {
						if (action.source && sourcePropertyName in action.source) {
							value = action.source[sourcePropertyName];
						}
						else {
							dispatchErrorEvent("The property '" + sourcePropertyName + "' is not on the source object");
						}
					}
					else {
						value = action.source;
					}
				}
			}
			// else if (action.data!=undefined) { // because undefined or null or 0 or false may be desired
			else {
				value = action.data;
			}
			
			if (action.inspectData) {
				traceMessage("Value= " + ObjectUtil.toString(value));
			}
			
			// NOTE: We should put try catch blocks and 
			// allow them to be handled
			
			// set value type
			if (valueType!=null) {
				value = valueType(value);
			}
			
			// throw error if value is null
			if (action.throwErrorIfDataIsNull && value==null) {
				dispatchErrorEvent("The data is null and is not allowed by this effect");
			}
			
			if (action.convertObjectToString) {
				value = ObjectUtil.toString(value);
			}
			
			// SET VALUE
			// if target property index is set we get the index
			if (action.targetPropertyIndex!=-1) {
				action.target[targetPropertyName][action.targetPropertyIndex] = value;
			}
			else {
				// Error - TypeError: Error #1034: Type Coercion failed: cannot convert flash.display::Bitmap@358a609 to flash.display.BitmapData.
				// Solution - use the correct type
				
				if (targetSubPropertyName) {
					
					if (action.target[targetPropertyName]==null) {
						dispatchErrorEvent("Cannot set the property '" + targetSubPropertyName + "' because '" + targetPropertyName + "' on the target is null");
					}
					
					if (targetSubPropertyName in action.target[targetPropertyName]) {
						action.target[targetPropertyName][targetSubPropertyName] = value;
					}
					else {
						dispatchErrorEvent("The sub property '" + targetSubPropertyName + "' is not on the '" + targetPropertyName + "' object");
					}
				}
				else if (targetPropertyName) {
					action.target[targetPropertyName] = value;
				}
				else {
					action.target = value;
				}
			}
			
			// READ! If the value is not sticking with 
			// target = value;
			// then set the target to "{this}" and then set the target name to the targetPropertyName
			// target[targetPropertyName] = value;
			
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
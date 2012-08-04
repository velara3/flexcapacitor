

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.FormatObjectToString;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.utils.ObjectUtil;
	
	/**
	 * @copy FormatObjectToString
	 * */  
	public class FormatObjectToStringInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function FormatObjectToStringInstance(target:Object) {
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
			// Dispatch an effectStart event
			super.play();
			
			var action:FormatObjectToString = FormatObjectToString(effect);
			var data:Object = action.data;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// data can be null
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (data is XML || data is XMLList) { 
				action.formattedData = data is XML ? XML(data).toXMLString() : XMLList(data).toString();
			}
			else {
				action.formattedData = ObjectUtil.toString(data, action.namespaceURIs, action.exclude);
			}
			
			if (action.traceToConsole) {
				trace(action.formattedData);
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
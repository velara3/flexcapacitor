

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.SetFormDataToServerData;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormManager;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy SetFormDataToServerData
	 * */
	public class SetFormDataToServerDataInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SetFormDataToServerDataInstance(target:Object) {
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
			
			var action:SetFormDataToServerData = effect as SetFormDataToServerData;
			var propertyName:String = action.sourcePropertyName;
			var source:Object = action.source;
			var valid:Boolean = true;
			var value:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!action.formAdapter) {
					dispatchErrorEvent("Form adapter property is required.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			value = propertyName ? source[propertyName] : source;
			
			action.data = FormManager.instance.setFormDataToServerData(action.formAdapter, value);
			
			if (action.inspectData) {
				trace(action.className + " form data:\n" + ObjectUtil.toString(action.data));
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
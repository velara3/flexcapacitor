

package com.flexcapacitor.effects.compatibility.supportClasses {
	
	import com.flexcapacitor.effects.compatibility.IsCameraRollAvailable;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.managers.SystemManager;

	/**
	 * @copy IsCameraRollAvailable
	 * */  
	public class IsCameraRollAvailableInstance extends ActionEffectInstance {
		
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
		public function IsCameraRollAvailableInstance(target:Object) {
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
			
			var action:IsCameraRollAvailable = IsCameraRollAvailable(effect);
			var applicationDomain:ApplicationDomain;
			var supportsBrowseForImage:Boolean;
			var supportsAddBitmapData:Boolean;
			var definition:Object;
			var classFound:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// check for required properties
				if (!action.classDefinition) {
					throw new Error("The class definition is not defined.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			// From SystemManager: var domain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info()["currentDomain"] as ApplicationDomain;
			applicationDomain = SystemManager.getSWFRoot(this).loaderInfo.applicationDomain;
			classFound = applicationDomain.hasDefinition(action.classDefinition); 
			
			
			// check if the class is found
			if (classFound) {
				definition = applicationDomain.getDefinition(action.classDefinition);
				
				// check if CameraRoll has properties and they are true
				if (definition.hasOwnProperty("supportsBrowseForImage") && definition["supportsBrowseForImage"]) {
					supportsBrowseForImage = true;
				}
				
				if (definition.hasOwnProperty("supportsAddBitmapData") && definition["supportsBrowseForImage"]) {
					supportsAddBitmapData = true;
				}
				
			}
			
			////////////////////////////////////////////
			// Browse for Image support
			////////////////////////////////////////////
			
			if (supportsBrowseForImage) {
				
				// browse supported
				if (action.hasEventListener(IsCameraRollAvailable.SUPPORTS_BROWSE)) {
					dispatchActionEvent(new Event(IsCameraRollAvailable.SUPPORTS_BROWSE));
				}
				
				if (action.supportsBrowseForImageEffect) { 
					playEffect(action.supportsBrowseForImageEffect);
				}
			}
			else {
				
				if (action.hasEventListener(IsCameraRollAvailable.BROWSE_NOT_SUPPORTED)) {
					dispatchActionEvent(new Event(IsCameraRollAvailable.BROWSE_NOT_SUPPORTED));
				}
				
				if (action.browseForImageNotSupportedEffect) { 
					playEffect(action.browseForImageNotSupportedEffect);
				}
				
			}
			
			////////////////////////////////////////////
			// Add bitmap data support
			////////////////////////////////////////////
			
			if (supportsAddBitmapData) {
				
				// add bitmap data supported
				if (action.hasEventListener(IsCameraRollAvailable.SUPPORTS_ADD_BITMAP_DATA)) {
					dispatchActionEvent(new Event(IsCameraRollAvailable.SUPPORTS_ADD_BITMAP_DATA));
				}
				
				if (action.supportsAddBitmapDataEffect) { 
					playEffect(action.supportsAddBitmapDataEffect);
				}
			}
			else {
				
				if (action.hasEventListener(IsCameraRollAvailable.ADD_BITMAP_DATA_NOT_SUPPORTED)) {
					dispatchActionEvent(new Event(IsCameraRollAvailable.ADD_BITMAP_DATA_NOT_SUPPORTED));
				}
				
				if (action.addBitmapDataNotSupportedEffect) { 
					playEffect(action.addBitmapDataNotSupportedEffect);
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
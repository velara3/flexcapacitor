

package com.flexcapacitor.effects.compatibility.supportClasses {
	
	import com.flexcapacitor.effects.compatibility.ParseURL;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.managers.SystemManager;
	import mx.utils.URLUtil;

	/**
	 * @copy ParseURL
	 * */  
	public class ParseURLInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ParseURLInstance(target:Object) {
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
			
			var action:ParseURL = ParseURL(effect);
			var section:String = action.section;
			var URL:String = action.URL;
			var inspect:Boolean = action.inspect;
			var value:Object;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!section) {
					dispatchErrorEvent("The section is not defined.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// get url protocol
			if (!URL) {
				URL = SystemManager.getSWFRoot(this).loaderInfo.url;
			}
			
			if (inspect) {
				trace(effect.className + " URL: " + URL);
			}
			
			
			switch (section) {
				
				case "protocol": {
					value = URLUtil.getProtocol(URL);
					break;
				}
				case "port": {
					value = URLUtil.getPort(URL);
					break;
				}
				case "fullURL": {
					value = URLUtil.getFullURL("",URL);
					break;
				}
				case "serverName": {
					value = URLUtil.getServerName(URL);
					break;
				}
				case "serverNameWithPort": {
					value = URLUtil.getServerNameWithPort(URL);
					break;
				}
			}
			
			action.data = value;
			
			if (inspect) {
				trace(effect.className + " " + section + ": " + value);
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
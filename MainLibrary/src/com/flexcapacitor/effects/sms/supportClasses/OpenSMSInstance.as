

package com.flexcapacitor.effects.sms.supportClasses {
	
	import com.flexcapacitor.effects.sms.OpenSMS;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	

	/**
	 * @copy OpenSMS
	 * */  
	public class OpenSMSInstance extends ActionEffectInstance {
		
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
		public function OpenSMSInstance(target:Object) {
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
			
			var action:OpenSMS = OpenSMS(effect);
			var useMMS:Boolean = action.useMMS;
			var variables:URLVariables;
			var request:URLRequest;
			var source:String;
			var url:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// dispatchErrorEvent("");
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			/*variables 			= new URLVariables();
			//variables.cc 		= action.cc ? action.cc : "";
			//variables.bcc 	= action.bcc ? action.bcc : "";
			variables.body 		= action.body ? action.body : "";
			variables.subject 	= action.subject ? action.subject : "";*/
			
			request				= new URLRequest();
			
			url = useMMS ? OpenSMS.MMS_PROTOCOL + ":" : OpenSMS.SMS_PROTOCOL + ":";
			url += action.data ? "?body=" + action.data : "";
			
			request.url = url;
			
			
			if (request.url.length>action.bodyLimit) {
				request.url = request.url.substr(0, action.bodyLimit);
				
			}
			
			//trace(request.url.length);
			
			navigateToURL(request, "_self");
			
			///////////////////////////////////////////////////////////
			// finish the effect
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
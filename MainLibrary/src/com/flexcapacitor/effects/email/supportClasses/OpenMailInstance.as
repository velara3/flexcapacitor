

package com.flexcapacitor.effects.email.supportClasses {
	
	import com.flexcapacitor.effects.email.OpenMail;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.utils.URLUtil;
	

	/**
	 * @copy OpenMail
	 * */  
	public class OpenMailInstance extends ActionEffectInstance {
		
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
		public function OpenMailInstance(target:Object) {
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
			
			var action:OpenMail = OpenMail(effect);
			var variables:URLVariables;
			var request:URLRequest;
			var source:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// dispatchErrorEvent("");
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			variables 			= new URLVariables();
			//variables.cc 		= action.cc ? action.cc : "";
			//variables.bcc 	= action.bcc ? action.bcc : "";
			variables.body 		= action.data ? action.data : "";
			variables.subject 	= action.subject ? action.subject : "";
			
			request				= new URLRequest();
			request.url			= "mailto:";
			
			source  			= URLUtil.objectToString(variables, "&", true);
			request.url			= request.url + "?" +source;
			
			
			if (request.url.length>action.bodyLimit) {
				request.url = request.url.substr(0, 2000);
				
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


package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.CreateFormCode;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormUtilities;
	
	
	/**
	 *  @copy CreateFormCode
	 * */  
	public class CreateFormCodeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CreateFormCodeInstance(target:Object) {
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
			
			var action:CreateFormCode = CreateFormCode(effect);
			var list:Vector.<String> = new Vector.<String>;
			var duplicates:Vector.<String> = new Vector.<String>;
			var duplicateCount:int;
			
			if (!action.formAdapter) {
				cancel();
				throw new Error("Form adapter property is required.");
			}
			
			list = FormUtilities.getRequestNames(action.formAdapter);
			
			if (action.listRequestNames) {
				// PHP $formElements = explode(",", "include_posts,include_pages");
				trace("Request Names:\n"+list.join(action.requestNameJoinSeparater)+"\n");
			}
			
			if (action.checkForDuplicates) {
				for (var i:int;i<list.length;i++) {
					duplicateCount = 0;
					
					for (var j:int;j<list.length;j++) {
						
						if (list[i]==list[j]) {
							duplicateCount++;
						}
					}
					if (duplicateCount>1) {
						duplicates.push(list[i]);
					}
				}
				
				if (duplicates.length) {
					trace("Duplicates:\n" + duplicates.join("\n") + "\n");
				}
				else {
					trace("Duplicates:\nno duplicates" + "\n");
					
				}
			}
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}
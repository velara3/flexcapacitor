

package com.flexcapacitor.effects.compatibility.supportClasses {
	
	import com.flexcapacitor.effects.compatibility.ClassAvailable;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.managers.SystemManager;

	/**
	 * @copy ClassAvailable
	 * */  
	public class ClassAvailableInstance extends ActionEffectInstance {
		
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
		public function ClassAvailableInstance(target:Object) {
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
			
			var action:ClassAvailable = ClassAvailable(effect);
			var applicationDomain:ApplicationDomain;
			var classFound:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// if we are in the browser we must run our code during a click event
			if (validate) {
				// check for required properties
				if (!action.classDefinition) {
					dispatchErrorEvent("The class definition is not defined.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// From SystemManager: var domain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info()["currentDomain"] as ApplicationDomain;
			applicationDomain = SystemManager.getSWFRoot(this).loaderInfo.applicationDomain;
			classFound = applicationDomain.hasDefinition(action.classDefinition); 
			
			
			// check if the class is found
			if (!classFound) {
				
				if (action.hasEventListener(ClassAvailable.CLASS_NOT_FOUND)) {
					dispatchActionEvent(new Event(ClassAvailable.CLASS_NOT_FOUND));
				}
				
				if (action.classNotFoundEffect) { 
					playEffect(action.classNotFoundEffect);
				}
				
				//cancel("This class " + action.classDefinition + " was not found");
				//return;
				
			}
			else {
				
				if (action.hasEventListener(ClassAvailable.CLASS_FOUND)) {
					dispatchActionEvent(new Event(ClassAvailable.CLASS_FOUND));
				}
				
				if (action.classFoundEffect) { 
					playEffect(action.classFoundEffect);
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
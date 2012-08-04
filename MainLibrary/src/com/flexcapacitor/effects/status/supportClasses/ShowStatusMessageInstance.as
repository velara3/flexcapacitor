

package com.flexcapacitor.effects.status.supportClasses {
	import com.flexcapacitor.effects.status.ShowStatusMessage;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	/**
	 * @copy ShowStatusMessage
	 * */
	public class ShowStatusMessageInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ShowStatusMessageInstance(target:Object) {
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
		
		public var messageBox:IFlexDisplayObject;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play();
			
			var action:ShowStatusMessage = ShowStatusMessage(effect);
			var statusMessageClass:Class = action.statusMessageClass;
			var statusMessageProperties:Object = action.statusMessageProperties;
			var nonBlocking:Boolean = action.nonBlocking;
			var location:String = action.location;
			var parent:Sprite = action.parentView;
			var statusMessage:IStatusMessage;
			var factory:ClassFactory;
			var position:Number;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// we do
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.locationPosition) {
				position = action.locationPosition;
			}
			else if (location=="center") {
				position = ShowStatusMessage.CENTER;
			}
			else if (location=="top") {
				position = ShowStatusMessage.TOP;
			}
			else if (location=="bottom") {
				position = ShowStatusMessage.BOTTOM;
			}
			
			factory = new ClassFactory(statusMessageClass);
			factory.properties = statusMessageProperties;
			
			messageBox = factory.newInstance();
			statusMessage = messageBox as IStatusMessage;
			
			if (statusMessage) {
				statusMessage.message = action.message;
				statusMessage.duration = action.doNotClose ? -1 : action.duration;
				statusMessage.showBusyIndicator = action.showBusyIcon;
				statusMessage.title = action.title;
			}
			
			if (!parent) {
				var systemManager:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				
				// no types so no dependencies
				var marshallPlanSystemManager:Object = systemManager.getImplementation("mx.managers.IMarshallPlanSystemManager");
				
				if (marshallPlanSystemManager && marshallPlanSystemManager.useSWFBridge()) {
					parent = Sprite(systemManager.getSandboxRoot());
				}
				else {
					parent = Sprite(FlexGlobals.topLevelApplication);
				}
			}
			
			PopUpManager.addPopUp(IFlexDisplayObject(messageBox), parent, action.modal);
			PopUpManager.centerPopUp(IFlexDisplayObject(messageBox));
			
			IFlexDisplayObject(messageBox).y = parent.height*position - IFlexDisplayObject(messageBox).height/2;
			
			if (action.closeHandler!=null) {
				IEventDispatcher(messageBox).addEventListener(Event.CLOSE, action.closeHandler, false, 0, true);
				IEventDispatcher(messageBox).addEventListener(MouseEvent.CLICK, action.closeHandler, false, 0, true);
			}
			else {
				IEventDispatcher(messageBox).addEventListener(Event.CLOSE, closeHandler, false, 0, true);
				IEventDispatcher(messageBox).addEventListener(MouseEvent.CLICK, closeHandler, false, 0, true);				
			}
			
			//messageBox = StatusManager.show(action.message, action.doNotClose ? -1 : action.duration, 
			//					action.showBusyIcon, action.parentView, action.modal, position);
			
			// and call finish there if requested
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			//waitForHandlers();
			
			// we let the effect duration run until it is done
			if (nonBlocking) {
				finish();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		override public function onTweenEnd(value:Object):void  {
			super.onTweenEnd(value);
			
			removeListeners();
			close();
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Removes the view from the display
		 * */
		public function closeHandler(event:Event):void {
			removeListeners();
			close();
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			end(); // end the tween effect if running
			finish();
		}
		
		/**
		 * Closes the message box
		 * */
		public function close():void {
			if (messageBox) {
				PopUpManager.removePopUp(messageBox);
			}
		}
		
		private function removeListeners():void {
			var action:ShowStatusMessage = ShowStatusMessage(effect);
			
			if (action.closeHandler!=null) {
				messageBox.removeEventListener(Event.CLOSE, action.closeHandler);
				messageBox.removeEventListener(MouseEvent.CLICK, action.closeHandler);
			}
			else {
				messageBox.removeEventListener(Event.CLOSE, closeHandler);
				messageBox.removeEventListener(MouseEvent.CLICK, closeHandler);				
			}
		}
		
	}
}
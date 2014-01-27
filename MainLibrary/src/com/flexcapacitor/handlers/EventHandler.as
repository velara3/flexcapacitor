



package com.flexcapacitor.handlers {
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	
	import mx.core.IMXMLObject;
	import mx.effects.CompositeEffect;
	import mx.effects.IEffect;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	import mx.managers.SystemManager;
	
	
	/**
	 * Event dispatched at the start of the event handling
	 * @see effectsStart
	 * */
	[Event(name="eventStart", type="flash.events.Event")]
	
	/**
	 * Event dispatched at the end of the event handling. 
	 * This is NOT always at the end of the sequence of actions. 
	 * Use the effects end event for that.
	 * @see effectsEnd
	 * */
	[Event(name="eventEnd", type="flash.events.Event")]
	
	/**
	 * Event dispatched at the start of the actions. 
	 * This is dispatched at the start of the sequence of actions.
	 * Same as the sequence effectStart
	 * @see mx.events.EffectEvent
	 * */
	[Event(name="effectStart", type="mx.events.EffectEvent")]
	
	/**
	 * Event dispatched at the end of the actions. 
	 * This is dispatched at the end of the sequence of actions.
	 * Same as the sequence effectEnd
	 * @see mx.events.EffectEvent
	 * */
	[Event(name="effectEnd", type="mx.events.EffectEvent")]
	
	/**
	 * Event dispatched at the start of the actions. 
	 * This is dispatched at the start of the sequence of actions.
	 * Same as the sequence effectStart
	 * @see mx.events.EffectEvent
	 * */
	[Event(name="controllerEffectStart", type="mx.events.EffectEvent")]
	
	/**
	 * Event dispatched at the end of the actions. 
	 * This is dispatched at the end of the sequence of actions.
	 * Same as the sequence effectEnd
	 * @see mx.events.EffectEvent
	 * */
	[Event(name="controllerEffectEnd", type="mx.events.EffectEvent")]
	
	
	[DefaultProperty("actions")]
	
	/**
	 * Adds an event listener on the target or targets for the event or events you specify
	 * and plays effects or redispatches events.<br/><br/>
	 * 
	 * For keyboard events set the event name to keyUp or keyDown and set the keyCode to the key you 
	 * are listening for. <br/><br/>
	 * 
	 * If you don't set the target then the target is set to the document 
	 * (if declared in an IMXMLObject document) which all view components implement.<br/><br/>
	 * 
	 * Note: If the effects are not being played make sure the target on the effect is not null.<br/><br/>
	 * 
	 * <b>To Use:</b> 
<pre>&lt;EventHandler eventName="click" target="{button}" >
		&lt;s:Move duration="250"
				yFrom="0" yTo="100"
				target="{container}" 
				/>
		&lt;list:SelectItem target="{list}"/>
&lt;/EventHandler>
</pre>
	 * 
	 * <b>To Use:</b> 
<pre>&lt;KeyboardEventHandler keyCode="{Keyboard.MENU}" 
	target="{this}" effect="{sequence}"> 
&lt;/EventHandler>

&lt;s:Sequence id="sequence">
	&lt;list:SelectItem target="{list}"/>
&lt;/s:Sequence>
</pre>
	 * 
	 * <b>To redispatch:</b><br/>
MyComponent.mxml,<br/>
<pre>&lt;EventHandler eventName="{MouseEvent.CLICK}" 
		target="{this}" 
		redispatchToTarget="{FlexGlobals.topLevelApplication as IEventDispatcher}"
		dispatchName="settingsUpdated"
	>
&lt;/EventHandler>

MyOtherComponent.mxml,<br/>
&lt;EventHandler eventName="settingsUpdated" 
		target="{IEventDispatcher(FlexGlobals.topLevelApplication)}">
			&lt;debugging:Trace message="settings updated"/>
&lt;/EventHandler>
</pre>
	 * 
	 * <b>Usage with Controller:</b><br/><br/>
	 * 
	 * This allows you to redispatch an event or play an effect on an external class.<br/> 
	 * 
	 * In the main root Application or equivalent you bind a manager type class to Event Handler
	 * setStaticController property:<br/>
<pre>
&lt;fx:Declarations>
	&lt;managers:DataManager id="dataManager"/>
	&lt;managers:EventsManager id="eventsManager"/>
	
	&lt;handlers:EventHandler setStaticController="{eventsManager}" 
						   setStaticState="{dataManager}"
						   eventName="applicationComplete" 
						   dispatchName="appCreationComplete">
	&lt;/handlers:EventHandler>
&lt;/fx:Declarations>
</pre>
	 * 
	 * In a view component add an event handler. When this event occurs it will redispatch 
	 * an event called menuButtonClick event on the staticController (eventsManager in this example):<br/>
	 * 
<pre>
	&lt;local:RegisterComponent targetPropertyName="{EventsManager.MENU_CONTAINER}"
						 source="{container}"
						 />
	&lt;!-- SHOW MENU -->
	&lt;handlers:EventHandler id="menuButtonHandler" 
						   eventName="click" 
						   target="{menuImage}"
						   dispatchName="menuButtonClick"
						   >
		&lt;debugging:Trace message="menu button click"/>
	&lt;/handlers:EventHandler>
</pre>
	
	 * In a events manager class add an event handler that responds to the menuButtonClick event
	 * that plays the toggle effects class.<br/>
	 * 
<pre>
&lt;managers:EventDispatcher xmlns:fx="http://ns.adobe.com/mxml/2009" 
	 xmlns:s="library://ns.adobe.com/flex/spark" 
	 xmlns:mx="library://ns.adobe.com/flex/mx" 
	 xmlns:managers="flash.events.*"> 
	 
	&lt;fx:Script>
		&lt;![CDATA[
			public static const MENU_CONTAINER:String = "menuContainer";
			
			[Bindable]
			public var menuContainer:UIComponent;
		]]>
	&lt;/fx:Script> 
	 
	&lt;!-- MENU BUTTON ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	&lt;handlers:EventHandler eventName="menuButtonClick" target="{this}">
		&lt;s:Move duration="1000"
				yFrom="100" yTo="0"
				target="{menuContainer}" 
				/>
	&lt;/handlers:EventHandler>

	
	&lt;!-- CLOSE MENU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	&lt;s:Sequence id="hideMenuEffectAndGotoHome"
				suspendBackgroundProcessing="true"
				>
		&lt;s:Move duration="1000"
				yFrom="100" yTo="0"
				target="{menuContainer}" 
				/>
		&lt;debugging:Trace message="gotohome finish"/>
	&lt;/s:Sequence> 
	 
	&lt;/fx:Declarations>
&lt;/managers:EventDispatcher>
</pre>

	 * In another view component add an event handler. When this event occurs it will redispatch 
	 * play an effect called hideMenuEffectAndGotoHome on the staticController (eventsManager):<br/>
<pre>
	&lt;!-- SHOW HOME SCREEN -->
	&lt;handlers:EventHandler eventName="click" 
						   target="{backLabel}"
						   controllerEffectName="hideMenuEffectAndGotoHome"
						   >
		&lt;list:SelectNoItems target="{levelsList}"/>
		&lt;debugging:Trace message="show home button click"/>
	&lt;/handlers:EventHandler>
</pre>
	 * 
	 * The local effects will play and then the hideMenuEffectAndGotoHome effect will play.
	 * You can have the controller effect play first by changing to playControllerEffectDuring property
	 * to before.<br/><br/>
	 * 
	 * NOTE: When a pop up is being removed from the stage and it contains effects
	 * it can sometimes throw a TypeError since the effect trigger event is null. 
	 * Set setTriggerEvent to true to avoid the following error. <br/><br/>
	 * 
	 * TypeError: Error #1009: Cannot access a property or method of a null object reference.<br/>
	 * 		at mx.effects::EffectManager$/http://www.adobe.com/2006/flex/mx/internal::eventHandler()[E:\dev\4.y\frameworks\projects\framework\src\mx\effects\EffectManager.as:605]<br/>
	 * 		at flash.display::DisplayObjectContainer/removeChild()<br/>
	 * */
	public class EventHandler extends EventHandlerBase implements IHandler, IMXMLObject {
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event dispatched at the start of the event handling
		 * */
		public static const EVENT_START:String = "eventStart";
		
		/**
		 * Event dispatched at the end of the event handling 
		 * */
		public static const EVENT_END:String = "eventEnd";
		
		/**
		 * Event dispatched at the start of the sequence
		 * */
		public static const EFFECT_START:String = "effectStart";
		
		/**
		 * Event dispatched at the end of the sequence
		 * */
		public static const EFFECT_END:String = "effectEnd";
		
		/**
		 * Event dispatched at the start of the sequence
		 * */
		public static const CONTROLLER_EFFECT_START:String = "controllerEffectStart";
		
		/**
		 * Event dispatched at the end of the sequence
		 * */
		public static const CONTROLLER_EFFECT_END:String = "controllerEffectEnd";
		
		/**
		 * @see EventHandler.redispatchDuring
		 * @see EventHandler.playControllerEffectDuring
		 * */
		public static const BEFORE:String = "before";
		
		/**
		 * @see EventHandler.redispatchDuring
		 * @see EventHandler.playControllerEffectDuring
		 * */
		public static const DURING:String = "during";
		
		/**
		 * @see EventHandler.redispatchDuring
		 * @see EventHandler.playControllerEffectDuring
		 * */
		public static const AFTER:String = "after";
		
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Global debugging. When true traces events to the console.
		 * */
		public static var debugHandlers:Boolean;
		
		/**
		 * Global debugging. When true enters the debugger when the event handler is run.
		 * */
		public static var enterDebuggerOnEvent:Boolean;
		
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 */
		public function EventHandler(target:IEventDispatcher=null) {
			super(target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When set to true traces a message to the console
		 * */
		public var traceHandler:String;
		
		/**
		 * If the sequence property is not set by the developer than one 
		 * is created internally. This property is true if it was created
		 * internally.
		 * */
		private var _sequenceInternal:Boolean;
		
		private var _actions:Array;
		
		private var _effect:IEffect;
		
		/**
		 * A list of action effects to run in sequence. 
		 * Since this is actually a Sequence it can accept 
		 * Parallel or Sequence as well as any effects.
		 * Can also contain a reference to a sequence 
		 * */
		[ArrayElementType("mx.effects.IEffect")]
		public function get actions():Array {
			return _actions;
		}

		/**
		 * @private
		 */
		public function set actions(value:Array):void {
			if (_actions==value) return;
			
			var compositeEffect:CompositeEffect;
			_actions = value;
			
			if (_actions && _actions.length>0) {
				
				// if effect is not set then create a sequence and add the actions to it
				if (effect==null) {
					compositeEffect = new Sequence();
					compositeEffect.children = actions;
					compositeEffect.suspendBackgroundProcessing = suspendBackgroundProcessing;
					
					effect = compositeEffect;
					_sequenceInternal = true;
				}
				else if (actions!=value) {
					if (effect.isPlaying) effect.end();// we might want to call end here
					compositeEffect.children = actions;
				}
				
				if (!_sequenceInternal) {
					throw new Error("You cannot set both the actions property and the effect property.");
				}
			}
		}

		/**
		 * Sequence used to play the action effects
		 * */
		public function get effect():IEffect {
			return _effect;
		}
		
		/**
		 * @private
		 * */
		public function set effect(value:IEffect):void {
			if (_effect==value) return;
			_effect = value;
			
			if (value) {
				if (_effect is CompositeEffect) {
					CompositeEffect(_effect).suspendBackgroundProcessing = suspendBackgroundProcessing;
				}
			}
		}
		
		/**
		 * Dispatched at the start of a sequence
		 * */
		protected function effectStart(event:EffectEvent):void {
			
			_effect.removeEventListener(EffectEvent.EFFECT_START, effectStart);
			
			if (hasEventListener(EFFECT_START)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * Dispatched at the end of a sequence
		 * */
		protected function effectEnd(event:EffectEvent):void {
			
			_effect.removeEventListener(EffectEvent.EFFECT_END, effectEnd);
			
			// play controller effect if set
			if (hasControllerEffects && playControllerEffectDuring==AFTER){
				playControllerEffect();
			}
			else {
				// redispatch events 
				if (redispatchDuring==AFTER) {
					redispatch(event);
				}
			}
			
			// end of local effect
			if (hasEventListener(EFFECT_END)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * Dispatched at the start of a controller sequence
		 * */
		public function controllerEffectStart(event:EffectEvent):void {
			
			event.currentTarget.removeEventListener(EffectEvent.EFFECT_START, controllerEffectStart);
			
			if (hasEventListener(CONTROLLER_EFFECT_START)) {
				dispatchEvent(new EffectEvent(CONTROLLER_EFFECT_START, false, false, event.effectInstance));
			}
		}
		
		/**
		 * Dispatched at the end of a controller sequence
		 * */
		public function controllerEffectEnd(event:EffectEvent):void {
			
			event.currentTarget.removeEventListener(EffectEvent.EFFECT_END, controllerEffectEnd);
			
			// play effects
			if (hasEffects) {
				playEffect();
			}
			else {
				// no local effects
				// redispatch events 
				if (redispatchDuring==AFTER) {
					redispatch(event);
				}
			}
			
			// end of local effect
			if (hasEventListener(CONTROLLER_EFFECT_END)) {
				dispatchEvent(new EffectEvent(CONTROLLER_EFFECT_END, false, false, event.effectInstance));
			}
		}
		
		/**
		 * Ends effects if they are playing
		 * */
		public var endPlayingEffects:Boolean;
		
		/**
		 * Stops effects if they are playing
		 * */
		public var stopPlayingEffects:Boolean;
		
		private var preventDefaultKeyboardEvent:Boolean;
		
		/**
		 *  @private
		 *  Code of current key being handled or -1 if not handling a key event
		 * */
		private var handlingKeyCode:int;
		
		/**
		 *  @private
		 *  Indicates if handling a key event
		 */
		private var handlingKeyEvent:Boolean;
		
		public var keyEventPreventDefaulted:Boolean;
		
		/**
		 * Adds listeners to the stage to capture keyboard events when 
		 * target does not have focus
		 * */
		public var addKeyListenersToStage:Boolean = true;
		
		/**
		 * Trigger event. Reference to the current event that is being handled.
		 * Used to prevent keyboard events from being handled twice.
		 * There is an option to listen for key events on the stage as well 
		 * as the component. If handlers are triggered for each then one is canceled.
		 * */
		[Bindable]
		public var event:Event;
		
		/**
		 * A reference to the target property on the current event. IE event.target.
		 * @see currentTarget
		 * @see event
		 * */
		[Bindable]
		public var eventTarget:Object;
		
		/**
		 * A reference to the current target property on the current event. IE event.currentTarget.
		 * @see eventTarget
		 * @see event
		 * */
		[Bindable]
		public var currentTarget:Object;
		
		/**
		 * Calls event.stopPropagation() 
		 * @see eventTarget
		 * @see event
		 * */
		[Bindable]
		public var stopPropagation:Boolean;
		
		/**
		 * Calls event.stopImmediatePropagation() 
		 * @see eventTarget
		 * @see event
		 * */
		[Bindable]
		public var stopImmediatePropagation:Boolean;
		
		/**
		 * Calls event.preventDefault() 
		 * @see eventTarget
		 * @see event
		 * */
		[Bindable]
		public var preventDefault:Boolean;
		
		/**
		 * Reference to a local controller class. If set and dispatchName is set 
		 * then events are redispatched on it
		 * 
		 * @see staticController
		 * @see controllerEffect
		 * @see controllerEffectName
		 * @see dispatchName
		 * */
		[Bindable]
		public var controller:IEventDispatcher;
		
		/**
		 * Reference to a static controller class. If set and dispatchName is set 
		 * then events are redispatched on it
		 * 
		 * @see controller
		 * @see staticController
		 * @see controllerEffect
		 * @see controllerEffectName
		 * */
		[Bindable]
		public static var staticController:IEventDispatcher;
		
		/**
		 * Reference to a static controller class. If set and dispatchName is set 
		 * then events are redispatched on it.
		 * If set and controllerEffectName is set then the effect is run.
		 * 
		 * @see EventHandler.redispatchDuring
		 * @see EventHandler.controller
		 * @see EventHandler.staticController
		 * @see EventHandler.controllerEffect
		 * @see EventHandler.controllerEffectName
		 * @see EventHandler.playControllerEffectDuring
		 * */
		public function set setStaticController(value:IEventDispatcher):void {
			
			// accepts first non-null assignment only
			if (value==null) return;
			else if (EventHandler.staticController==null) {
				EventHandler.staticController = value;
			}
			else if (EventHandler.staticController!=value) {
				// binding was triggering this twice so even though we actually only set 
				// the value in one location it was still causing an error 
				// so now we only check if value does not match
				throw new Error("You cannot set the static controller to another instance");
			}

		}
		
		/**
		 * @private
		 * */
		public function get staticController():IEventDispatcher {
			return EventHandler.staticController;
		}
		
		/**
		 * Reference to a local state class. 
		 * */
		[Bindable]
		public var state:Object;
		
		/**
		 * Reference to a static state instance. 
		 * */
		[Bindable]
		public static var staticStateReference:Object;
		
		/**
		 * Reference to a static state class. 
		 * This is a convenience method so we can set the state class in MXML
		 * */
		public function set setStaticState(value:Object):void {
			
			// accepts first non-null assignment only
			if (value==null) return;
			else if (EventHandler.staticStateReference==null) {
				EventHandler.staticStateReference = value;
				stateReference = value;
			}
			else if (EventHandler.staticStateReference!=value) {
				// binding was triggering this twice so even though we actually only set 
				// the value in one location it was still causing an error 
				// so now we only check if value does not match
				throw new Error("You cannot set the static state to another instance");
			}
		}
		
		/**
		 * @private
		 * */
		public function get stateReference():Object {
			return EventHandler.staticStateReference;
		}
		
		/**
		 * @private
		 * */
		[Bindable]
		public function set stateReference(value:Object):void {
			//throw new Error("Set the state object through setStaticState");
			//return EventHandler.staticState;
		}
		
		/**
		 * When redispatching, creates an event that bubbles.
		 * If redispatching the original event it inherits the value.
		 * */
		public var bubbles:Boolean;
		
		/**
		 * When redispatching, creates an event that is cancelable. 
		 * If redispatching the original event it inherits the value.
		 * */
		public var cancelable:Boolean;
		
		/**
		 * When true the Control key must be pressed to trigger this event
		 * */
		public var controlKey:Boolean;
		
		/**
		 * When true the Alt key must be pressed to trigger this event
		 * */
		public var altKey:Boolean;
		
		/**
		 * When true the Shift key must be pressed to trigger this event
		 * */
		public var shiftKey:Boolean;
		
		//----------------------------------
		//  target
		//----------------------------------
		
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get target():IEventDispatcher
		{
			if (_targets.length > 0)
				return _targets[0]; 
			else
				return null;
		}
		
		/**
		 *  @private
		 */
		public function set target(value:IEventDispatcher):void {
			if (_targets) removeAllHandlers();
			_targets.splice(0);
			
			if (value) {
				_targets[0] = value;
				addHandlers(value);
			}
		}
		
		//----------------------------------
		//  targets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the targets property.
		 */
		private var _targets:Array = [];
		
		[Inspectable(arrayType="IEventDispatcher")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get targets():Array {
			return _targets;
		}
		
		/**
		 *  @private
		 */
		public function set targets(value:Array):void {
			// remove listeners from previous targets
			var n:int = _targets.length;
			
			//PerformanceMeter.start("adding targets");
			for (var i:int = n - 1; i >= 0; i--) {
				if (_targets[i] == null) {
					continue;
				}
				
				removeHandlers(_targets[i]);
			}
			
			// Strip out null values.
			// Binding will trigger again each time a target is created.
			// NOTE: Data binding runs through all values each time it is dispatched
			// may need to refactor
			n = value.length;
			for (i = n - 1; i >= 0; i--) {
				if (value[i] == null) {
					value.splice(i,1);
					continue;
				}
				
				addHandlers(value[i]);
			}
			
			_targets = value;
			//PerformanceMeter.stop("adding targets");
			
		}
		
		/**
		 * Check for local effects
		 * */
		public function get hasEffects():Boolean {
			return effect || (actions!=null && actions.length>0);
		}
		
		/**
		 * Check for controller effects
		 * */
		public function get hasControllerEffects():Boolean {
			return controllerEffectName!=null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------

		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  eventName
		//----------------------------------
		
		/** 
		 *  @copy mx.effects.IEffect#eventName
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get eventName():String
		{
			if (_eventNames.length > 0)
				return _eventNames[0]; 
			else
				return null;
		}
		
		/**
		 *  @private
		 */
		public function set eventName(value:String):void
		{
			_eventNames.splice(0);
			
			if (value) {
				_eventNames[0] = value;
			}
			
		}
		
		//----------------------------------
		//  eventNames
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the eventNames property.
		 */
		private var _eventNames:Array = [];
		
		[Inspectable(arrayType="String")]
		[ArrayElementType("String")]
		
		/**
		 *  Array of events to listen for on the target. Use eventName if listening for a single event.
		 * 
		 *  @copy mx.effects.IEffect#eventNames
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get eventNames():Array
		{
			return _eventNames;
		}
		
		/**
		 *  @private
		 */
		public function set eventNames(value:Array):void {
			// Strip out null values.
			var n:int = value.length;
			for (var i:int = n - 1; i >= 0; i--)
			{
				if (value[i] == null)
					value.splice(i,1);
			}
			
			_eventNames = value;
		}
		
		//----------------------------------
		//  keyCode
		//----------------------------------
		
		/** 
		 *  The key code of the key pressed. For example, this could be 
		 *  Keyboard.MENU, Keyboard.BACK.
		 * 
		 *  You may need to set the keyboardEventName to keyDown in some cases
		 * 
		 *  @see keyboardEventName
		 * 
		 *  @copy flash.ui.Keyboard
		 *  
		 */
		public function get keyCode():String {
			if (_keyCodes.length > 0)
				return _keyCodes[0];
			else
				return null;
		}
		
		/**
		 *  @private
		 */
		public function set keyCode(value:String):void {
			_keyCodes.splice(0);
			
			if (value) {
				_keyCodes[0] = value;
			}
			
		}
		
		//----------------------------------
		//  keyCodes
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the keyCodes property.
		 */
		private var _keyCodes:Array = [];
		
		[Inspectable(arrayType="String")]
		[ArrayElementType("String")]
		
		/**
		 *  Array of keys to listen for on the target. 
		 *  For example, to listen for the keys A, B and C 
		 *  set this property to Keyboard.A, Keyboard.B, Keyboard.C
		 *  or "65,66,67".
		 *  
		 *  You can use the keyCode property if listening for a single key. 
		 * 
		 *  @copy mx.effects.IEffect#eventNames
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get keyCodes():Array {
			return _keyCodes;
		}
		
		/**
		 *  @private
		 */
		public function set keyCodes(value:Array):void {
			// Strip out null values.
			var n:int = value.length;
			
			for (var i:int = n - 1; i >= 0; i--) {
				if (value[i] == null)
					value.splice(i,1);
			}
			
			_keyCodes = value;
		}
		
		//----------------------------------
		//  keyboardEventName
		//----------------------------------
		
		/** 
		 * Name of event to listen for on key press events.
		 * You typically do not need to set this. 
		 * A keyCode or keyCodes need to be set for this to work. 
		 * If no keyCodes are provided no handlers are added. 
		 * Handlers are added to the stage not the component. 
		 * The default event is "keyUp". The other event is keyDown.
		 * 
		 *  @copy mx.effects.IEffect#eventName
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get keyboardEventName():String {
			if (_keyboardEventNames.length > 0)
				return _keyboardEventNames[0]; 
			else
				return null;
		}
		
		/**
		 *  @private
		 */
		public function set keyboardEventName(value:String):void {
			_keyboardEventNames.splice(0);
			
			if (value) {
				_keyboardEventNames[0] = value;
			}
			
		}
		
		//----------------------------------
		//  keyboardEventNames
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the keyboardEventNames property.
		 */
		private var _keyboardEventNames:Array = [KeyboardEvent.KEY_UP];
		
		[Inspectable(arrayType="String")]
		[ArrayElementType("String")]
		
		/**
		 *  Array of keyboard events to listen for on the target. 
		 * 	Use keyboardEventName if listening for a single event.
		 *  Default is "keyUp".
		 * 
		 *  @copy mx.effects.IEffect#eventNames
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get keyboardEventNames():Array {
			return _keyboardEventNames;
		}
		
		/**
		 *  @private
		 */
		public function set keyboardEventNames(value:Array):void {
			// Strip out null values.
			var n:int = value.length;
			
			for (var i:int = n - 1; i >= 0; i--) {
				if (value[i] == null)
					value.splice(i,1);
			}
			
			_keyboardEventNames = value;
		}
		
		//----------------------------------
		//  misc
		//----------------------------------
		
		/**
		 * Use a week listener
		 * 
		 * @see flash.events.Event
		 * */
		public var weekListener:Boolean;
		
		/**
		 * Priority of event handler
		 * 
		 * @see flash.events.Event
		 * */
		public var priority:int;
		
		/**
		 * Adds the listener to the capture phase.
		 * NOTE: Some objects do NOT dispatch a capture phase event. 
		 * 
		 * @see flash.events.Event
		 * */
		public var respondInCapturePhase:Boolean;
		
		/**
		 * Sets the suspendBackgroundProcessing property on the sequence.
		 * Default is true.
		 * 
		 * @see mx.effects.CompositeEffect.suspendBackgroundProcessing
		 * */
		public var suspendBackgroundProcessing:Boolean = true;
		
		/**
		 * Sets the event to the current event.
		 * 
		 * @see setTriggerEvent
		 * @see keepEventTargets
		 * */
		public var keepEvent:Boolean = true;
		
		/**
		 * Sets the eventTarget and currentTarget properties to the current event.
		 * This enables data binding to those properties.
		 * Default is false.
		 * 
		 * @see setTriggerEvent
		 * @see keepEvent
		 * */
		public var keepEventTargets:Boolean;
		
		/**
		 * Sets the event to the triggerEvent property of the root effect.
		 * 
		 * @see mx.effects.Effect.triggerEvent
		 * @see keepEvent
		 * @see keepEventTargets
		 * */
		public var setTriggerEvent:Boolean;
		
		/**
		 * When set to true the target property of the main sequence
		 * is set to the event.currentTarget property.
		 * If child effects do not have their target property set 
		 * then they will inherit the target from the main sequence
		 * since the main sequence effect is a composite effect.
		 * If this property is true then they will inherit the 
		 * current target. 
		 * 
		 * @see mx.effects.CompositeEffect.target
		 * */
		public var setRootEffectToTarget:Boolean;
		
		/**
		 * If set to before then redispatches events before any effects are run.
		 * If set to after then redispatches events and runs event function after 
		 * effects sequence ends.
		 * If set to during or null then redispatches events and runs event function 
		 * immediately after the action sequence starts
		 * 
		 * @see EventHandler.controller
		 * @see EventHandler.dispatchName
		 * */
		[Inspectable(enumeration="before,during,after")]
		public var redispatchDuring:String;
		
		/**
		 * If set to before then plays the effect before any effects are run.
		 * If set to after then plays effects after effects ends.
		 * 
		 * @see EventHandler.controller
		 * @see EventHandler.staticController
		 * @see EventHandler.controllerEffect
		 * @see EventHandler.controllerEffectName
		 * */
		[Inspectable(enumeration="before,after")]
		public var playControllerEffectDuring:String;
		
		/**
		 * If set to an object of type IEventDispatcher 
		 * then redispatches the event 
		 * */
		[Bindable]
		public var redispatchToTarget:IEventDispatcher;
		
		/**
		 * Name of event when redispatching the current event 
		 * */
		[Bindable]
		public var dispatchName:String;
		
		/**
		 * If set then runs the effect of the same name on a controller. 
		 * This effect can run before or after any locally defined effects
		 * by setting the playControllerEffectDuring.
		 * 
		 * @see EventHandler.controller
		 * @see EventHandler.staticController
		 * @see EventHandler.controllerEffect
		 * @see EventHandler.playControllerEffectDuring
		 * */
		[Bindable]
		public var controllerEffectName:String;
		
		/**
		 * Name of function to run (if set). 
		 * The function is passed the event function arguments if provided
		 * and returns any result to the event function result object . 
		 * 
		 * @see EventHandler.eventFunctionArguments
		 * @see EventHandler.eventFunctionResult
		 * */
		[Bindable]
		public var eventFunction:Function;
		
		/**
		 * The result if provided from a call to the eventFunction. 
		 * 
		 * @see EventHandler.eventFunction
		 * @see EventHandler.eventFunctionArguments
		 * */
		[Bindable]
		public var eventFunctionResult:Object;
		
		/**
		 * Array of arguments to pass to the event function
		 * 
		 * @see EventHandler.eventFunction
		 * @see EventHandler.eventFunctionResult
		 * */
		[Bindable]
		public var eventFunctionArguments:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds event listeners to the target component including keyboard listeners if specified.
		 * Adds keyboard listeners to the target and the stage. This doesn't always seem to catch 
		 * all keyboard events. Even if the component has focus and the stage has focus we can still miss 
		 * keyboard events... I think. 
		 * 
		 * @see EventHandler.keyboardEventNames
		 * @see EventHandler.keyCodes
		 * */
		private function addHandlers(targetObject:IEventDispatcher):void {
			var keyboardEventLength:int = keyboardEventNames ? keyboardEventNames.length : 0;
			var events:Array = _eventNames ? _eventNames : [eventName];
			var length:int = events.length;
			var systemManager:DisplayObject;
			var eventName:String;
			var i:int;
			
			// check for required properties
			if (keyCodes.length>0 && keyboardEventLength==0) {
				throw new Error("Keycodes are assigned but no keyboard events are specified.");
			}
			
			// NOTE: DO WE NEED TO SUPPORT MULTIPLE TARGETS???
			// NO! This method is called for each target. 
			// We may want to change it later
			
			// add listeners
			if (targetObject && targetObject is IEventDispatcher) {
				
				//if (targets.length>1) throw new Error("add support"); // we maybe want to remove this?
				
				// add event listeners for each event specified
				for (i=0;i<length;i++) {
					eventName = eventNames[i];
					
					// double click will not work without this property enabled
					if (eventName=="doubleClick" && "doubleClickEnabled" in targetObject) {
						targetObject["doubleClickEnabled"] = true;
					}
					
					targetObject.addEventListener(eventName, eventHandler, respondInCapturePhase, priority, weekListener);
				}
				
			}
			
			
			// add keyboard listeners
			if (keyCodes.length>0) {
				systemManager = SystemManager.getSWFRoot(targetObject);
				
				for (i=0;i<keyboardEventNames.length;i++) {
					
					// Note: the keyboard events aren't always triggered when
					// the target doesn't have focus
					// we can add to stage to catch events
					
					if (addKeyListenersToStage) {
						systemManager.stage.addEventListener(keyboardEventNames[i], keyboardEventHandler, respondInCapturePhase, priority, weekListener);
					}
					
					if (targetObject) {
						targetObject.addEventListener(keyboardEventNames[i], keyboardEventHandler, respondInCapturePhase, priority, weekListener);
					}
				}
			}
			
		}
		
		/**
		 * Removes the handlers added to the target passed in
		 * */
		private function removeHandlers(value:IEventDispatcher):void {
			var events:Array = _eventNames ? _eventNames : [eventName];
			var length:int = events.length;
			var i:int;
			
			// if target changes remove previous listeners
			if (value && value is IEventDispatcher) {
				for (i=0;i<length;i++) {
					value.removeEventListener(events[i], eventHandler, respondInCapturePhase);
				}
			}
			
		}
	
		/**
		 * Removes all the handlers on all targets
		 * */
		private function removeAllHandlers():void {
			var events:Array = _eventNames ? _eventNames : [eventName];
			var eventsLength:int = events.length;
			var targetsLength:int = targets.length;
			var item:Object;
			var i:int;
			var j:int;
			
			
			for (;i<targetsLength;i++) {
				item = targets[i];
				
				// if target changes remove previous listeners
				if (item && item is IEventDispatcher) {
					for (j=0;j<eventsLength;j++) {
						item.removeEventListener(events[j], eventHandler, respondInCapturePhase);
					}
				}
			}
			
		}
		
		/**
		 * By default the target is the parent document of the tag. 
		 * This function is called by Flex automatically when the document 
		 * is created. 
		 * */
		public function initialized(document:Object, id:String):void {
			
			if (target==null) {
				target = document as IEventDispatcher;
			}
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Method that is called when the keyboard event is dispatched.
		 * This plays the sequence of actions defined in the actions
		 * array or plays the sequence referenced in the sequence property.
		 * */
		public function keyboardEventHandler(keyEvent:KeyboardEvent):void {
			var keyCode:uint = keyEvent.keyCode;
			var length:int = keyboardEventNames.length;
			var keyFound:Boolean;
			var i:int;
			
			if (!enabled) {
				if (EventHandler.debugHandlers) trace("Note: The " + eventName + " event handler is disabled");
				return;
			}
			
			// criteria requires alternative key
			if (altKey && !keyEvent.altKey) {
				return;
			}
			
			// criteria requires control key
			if (controlKey && !keyEvent.ctrlKey) {
				return;
			}
			
			// criteria requires shift key
			if (shiftKey && !keyEvent.shiftKey) {
				return;
			}
			
			// key matches key code
			for (i=0;i<length;i++) {
				if (keyCode==keyCodes[i]) {
					handlingKeyCode = keyCodes[i];
					keyFound = true;
					break;
				}
			}
			
			// exit if key is not found
			if (!keyFound) return;
			
			// handle prevent default
			if (preventDefaultKeyboardEvent) {
				keyEvent.preventDefault();
				
				keyEventPreventDefaulted = keyEvent.isDefaultPrevented();
				
				if (!keyEventPreventDefaulted) {
					if (EventHandler.debugHandlers) trace ("Could not prevent key event from bubbling");
				}
			}
			
			// prevents keyboard listener on stage if key handler on target has
			// handled the same event
			if (keyEvent!=this.event) {
				this.event = keyEvent;
				eventHandler(keyEvent);
			}
			
		}
		
		/**
		 * Method that is called when the event is dispatched.
		 * This plays the sequence of actions defined in the actions
		 * array, plays the sequence referenced in the sequence property 
		 * or redispatches the event on the static controller property 
		 * (or public controller property) if either are set. 
		 * When redispatching events the dispatchName must be set (in addition to the 
		 * static or local controller). The controller must be set before the 
		 * event occurs. Usually you set this property in the creation complete of the
		 * application.
		 * 
		 * */
		public function eventHandler(currentEvent:Event = null):void {
			var eventName:String = currentEvent.type;
			//var compositeEffect:CompositeEffect = effect as CompositeEffect;
			
			if (!enabled) {
				if (EventHandler.debugHandlers) trace("Note: The " + eventName + " event handler is disabled");
				return;
			}
			
			if (debugHandlers || traceHandler) {
				trace("Event Handler: " + eventName + " from " + (currentEvent.currentTarget));
			}
			
			if (EventHandler.enterDebuggerOnEvent) {
				enterDebugger();
			}
			
			// store event
			if (keepEvent) {
				event = currentEvent;
			}
			
			// we do this since event.target is not bindable
			if (keepEventTargets) {
				eventTarget = currentEvent.target;
				currentTarget = currentEvent.currentTarget;
			}
			
			
			// dispatch start event
			if (hasEventListener(EVENT_START)) {
				dispatchEvent(new Event(EVENT_START, bubbles, cancelable));
			}
			
			// redispatch before running any effects
			if (redispatchDuring==BEFORE) {
				redispatch(event);
			}
			
			
			// call a function and return the results
			if (eventFunction!=null) {
				if (eventFunctionArguments!=null) {
					eventFunctionResult = eventFunction.apply(this, eventFunctionArguments);
				}
				else {
					eventFunctionResult = eventFunction.apply(this);
				}
			}
			
			
			// if controller effects exist and property is before then play first
			if (hasControllerEffects && playControllerEffectDuring==null || playControllerEffectDuring==BEFORE) {
				playControllerEffect();
			}
			else if (hasEffects) {
				playEffect();
			}
			
			// redispatch events 
			// default is to dispatch immediately
			if (redispatchDuring==null || redispatchDuring==DURING) {
				redispatch(event);
			}
			
			// This is not always the end of the sequence - see effect end
			if (hasEventListener(EVENT_END)) {
				dispatchEvent(new Event(EVENT_END, bubbles, cancelable));
			}
			
			if (stopPropagation) {
				event.stopPropagation();
			}
			
			if (stopImmediatePropagation) {
				event.stopImmediatePropagation();
			}
			
			if (preventDefault) {
				event.preventDefault();
			}
		}
		
		/**
		 * Plays controller effect
		 * */
		public function playControllerEffect():void {
			var controllerEffect:IEffect;
			
			// reference to static controller effect
			if (staticController!=null && controllerEffectName!=null) {
				controllerEffect = staticController[controllerEffectName];
			}
			
			// reference to controller effect
			if (controller!=null && controllerEffectName!=null) {
				controllerEffect = controller[controllerEffectName];
			}
			
			// when the trigger event has been null and the element has been removed 
			// or is being removed from the stage then it throws a TypeError
			// since the effect trigger event is null. 
			
			// set this to true to avoid the following error
			// TypeError: Error #1009: Cannot access a property or method of a null object reference.
			//	at mx.effects::EffectManager$/http://www.adobe.com/2006/flex/mx/internal::eventHandler()[E:\dev\4.y\frameworks\projects\framework\src\mx\effects\EffectManager.as:605]
			//	at flash.display::DisplayObjectContainer/removeChild()
			if (setTriggerEvent) {
				controllerEffect.triggerEvent = event;
			}
			
			if (setRootEffectToTarget) {
				if (controllerEffect.target!=event.currentTarget) {
					controllerEffect.target = event.currentTarget;
				}
			}
			
			if (controllerEffect is CompositeEffect) {
				CompositeEffect(controllerEffect).suspendBackgroundProcessing = suspendBackgroundProcessing;
			}
			
			// we really only add these to so we can know when the effect ends to know when to play 
			// the local effects
			// - these may not be as reliable if an effect is multiuse
			controllerEffect.addEventListener(EffectEvent.EFFECT_START, controllerEffectStart, false, 0, true);
			controllerEffect.addEventListener(EffectEvent.EFFECT_END, controllerEffectEnd, false, 0, true);
			
			controllerEffect.play();
		}
		
		/**
		 * Plays effects
		 * */
		public function playEffect():void {
			
			// when the trigger event has been null and the element has been removed 
			// or is being removed from the stage then it throws a TypeError
			// since the effect trigger event is null. 
			
			// set this to true to avoid the following error
			// TypeError: Error #1009: Cannot access a property or method of a null object reference.
			//	at mx.effects::EffectManager$/http://www.adobe.com/2006/flex/mx/internal::eventHandler()[E:\dev\4.y\frameworks\projects\framework\src\mx\effects\EffectManager.as:605]
			//	at flash.display::DisplayObjectContainer/removeChild()
			if (setTriggerEvent) {
				effect.triggerEvent = event;
			}
			
			if (setRootEffectToTarget) {
				if (effect.target!=event.currentTarget) {
					effect.target = event.currentTarget;
				}
			}
			
			if (stopPlayingEffects) {
				if (effect.isPlaying) effect.stop();
			}
			
			if (endPlayingEffects) {
				if (effect.isPlaying) effect.end();
			}
			
			_effect.addEventListener(EffectEvent.EFFECT_START, effectStart, false, 0, true);
			_effect.addEventListener(EffectEvent.EFFECT_END, effectEnd, false, 0, true);
			
			// if the effects are not being played make sure the target on the effect is not null
			effect.play();
		}
		
		/**
		 * Handles redispatching and eventFunction
		 * */
		public function redispatch(event:Event):void {
			
			
			// There's probably a better way to do this - ie tying everything together
			// or handing off the event to another handler instance / etc
			// but for now we do it this way. 
			// something to refactor...
			
			// redispatch events to another static handler
			if (staticController!=null && dispatchName!=null) {
				staticController.dispatchEvent(new Event(dispatchName, bubbles, cancelable));
			}
			
			// redispatch events to another handler
			if (controller!=null && dispatchName!=null) {
				controller.dispatchEvent(new Event(dispatchName, bubbles, cancelable));
			}
			
			// redispatch events to another handler
			if (redispatchToTarget) {
				if (dispatchName!=null) {
					redispatchToTarget.dispatchEvent(new Event(dispatchName, bubbles, cancelable));
				}
				else {
					redispatchToTarget.dispatchEvent(event);
				}
			}
		}
		
		
	}
}
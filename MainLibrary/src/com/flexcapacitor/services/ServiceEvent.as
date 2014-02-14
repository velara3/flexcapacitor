
package com.flexcapacitor.services {
	import flash.events.Event;
	
	
	/**
	 * Event dispatched when result or fault is received from a service
	 * */
	public class ServiceEvent extends Event implements IServiceEvent {
		
		/**
		 * Constructor.
		 * */
		public function ServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Dispatched when results are returned from the server
		 * */
		public static const RESULT:String = "result";
		
		/**
		 * Dispatched when there is a fault in the service call
		 * */
		public static const FAULT:String = "fault";
		

		private var _text:String;

		/**
		 * Text result from server
		 * */
		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		private var _data:Object;

		/**
		 * Object returned from the server
		 * */
		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}


		private var _resultEvent:Event;

		public function get resultEvent():Event {
			return _resultEvent;
		}

		public function set resultEvent(value:Event):void {
			_resultEvent = value;
		}

		
		private var _faultEvent:Event;

		public function get faultEvent():Event {
			return _faultEvent;
		}

		public function set faultEvent(value:Event):void {
			_faultEvent = value;
		}
		
		override public function clone():Event {
			return new ServiceEvent(type, bubbles, cancelable);
		}
	}
}
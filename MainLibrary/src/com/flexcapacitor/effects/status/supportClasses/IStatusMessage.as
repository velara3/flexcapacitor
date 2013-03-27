package com.flexcapacitor.effects.status.supportClasses {
	
	/**
	 * Interface for use by Status Message component
	 * */
	public interface IStatusMessage {
		function set message(value:String):void;
		function get message():String;
		function set title(value:String):void;
		function get title():String;
		function set duration(value:int):void;
		function get duration():int;
		function set fadeInDuration(value:int):void;
		function get fadeInDuration():int;
		function set showBusyIndicator(value:Boolean):void;
		function get showBusyIndicator():Boolean;
	}
}
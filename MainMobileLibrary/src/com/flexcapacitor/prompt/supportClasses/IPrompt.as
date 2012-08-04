package com.flexcapacitor.prompt.supportClasses {
	
	
	public interface IPrompt {
		function set message(value:String):void;
		function get message():String;
		function set title(value:String):void;
		function get title():String;
		function set duration(value:int):void;
		function get duration():int;
		function set icon(value:String):void;
		function get icon():String;
		function set buttons(value:String):void;
		function get buttons():String;
	}
}
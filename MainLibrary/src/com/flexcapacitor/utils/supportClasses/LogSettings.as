package com.flexcapacitor.utils.supportClasses
{
	public class LogSettings
	{
		public static var lastClassName:String;
		public static var lastFunctionName:String;
		public static var lastMessage:String;
		public static var lastLogFunction:Function;
		public static var showLineNumber:Boolean = false;
		public static var showClassName:Boolean = true;
		public static var showFunctionName:Boolean = true;
		public static var showQualifiedClassNames:Boolean = false;
		public static var messageShownCount:int;
		public static var maxMessageRepeat:int = 3;
		public static var maxMessageShown:Boolean;
		
		public function LogSettings()
		{
		}
	}
}
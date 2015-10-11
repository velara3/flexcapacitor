package com.flexcapacitor.controls
{
	import mx.core.IDeferredInstantiationUIComponent;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.managers.ILayoutManagerClient;

	public interface IAceEditor extends IUIComponent, IVisualElement, IInvalidating,
										ILayoutManagerClient, IDeferredInstantiationUIComponent
	{
		function get text():String;
		function set text(value:String):void;
		function get mode():String;
		function set mode(value:String):void;
		function get isReadOnly():Boolean;
		function set isReadOnly(value:Boolean):void;
		function get showFoldWidgets():Boolean;
		function set showFoldWidgets(value:Boolean):void;
		function get showGutter():Boolean;
		function set showGutter(value:Boolean):void;
		function get margin():String;
		function set margin(value:String):void;
		function get useWordWrap():Boolean;
		function set useWordWrap(value:Boolean):void;
		function get scrollSpeed():Number;
		function set scrollSpeed(value:Number):void;
		
	}
}

package com.flexcapacitor.controls {
	import mx.core.IUIComponent;
	
	
	/**
	 * Defines an interface for a WebView control. 
	 * 
	 * This is incomplete. 
	 * */
	public interface IWebView extends IUIComponent {
		
		
	    function get contentHeight():Number;
	    
	    /**
	     *  @private
	     */
	    function set contentHeight(value:Number):void;
		
	    function get contentWidth():Number;
	    
	    /**
	     *  @private
	     */
	    function set contentWidth(value:Number):void;
		
		
	    function loadString(value:String, mimeType:String = "text/html"):void;
	}
}
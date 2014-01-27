
package com.flexcapacitor.controls {
	import flash.events.MouseEvent;
	import mx.core.mx_internal;
		
	import spark.components.VScrollBar;
	import spark.core.IViewport;
	
	use namespace mx_internal;
     
    [Style(name="movementDelta", inherit="yes", type="number", format="length")]
	
	/**
	 * Adds scroll speed. 
	 * 
	 * Credit - http://flex4examples.wordpress.com/2011/05/18/flex-4-vertical-scroll-speed/
	 * */
    public class VScrollBar extends spark.components.VScrollBar
    {
        public function VScrollBar()
        {
            setStyle("movementDelta", 10);
        }
         
        override mx_internal function mouseWheelHandler(event:MouseEvent):void
        {
            var viewport:IViewport = this.viewport;
            if ( viewport == null || !viewport.visible || event.isDefaultPrevented() )
                return;
             
            var delta:Number = event.delta;
            var direction:int = (event.delta > 0) ? -1 : (event.delta < 0) ? 1 : 0;
            var movement:Number = getStyle("movementDelta");
            viewport.verticalScrollPosition += movement * direction;
            event.preventDefault();
        }
 
    }
}
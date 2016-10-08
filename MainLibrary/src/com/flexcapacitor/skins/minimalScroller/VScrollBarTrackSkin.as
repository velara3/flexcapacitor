////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.skins.minimalScroller
{

import mx.core.DPIClassification;
import mx.core.mx_internal;

import spark.components.Button;

use namespace mx_internal;


/**
 *  ActionScript-based skin for the VScrollBar track skin part in mobile applications. 
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5 
 *  @productversion Flex 4.5
 */
public class VScrollBarTrackSkin extends MinimalSkin
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    // These constants are also accessed from VScrollBarSkin
    mx_internal static const PADDING_RIGHT_320DPI:int = 5;
    mx_internal static const PADDING_VERTICAL_320DPI:int = 4;
    mx_internal static const PADDING_RIGHT_240DPI:int = 4;
    mx_internal static const PADDING_VERTICAL_240DPI:int = 3;
    mx_internal static const PADDING_RIGHT_DEFAULTDPI:int = 3;
    mx_internal static const PADDING_VERTICAL_DEFAULTDPI:int = 2;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-------------------------------------------------------------------------- 
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5 
     *  @productversion Flex 4.5
     * 
     */
    public function VScrollBarTrackSkin()
    {
        super();
        
        // Depending on density set padding
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                paddingRight = PADDING_RIGHT_320DPI;
                paddingVertical = PADDING_VERTICAL_320DPI;
                break;
            }
            case DPIClassification.DPI_240:
            {
                paddingRight = PADDING_RIGHT_240DPI;
                paddingVertical = PADDING_VERTICAL_240DPI;
                break;
            }
            default:
            {
                paddingRight = PADDING_RIGHT_DEFAULTDPI;
                paddingVertical = PADDING_VERTICAL_DEFAULTDPI;
                break;
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    /** 
     * @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:Button;
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	/**
	 *  Padding from the right
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */ 
	protected var paddingRight:int;
    
    /**
     *  Vertical padding from top and bottom
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */ 
    protected var paddingVertical:int;
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------	
    
    /**
     *  @protected
     */ 
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);
		
		var paddingLeft:uint	= getStyle("paddingLeft");
        var thumbWidth:Number 	= unscaledWidth - paddingRight - paddingLeft;
        
        graphics.beginFill(0, 0);
		graphics.drawRect(0.5+paddingLeft, paddingVertical + 0.5, thumbWidth, unscaledHeight - 2 * paddingVertical);
        graphics.endFill();
    }
    
}
}
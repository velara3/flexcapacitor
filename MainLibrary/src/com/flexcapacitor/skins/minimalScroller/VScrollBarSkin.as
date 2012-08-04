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
import spark.components.VScrollBar;

use namespace mx_internal;

/**
 * Padding from the content and the left edge of the scrollbar.
 * It differs from minViewportInset in that it only affects 
 * the left of the scrollbar rather than the all edges of the content.
 * */
[Style(name="paddingLeft", inherit="no", type="uint")]

/**
 *  ActionScript-based skin for VScrollBar components in mobile applications. 
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5 
 *  @productversion Flex 4.5
 */
public class VScrollBarSkin extends MobileSkin
{
    
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
    public function VScrollBarSkin()
    {
        super();
        
        minHeight = 20;
        thumbSkinClass = VScrollBarThumbSkin;
        var paddingRight:int;
        var paddingVertical:int;
        
		minWidth = 11;
		paddingRight = VScrollBarThumbSkin.PADDING_RIGHT_DEFAULTDPI;
		paddingVertical = VScrollBarThumbSkin.PADDING_VERTICAL_DEFAULTDPI;
        
        // The minimum height is set such that, at it's smallest size, the thumb appears
        // as high as it is wide.
        minThumbHeight = (minWidth - paddingRight) + (paddingVertical * 2);   
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /** 
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:VScrollBar;
    
    /**
     *  Minimum height for the thumb
     */
    protected var minThumbHeight:Number;
    
    /**
     *  Skin to use for the thumb Button skin part
     */
    protected var thumbSkinClass:Class;
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts 
    //
    //--------------------------------------------------------------------------
    /**
     *  VScrollbar track skin part
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5 
     *  @productversion Flex 4.5
     */   
    public var track:Button;
    
    /**
     *  VScrollbar thumb skin part
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5 
     *  @productversion Flex 4.5
     */  
    public var thumb:Button;
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    /**
     *  @private 
     */
    override protected function createChildren():void
    {
        // Create our skin parts if necessary: track and thumb.
        if (!track)
        {
            // We don't want a visible track so we set the skin to MobileSkin
            track = new Button();
            track.setStyle("skinClass", MobileSkin);
            track.width = minWidth;
            track.height = minHeight;
            addChild(track);
        }
        if (!thumb)
        {
            thumb = new Button();
            thumb.minHeight = minThumbHeight; 
            thumb.setStyle("skinClass", thumbSkinClass);
            thumb.setStyle("paddingLeft", getStyle("paddingLeft"));
            thumb.width = minWidth;
            thumb.height = minWidth;
            addChild(thumb);
        }
    }
    
    /**
     *  @private 
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);
        
        setElementSize(track, unscaledWidth, unscaledHeight);
    }
}
}
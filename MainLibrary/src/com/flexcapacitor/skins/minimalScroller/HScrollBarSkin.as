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
import spark.components.HScrollBar;

use namespace mx_internal;

/**
 * Padding from the top of the scroll bar and the bottom edge of the content.
 * This differs from minViewportInset in that it only affects 
 * the top edge of the scrollbar rather than all the edges of the content.
 * */
[Style(name="paddingTop", inherit="no", type="uint")]

/**
 *  ActionScript-based skin for HScrollBar components in mobile applications. 
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5 
 *  @productversion Flex 4.5
 */
public class HScrollBarSkin extends MinimalSkin
{   
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function HScrollBarSkin()
    {
        super();
        
        minWidth = 20;
        thumbSkinClass = HScrollBarThumbSkin;
        var paddingBottom:int;
        var paddingHorizontal:int;
		
		minHeight = 11;
		paddingBottom = HScrollBarThumbSkin.PADDING_BOTTOM_DEFAULTDPI;
		paddingHorizontal = HScrollBarThumbSkin.PADDING_HORIZONTAL_DEFAULTDPI;
        
        // The minimum width is set such that, at it's smallest size, the thumb appears
        // as wide as it is high.
        minThumbWidth = (minHeight - paddingBottom) + (paddingHorizontal * 2);
		
		trackSkinClass = HScrollBarTrackSkin;  
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /** 
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:HScrollBar;
    
    /**
     *  Minimum width for the thumb 
     */
    protected var minThumbWidth:Number;
    
    /**
     *  Skin to use for the thumb Button skin part
     */
    protected var thumbSkinClass:Class;
    
    /**
     *  Skin to use for the track Button skin part
     */
    protected var trackSkinClass:Class;
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts 
    //
    //--------------------------------------------------------------------------
    /**
     *  HScrollbar track skin part.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5 
     *  @productversion Flex 4.5
     */  
    public var track:Button;
    
    /**
     *  HScrollbar thumb skin part.
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
            track.setStyle("skinClass", trackSkinClass);
            track.width = minWidth;
            track.height = minHeight;
            addChild(track);
        }
        
        if (!thumb)
        {
            thumb = new Button();
            thumb.minWidth = minThumbWidth;
            thumb.setStyle("skinClass", thumbSkinClass);
			thumb.setStyle("paddingTop", getStyle("paddingTop"));
            thumb.width = minHeight;
            thumb.height = minHeight;
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
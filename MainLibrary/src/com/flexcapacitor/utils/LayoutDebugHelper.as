////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.utils
{

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import mx.core.ILayoutElement;
import mx.managers.ISystemManager;
import mx.managers.SystemManagerGlobals;


/**
 *  The LayoutDebugHelper class renders the layout bounds for the most
 *  recently validated visual items.
 * 
 * Adapted from import mx.managers.layoutClasses.LayoutDebugHelper;
 */
public class LayoutDebugHelper extends Sprite {
    //include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LayoutDebugHelper() {
        super();
        activeInvalidations = new Dictionary();
        addEventListener("enterFrame", onEnterFrame);
		
    }
	
	public static var automaticEnableDisable:Boolean = true;
	
    /**
     *  @private
     *  The sole instance of this singleton class.
     */
    private static var instance:LayoutDebugHelper;
	
	public static function getInstance():LayoutDebugHelper {
        if (!instance)
            instance = new LayoutDebugHelper();

        return instance;
    }
	
    public function enable():void {
        if (!instance) {
            instance = getInstance();
		}
		
        Object(instance).mouseEnabled = false;
        var sm:ISystemManager = SystemManagerGlobals.topLevelSystemManagers[0]
        sm.addChild(instance);
		
		
		if (automaticEnableDisable && !hasEventListener("enterFrame")) {
			addEventListener("enterFrame", onEnterFrame);
		}
		trace("enabling layout debug helper");
       // return instance;
    }
	
    public function disable():void {
        if (instance) {
            var sm:ISystemManager = SystemManagerGlobals.topLevelSystemManagers[0];
			var index:int;
			
			if (instance.stage && instance.parent) {
				index = sm.getChildIndex(instance);
			}
			
			if (index!=-1) {
	            sm.removeChildAt(index);
			}
        }
		
		if (automaticEnableDisable) {
			removeEventListener("enterFrame", onEnterFrame);
		}
		
		trace("disabling layout debug helper");
       // return instance;
    }
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  
     */
    public static const highlightDelay:Number = 2500;
    
    /**
     *  @private
     */
    public static const highlightColor:Number = 0xFF00;
    
    /**
     *  @private
     */
    public var activeInvalidations:Dictionary;
    
    /**
     *  @private
     */
    private var lastUpdate:Number = 0;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    private static var _layoutDebugHelper:Boolean;

    /**
     *  @private
     */
    public function addElement(item:ILayoutElement):void
    {       
        activeInvalidations[item] = getTimer();
		
		if (hasItems() && automaticEnableDisable) {
			enable();
		}
    }
	
	public function hasItems():Boolean {
		var index:int;
		for (var key:Object in activeInvalidations) {
			index++;
		}
		return index!=0;
	}
    
    /**
     *  @private
     */
    public function removeElement(item:ILayoutElement):void
    {       
        activeInvalidations[item] = null;
        delete activeInvalidations[item];
		
		if (automaticEnableDisable) {
			if (!hasItems()) {
				disable();
			}
		}
    }
   
    /**
     *  @private
     */
    public function render():void
    {       
        graphics.clear();
        for (var item:* in activeInvalidations)
        {
            var lifespan:Number = getTimer() - activeInvalidations[item];
            if (lifespan > highlightDelay) 
            {
                removeElement(item);
            }
            else
            {
                var alpha:Number = 1.0 - (lifespan / highlightDelay);

                if (item.parent)
                { 
                    var w:Number = item.getLayoutBoundsWidth(true);
                    var h:Number = item.getLayoutBoundsHeight(true);
                    
                    var position:Point = new Point();
                    position.x = item.getLayoutBoundsX(true);
                    position.y = item.getLayoutBoundsY(true);
                    position = item.parent.localToGlobal(position);
                    
                    graphics.lineStyle(2, highlightColor, alpha);        
                    graphics.drawRect(position.x, position.y, w, h);
                    graphics.endFill();         
               }
            }
        }
		if (automaticEnableDisable) {
			if (!hasItems()) {
				disable();
			}
		}
    }
	
	/**
	 * Get a rectangle of the item
	 * */
	public function getRectangleBounds(item:Object, container:* = null):Rectangle {
	
        if (item && item.parent) { 
            var w:Number = item.getLayoutBoundsWidth(true);
            var h:Number = item.getLayoutBoundsHeight(true);
            
            var position:Point = new Point();
            position.x = item.getLayoutBoundsX(true);
            position.y = item.getLayoutBoundsY(true);
            position = item.parent.localToGlobal(position);
			
			var rectangle:Rectangle = new Rectangle();
			
			if (container && container is DisplayObjectContainer) {
				var anotherPoint:Point = DisplayObjectContainer(container).globalToLocal(position);
				rectangle.x = anotherPoint.x;
				rectangle.y = anotherPoint.y;
			}
			else {
				rectangle.x = position.x;
				rectangle.y = position.y;
			}
            
			rectangle.width = w;
			rectangle.height = h;
			
			return rectangle;
       }
		
		return null;
	}
    
    /**
     *  @private
     */
    public function onEnterFrame(e:Event):void
    {       
        if (getTimer() - lastUpdate >= 100)
        {
			trace("rendering layout debug helper");
            render();
            lastUpdate = getTimer();
        }
    }
}

}

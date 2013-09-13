
package com.flexcapacitor.utils {
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	import com.flexcapacitor.utils.supportClasses.GroupOptions;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.BitmapAsset;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.managers.ISystemManager;
	
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.Skin;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.SpriteVisualElement;
	import spark.skins.IHighlightBitmapCaptureClient;
	
	/**
	 * Utils used to manipulate the component tree and display list tree
	 * */
	public class DisplayObjectUtils {
		
		public static const HEXIDECIMAL_HASH_COLOR_TYPE:String = "hexidecimalHash";
		public static const HEXIDECIMAL_COLOR_TYPE:String = "hexidecimal";
		public static const STRING_UINT_COLOR_TYPE:String = "stringUint";
		public static const NUMBER_COLOR_TYPE:String = "number";
		public static const UINT_COLOR_TYPE:String = "uint";
		public static const INT_COLOR_TYPE:String = "int";
		
		public function DisplayObjectUtils() {
			
		}
		
		/**
		 * Keep a reference to groups that have mouse enabled where transparent 
		 * and mouse handler support added when addGroupMouseSupport is called
		 * Stored so it can be removed with removeGroupMouseSupport
		 * */
		public static var applicationGroups:Dictionary = new Dictionary(true);
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns it in a container Sprite 
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 */
		public static function getSpriteSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):Sprite {
			var bounds:Rectangle = target.getBounds(target);
			var bitmapData:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, useAlpha, 0x00000000);
			var matrix:Matrix = new Matrix();
			var container:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			bitmapData.draw(target, matrix);
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			return container;
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap data
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 * 
		 * 
		 * PROBLEMS
		 * The images and edges are clipped on some objects. 
		 */
		public static function getBitmapDataSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):BitmapData {
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var bitmapData:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, useAlpha, 0x00000000);
			var matrix:Matrix = new Matrix();
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			bitmapData.draw(target, matrix);
			
			// new
			var container:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			bitmapData.draw(container);
			
			// added april 2013
			/*targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, useAlpha, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);*/
			
			return bitmapData;
		}
		
		
		/**
		 * Creates a snapshot of the display object passed to it
		 * April 2013
		 **/
		public static function getBitmapAssetSnapshot2(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000):BitmapAsset {
			//var bounds:Rectangle = target.getBounds(target);
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var bitmapData:BitmapData = new BitmapData((targetWidth + horizontalPadding) * scaleX, (targetHeight + verticalPadding) * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left+horizontalPadding/2, -bounds.top+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				trace( "Can't get display object preview. " + e.message);
				// show something here
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);
			
			var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData2, PixelSnapping.ALWAYS);
			
			return bitmapAsset;
		}
		
		/**
		 * Gets top level coordinate space. 
		 * */
		public static function getTopTargetCoordinateSpace():DisplayObject {
			
			// if selection is offset then check if using system manager sandbox root or top level root
			var systemManager:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			
			// no types so no dependencies
			var marshallPlanSystemManager:Object = systemManager.getImplementation("mx.managers.IMarshallPlanSystemManager");
			var targetCoordinateSpace:DisplayObject;
			
			if (marshallPlanSystemManager && marshallPlanSystemManager.useSWFBridge()) {
				targetCoordinateSpace = Sprite(systemManager.getSandboxRoot());
			}
			else {
				targetCoordinateSpace = Sprite(FlexGlobals.topLevelApplication);
			}
			
			return targetCoordinateSpace;
		}
		
		/**
		 * Get bitmap data of the display object passed to it
		 * padding doesn't seem to work
		 * April 2013
		 **/
		public static function getBitmapDataSnapshot2(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000, smoothing:Boolean = false):BitmapData {
			var targetX:Number = target.x;
			var targetY:Number = target.y;
			var reportedWidth:Number = target.width;
			var reportedHeight:Number = target.height;
			
			var rect1:Rectangle = target.getRect(getTopTargetCoordinateSpace());
			var rect:Rectangle = target.getRect(target);
			var bounds:Rectangle = target.getBounds(target);
			var bounds2:Rectangle = target.getBounds(target.parent);
			
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var topLevel:Sprite = Sprite(FlexGlobals.topLevelApplication.systemManager.getSandboxRoot());
			//var topLevel:Sprite = Sprite(Object(target.parent).systemManager.getSandboxRoot());
			var bounds3:Rectangle = target.getBounds(topLevel);
			var bitmapData:BitmapData = new BitmapData((targetWidth + horizontalPadding) * scaleX, (targetHeight + verticalPadding) * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			var translateX:Number = -bounds.left+horizontalPadding/2;
			var translateY:Number = -bounds.top+verticalPadding/2;
			
			matrix.translate(translateX, translateY);
			//matrix.translate(0, 0);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//trace( "Can't get display object preview. " + e.message);
				// show something here
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, smoothing);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			return bitmapData;
			
			targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);
			
			return bitmapData2;
		}
		
		
		/**
		 *  ALSO Graphic element has a getSnapshot method. 
		 * 
		 * */
			
	
	    /**
	     *  Returns a bitmap snapshot of the GraphicElement.
	     *  The bitmap contains all transformations and is reduced
	     *  to fit the visual bounds of the object.
	     *  
	     *  @param transparent Whether or not the bitmap image supports per-pixel transparency. 
	     *  The default value is true (transparent). To create a fully transparent bitmap, set the value of the 
	     *  transparent parameter to true and the value of the fillColor parameter to 0x00000000 (or to 0). 
	     *  Setting the transparent property to false can result in minor improvements in rendering performance. 
	     *  
	     *  @param fillColor A 32-bit ARGB color value that you use to fill the bitmap image area. 
	     *  The default value is 0xFFFFFFFF (solid white).
	     *  
	     *  @param useLocalSpace Whether or not the bitmap shows the GraphicElement in the local or global 
	     *  coordinate space. If true, then the snapshot is in the local space. The default value is true. 
	     * 
	     *  @param clipRect A Rectangle object that defines the area of the source object to draw. 
	     *  If you do not supply this value, no clipping occurs and the entire source object is drawn.
	     *  The clipRect should be defined in the coordinate space specified by useLocalSpace
	     * 
	     *  @return A bitmap snapshot of the GraphicElement or null if the input element has no visible bounds.
	     *  
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10
	     *  @playerversion AIR 1.5
	     *  @productversion Flex 4
	     */
	    public function captureBitmapData(transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF, useLocalSpace:Boolean = true, clipRect:Rectangle = null):BitmapData
	    {
			throw new Error("not adapted to work independently yet. copied from GraphicElement.");
			/*
	        if (!layoutFeatures || !layoutFeatures.is3D)
	        {               
	            var restoreDisplayObject:Boolean = false;
	            var oldDisplayObject:DisplayObject;
	            
	            if (!displayObject || displayObjectSharingMode != DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
	            {
	                restoreDisplayObject = true;
	                oldDisplayObject = displayObject;
	                setDisplayObject(new InvalidatingSprite());
	                if (parent is UIComponent)
	                    UIComponent(parent).$addChild(displayObject);
	                else
	                    parent.addChild(displayObject);
	                invalidateDisplayList();
	                validateDisplayList();
	            }
	            
	            var topLevel:Sprite = Sprite(IUIComponent(parent).systemManager.getSandboxRoot());
	            var rectBounds:Rectangle = useLocalSpace ? 
	                        new Rectangle(getLayoutBoundsX(), getLayoutBoundsY(), getLayoutBoundsWidth(), getLayoutBoundsHeight()) :
	                        displayObject.getBounds(topLevel); 
	            
	            if (rectBounds.width == 0 || rectBounds.height == 0)
	                return null;
	            
	            var bitmapData:BitmapData = new BitmapData(Math.ceil(rectBounds.width), Math.ceil(rectBounds.height), transparent, fillColor);
	                
	            // Can't use target's concatenatedMatrix, as it is sometimes wrong
	            var m:Matrix = useLocalSpace ? 
	                displayObject.transform.matrix : 
	                MatrixUtil.getConcatenatedMatrix(displayObject, null);
	            
	            if (m)
	                m.translate(-rectBounds.x, -rectBounds.y);
	            
	            bitmapData.draw(displayObject, m, null, null, clipRect);
	           
	            if (restoreDisplayObject)
	            {
	                if (parent is UIComponent)
	                    UIComponent(parent).$removeChild(displayObject);
	                else
	                    parent.removeChild(displayObject);
	                setDisplayObject(oldDisplayObject);
	            }
	            return bitmapData;
	        
	        }
	        else
	        {
	            return get3DSnapshot(transparent, fillColor, useLocalSpace);
	        }*/
	    }
	
	   /**
	     *  @private 
	     *  Returns a bitmap snapshot of a 3D transformed displayObject. Since BitmapData.draw ignores
	     *  the transform matrix of its target when it draws, we need to parent the target in a temporary
	     *  sprite and call BitmapData.draw on that temp sprite. We can't take a bitmap snapshot of the 
	     *  real parent because it might have other children. 
	     */
	    private function get3DSnapshot(transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF, useLocalSpace:Boolean = true):BitmapData
	    {
			/*
	        var topLevel:Sprite = Sprite(IUIComponent(parent).systemManager); 
	        var dispObjParent:DisplayObjectContainer = displayObject.parent;
	        var drawSprite:Sprite = new Sprite();
	                
	        // Get the visual bounds of the target in both local and global coordinates
	        var topLevelRect:Rectangle = displayObject.getBounds(topLevel);
	        var displayObjectRect:Rectangle = displayObject.getBounds(dispObjParent);  
	        
	        // Keep a reference to the original 3D matrix. We will restore this later.
	        var oldMat3D:Matrix3D = displayObject.transform.matrix3D.clone();
	        
	        // Get the concatenated 3D matrix which we will use to position the target when we reparent it
	        var globalMat3D:Matrix3D = displayObject.transform.getRelativeMatrix3D(topLevel);
	        var newMat3D:Matrix3D = oldMat3D.clone();      
	        
	        
	        // Remove the target from its current parent, making sure to store the child index
	        var displayObjectIndex:int = parent.getChildIndex(displayObject);
	        if (parent is UIComponent)
	            UIComponent(parent).$removeChild(displayObject);
	        else
	            parent.removeChild(displayObject);
	        
	        // Parent the target to the drawSprite and then attach the drawSprite to the stage
	        topLevel.addChild(drawSprite);
	        drawSprite.addChild(displayObject);
	
	        // Assign the globally translated matrix to the target
	        if (useLocalSpace)
	        {
	            newMat3D.position = globalMat3D.position;
	            displayObject.transform.matrix3D = newMat3D;
	        }
	        else
	        {
	            displayObject.transform.matrix3D = globalMat3D;
	        }
	        // Translate the bitmap so that the left-top bounds ends up at (0,0)
	        var m:Matrix = new Matrix();
	        m.translate(-topLevelRect.left, - topLevelRect.top);
	               
	        // Draw to the bitmapData
	        var snapshot:BitmapData = new BitmapData( topLevelRect.width, topLevelRect.height, transparent, fillColor);
	        snapshot.draw(drawSprite, m, null, null, null, true);
	
	        // Remove target from temporary sprite and remove temp sprite from stage
	        drawSprite.removeChild(displayObject);
	        topLevel.removeChild(drawSprite);
	        
	        // Reattach the target to its original parent at its original child position
	        if (parent is UIComponent)
	            UIComponent(parent).$addChildAt(displayObject, displayObjectIndex);
	        else
	            parent.addChildAt(displayObject, displayObjectIndex);
	            
	        // Restore the original 3D matrix
	        displayObject.transform.matrix3D = oldMat3D;
	
	        return snapshot; */
			var snapshot:BitmapData;
			return snapshot;
	    }
		
		/**
		 * Copied this from HighlightBitmapCapture used by the focus skin to create
		 * a bitmap of the component. 
		 * 
		 * Accepts "bitmap", "bitmapData" as type parameter. Returns that type. 
		 * */
		public static function getHighlightBitmapCapture(target:Object, type:String="bitmap", borderWeight:int=0):Object {
        	var capturingBitmap:Boolean = false;
        	var colorTransform:ColorTransform = new ColorTransform(1.01, 1.01, 1.01, 2);
        	var rect:Rectangle = new Rectangle();
		
			// if we weren't handed a targetObject then exit early
            if (!target)
                return null;
            
            var bitmapData:BitmapData = new BitmapData(
                target.width + (borderWeight * 2), 
                target.height + (borderWeight * 2), true, 0);
            var m:Matrix = new Matrix();
            
            //capturingBitmap = true;
            
            // Ensure no 3D transforms apply, as this skews our snapshot bitmap.
            var transform3D:Matrix3D = null;
            if (target.$transform.matrix3D)
            {
                transform3D = target.$transform.matrix3D;  
                target.$transform.matrix3D = null;
            }
            
            // If the target object already has a focus skin, make sure it is hidden.
            if (target.focusObj)
                target.focusObj.visible = false;
            
            var needUpdate:Boolean;
            var bitmapCaptureClient:IHighlightBitmapCaptureClient = target.skin as IHighlightBitmapCaptureClient;
            if (bitmapCaptureClient)
            {
                needUpdate = bitmapCaptureClient.beginHighlightBitmapCapture();
                if (needUpdate)
					bitmapCaptureClient.validateNow();
            }
            
            m.tx = borderWeight;
            m.ty = borderWeight;
            
            try
            {
                bitmapData.draw(target as IBitmapDrawable, m);
            }
            catch (e:SecurityError)
            {
                // If capture fails, substitute with a Rect
                var fillRect:Rectangle
				var skin:DisplayObject = target.skin;
				
                if (skin)
                    fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
                else
                    fillRect = new Rectangle(target.x, target.y, target.width, target.height);
                
                bitmapData.fillRect(fillRect, 0);
            }
            
            if (bitmapCaptureClient)
            {
                needUpdate = bitmapCaptureClient.endHighlightBitmapCapture();
                if (needUpdate)
					bitmapCaptureClient.validateNow();
            }
            
            
            // Show the focus skin, if needed.
            if (target.focusObj)
                target.focusObj.visible = true;
            
            // Transform the color to remove the transparency. The GlowFilter has the "knockout" property
            // set to true, which removes this image from the final display, leaving only the outer glow.
            rect.x = rect.y = borderWeight;
            rect.width = target.width;
            rect.height = target.height;
            bitmapData.colorTransform(rect, colorTransform);
			
            var bitmap:Bitmap;
            if (!bitmap)
            {
                bitmap = new Bitmap();
                //addChild(bitmap);
            }
            
            bitmap.x = bitmap.y = -borderWeight;
            bitmap.bitmapData = bitmapData;
            
            //processBitmap();
            
            // Restore original 3D matrix if applicable.
            if (transform3D)
                target.$transform.matrix3D = transform3D;
            
            capturingBitmap = false;
			
			return bitmap;
		}
		
		/**
		 * Wrapped to allow error handling
		 **/
		public static function drawBitmapData(bitmapData:BitmapData, displayObject:DisplayObject, matrix:Matrix = null):void {
			bitmapData.draw(displayObject, matrix, null, null, null, true);
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap asset
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 */
		public static function getBitmapAssetSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):BitmapAsset {
			var bitmapData:BitmapData = getBitmapDataSnapshot(target, useAlpha, scaleX, scaleY);
			var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData, PixelSnapping.ALWAYS);
			
			return bitmapAsset;
		}
		
		/**
		 * Creates a heiarchial object of the display list starting at the given element.
		 * This is a duplicate of the getComponentDisplayList = needs to be just display list
		 * */
		public static function getDisplayList(element:Object, parentItem:ComponentDescription = null, depth:int = 0):ComponentDescription {
			var item:ComponentDescription;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				parentItem = new ComponentDescription(element);
				parentItem.children = new ArrayCollection();
				return getDisplayList(element, parentItem);
			}
			
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var length:int = visualContainer.numElements;
				
				for (var i:int;i<length;i++) {
					childElement = visualContainer.getElementAt(i);
					item = new ComponentDescription(childElement);
					item.parent = parentItem;
					
					parentItem.children.addItem(item);
					
					// check for IVisualElement
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						item.children = new ArrayCollection();
						getDisplayList(childElement, item, depth + 1);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Gets the component tree list starting at the given element. 
		 * application as IVisualElement
		 
		 Usage:
		 var rootComponent:ComponentDescriptor = getComponentDisplayList(FlexGlobals.topLevelApplication);
		 
		 trace(ObjectUtil.toString(rootComponent));
		 
		 * */
		public static function getComponentDisplayList2(element:Object, parentItem:ComponentDescription = null, depth:int = 0, dictionary:Dictionary = null):ComponentDescription {
			var item:ComponentDescription;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				if (dictionary && dictionary[element]) {
					parentItem = dictionary[element];
				}
				else {
					parentItem = new ComponentDescription(element);
					parentItem.children = new ArrayCollection();
				}
				
				return getComponentDisplayList2(element, parentItem);
			}
			
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var length:int = visualContainer.numElements;
				
				for (var i:int;i<length;i++) {
					childElement = visualContainer.getElementAt(i);
						
					if (dictionary && dictionary[childElement]) {
						item = dictionary[childElement];
					}
					else {
						item = new ComponentDescription(childElement);
						item.parent = parentItem;
					}
					
					parentItem.children.addItem(item);
					
					// check for IVisualElement
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						!item.children ? item.children = new ArrayCollection() : void;
						getComponentDisplayList2(childElement, item, depth + 1);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Finds the target component in the component tree
		 * returns ComponentDescription where instance is the target
		 * 
		 * Note: the component tree is created by getComponentDisplayList();
		 * parentItem could be the root component tree object
		 * */
		public static function getTargetInComponentDisplayList(target:Object, parentItem:ComponentDescription, depth:int = 0):ComponentDescription {
			var length:int = parentItem.children ? parentItem.children.length : 0;
			var possibleItem:ComponentDescription;
			var itemFound:Boolean;
			
			if (target==parentItem.instance) {
				return parentItem;
			}
			
			for (var i:int; i < length; i++) {
				var item:ComponentDescription = parentItem.children.getItemAt(i) as ComponentDescription;
				
				if (item && item.instance==target) {
					itemFound = true;
					break;
				}
				
				if (item.children) {
					possibleItem = getTargetInComponentDisplayList(target, item, depth + 1);
					
					if (possibleItem) {
						itemFound = true;
						item = possibleItem;
						break;
					}
				}
				
			}
			
			if (itemFound) return item;
			
			return null;
		}
		
		/**
		 * Method to walk down into visual element tree and run a function on each element.<br/><br/>
		 * 
		 Usage:<br/>
		 <pre>
		 DisplayObjectUtils.walkDownTree(application as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 // trace
		 element=Application
		 element=Group
		 element=Button1
		 element=Button2
		 </pre>
		 * 
		 * */
		public static function walkDownTree(element:IVisualElement, proc:Function, includeSkinnable:Boolean = false):void {
			var visualContainer:IVisualElementContainer;
			var skin:Skin;
			
			proc(element);
			
			if (element is IVisualElementContainer) {
				visualContainer = IVisualElementContainer(element);
				
				for (var i:int = 0; i < visualContainer.numElements; i++) {
					walkDownTree(visualContainer.getElementAt(i), proc);
				}
			}
			else if (includeSkinnable && element is SkinnableComponent)	{
				skin = SkinnableComponent(element).skin as Skin;
				walkLayoutTree(skin, proc);
			}
			
		}
		
		/**
		 * Method to walk down into visual element and skinnable container tree and run a function on each element
		 * Doesn't show depth but could.
		
		Usage:
		
		DisplayObjectUtils.walkLayoutTree(application as IVisualElement, traceTree);
		
		public function traceTree(element:Object):void {
		trace("element="+NameUtil.getUnqualifiedClassName(element));
		}
		
		// trace
		element=Application
		element=SkinnableComponent
		element=Button1
		element=Button2
		element=Group
		 * 
		 * */
		public static function walkLayoutTree(element:IVisualElement, proc:Function):void {
			proc(element);
			
			if (element is SkinnableComponent) {
				var skin:Skin = SkinnableComponent(element).skin as Skin;
				walkLayoutTree(skin, proc);
			}
			else if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				
				for (var i:int = 0; i < visualContainer.numElements; i++)
				{
					walkLayoutTree(visualContainer.getElementAt(i), proc);
				}
			}
			// expand this to MX and IRawChildrenContainer?
		}
		
		/**
		 * Gumbo sdk methods to walk up tree (via owner) from current element and run a function on each element
		 * Does not take into account if owner is part of the component tree
		  
		 Usage:
		 DisplayObjectUtils.walkUpTree(element as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 * */
		public static function walkUpTree(element:IVisualElement, proc:Function):void {
			while (element!= null) {
				proc(element);
				element = element.owner as IVisualElement;
			}
		}
		
		/**
		 * Walks up the visual element display list (via parent) from current element and run a function on each element
		 * Does not take into account if parent is part of the component tree??
		 
		 Usage:
		 DisplayObjectUtils.walkUpLayoutTree(element as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 * */
		public static function walkUpLayoutTree(element:IVisualElement, proc:Function):void {
			
			while (element != null) {
				proc(element);
				element = element.parent as IVisualElement;
			}
		}
		
		/**
		 * Find the component that contains the display object 
		 * AND is also on the component tree
		 * */
		public static function getComponentFromDisplayObject(displayObject:DisplayObject, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (displayObject) {
				componentDescription = getTargetInComponentDisplayList(displayObject, componentTree);
				
				if (componentDescription) {
					return componentDescription;
				}
				else {
					if ("owner" in displayObject) { // is IUIComponent
						// using Object because of RichEditableText is not IUIComponent
						// displayObject = IUIComponent(displayObject).owner as DisplayObjectContainer;
						displayObject = Object(displayObject).owner as DisplayObjectContainer;
					}
					else {
						displayObject = displayObject.parent;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Finds the component that contains the given visual element AND is also on the component tree
		 * */
		public static function getComponentFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the group that contains the given visual element and that is also on the component tree
		 * */
		public static function getGroupFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription && element is GroupBase) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the visual element container of the given visual element and that is also on the component tree
		 * */
		public static function getVisualElementContainerFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription && element is IVisualElementContainer) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the path of a visual element that is on the component tree
		 * Usage:
		 * var ancestorVisualElement:ComponentDescription = Tree(owner).dataProvider.getItemAt(0) as ComponentDescription;
		 * getVisualElementPath(myButton, getDisplayList(ancestorVisualElement)); // [button(myButton),group,hgroup,ancestorVisualElement]
		 * */
		public static function getVisualElementPath(element:IVisualElement, componentTree:ComponentDescription, reverseOrder:Boolean = false):String {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				// get name
				if (componentDescription && element is IVisualElementContainer) {
					path.push(componentDescription.className);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return reverseOrder ? path.reverse().join(".") : path.join(".");
		}
		
		/**
		 * Find the greatest visibility state of a visual element that is on the component tree
		 * 
		 * Usage:
		 * var rootApplicationDescription:ComponentDescription = DisplayObjectUtils.getDisplayList(application);//Tree(owner).dataProvider.getItemAt(0) as ComponentDescription;
		 * var visibility:Boolean = DisplayObjectUtils.getGreatestVisibility(IVisualElement(item.instance), rootApplicationDescription); 
		 * */
		public static function getGreatestVisibility(element:IVisualElement, componentTree:ComponentDescription):Boolean {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			var visible:Boolean;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				// get name
				if (componentDescription) {
					visible = element.visible;
					path.push(visible);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return path.indexOf(false)!=-1 ? false : true;
		}
		
		/**
		 * Find the greatest visibility state of a visual element
		 * 
		 * Usage:
		 * var visibility:Boolean = DisplayObjectUtils.getGreatestVisibility(IVisualElement(item.instance)); 
		 * */
		public static function getGreatestVisibilityDisplayList(element:IVisualElement):Boolean {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			var visible:Boolean;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				
				if (element) {
					visible = element.visible;
					path.push(visible);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return path.indexOf(false)!=-1 ? false : true;
		}
		
		/**
		 * Walk down into the component tree target and set the parentVisible flag.<br/>
		 * 
		 * Usage:
		 *  DisplayObjectUtils.setVisibilityFlag(component, false);
		 * 
		 * */
		public static function setVisibilityFlag(component:ComponentDescription, visible:Boolean = false):void {
			var length:int = component.children ? component.children.length : 0;
			var item:ComponentDescription;
			
			for (var i:int; i < length; i++) {
				item = component.children.getItemAt(i) as ComponentDescription;
				
				if (item) {
					item.parentVisible = visible;
				}
				
				if (item.children && item.children.length) {
					setVisibilityFlag(item, visible);
				}
				
			}
			
		}
		
		/**
		 * Adds listeners to groups on the display list so drag operations work
		 * when over transparent areas
		 * */
		public static function enableDragBehaviorOnDisplayList(element:IVisualElement, enableDragBehavior:Boolean = true, applicationGroups:Dictionary = null):Dictionary {
			var groupOptions:GroupOptions;
			var group:GroupBase;
			
			if (!applicationGroups && enableDragBehavior) applicationGroups = new Dictionary();
			
			if (element is GroupBase) {
				group = GroupBase(element);
				
				// add drag supporting behavior
				if (enableDragBehavior) {
					addGroupMouseSupport(group, applicationGroups);
				}
				else {
					// disable drag supporting behavior
					removeGroupMouseSupport(group, applicationGroups);
				}
			}
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var length:int = visualContainer.numElements;
				
				for (var i:int;i<length;i++) {
					enableDragBehaviorOnDisplayList(visualContainer.getElementAt(i), enableDragBehavior, applicationGroups);
				}
			}
			
			return applicationGroups;
		}
		
		
		//----------------------------------
		//
		// DISPLAY SIZING METHODS
		//
		//----------------------------------
		
		//----------------------------------
		//  splashScreenScaleMode
		//----------------------------------
		
		[Inspectable(enumeration="none,letterbox,stretch,zoom", defaultValue="none")]
		
		/**
		 *  The image scale mode:
		 *  
		 *  <ul>
		 *      <li>A value of <code>none</code> implies that the image size is set 
		 *      to match its intrinsic size.</li>
		 *
		 *      <li>A value of <code>stretch</code> sets the width and the height of the image to the
		 *      stage width and height, possibly changing the content aspect ratio.</li>
		 *
		 *      <li>A value of <code>letterbox</code> sets the width and height of the image 
		 *      as close to the stage width and height as possible while maintaining aspect ratio.  
		 *      The image is stretched to a maximum of the stage bounds,
		 *      with spacing added inside the stage to maintain the aspect ratio if necessary.</li>
		 *
		 *      <li>A value of <code>zoom</code> is similar to <code>letterbox</code>, except 
		 *      that <code>zoom</code> stretches the image past the bounds of the stage, 
		 *      to remove the spacing required to maintain aspect ratio.
		 *      This setting has the effect of using the entire bounds of the stage, but also 
		 *      possibly cropping some of the image.</li>
		 *  </ul>
		 * 
		 * */
		public static function getSizeByScaleMode(maxWidth:int, maxHeight:int, 
												  width:int, height:int, 
												  scaleMode:String="letterbox",
												  dpi:Number=NaN):Matrix 
		{
			
			var aspectRatio:String = (maxWidth < maxHeight) ? "portrait" : "landscape";
			var orientation:String = aspectRatio;
			
			// Current stage orientation
			//var orientation:String = stage.orientation;
			
			// DPI scaling factor of the stage
			//var dpiScale:Number = this.root.scaleX;
			
			// Start building a matrix
			var m:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			if (scaleX != 1 || scaleY != 0)
			{
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			m.translate(-width / 2, -height / 2);
			
			// Align center of image (0,0) to center of stage: 
			m.translate(maxWidth / 2, maxHeight / 2);
			
			// Apply matrix
			// splashImage.transform.matrix = m;
			
			return m;
		}
		
		/**
		 * Set display object to scale
		 * */
		public static function getScale(maxWidth:int, maxHeight:int,
										width:int, height:int,
										scaleMode:String="letterbox",
										dpi:Number=NaN):Matrix 
		{
			
			var aspectRatio:String = (maxWidth < maxHeight) ? "portrait" : "landscape";
			var orientation:String = aspectRatio;
			
			// Current stage orientation
			//var orientation:String = stage.orientation;
			
			// DPI scaling factor of the stage
			//var dpiScale:Number = this.root.scaleX;
			
			// Start building a matrix
			var m:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			if (scaleX != 1 || scaleY != 0)
			{
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			m.translate(-width / 2, -height / 2);
			
			// Align center of image (0,0) to center of stage: 
			m.translate(maxWidth / 2, maxHeight / 2);
			
			// Apply matrix
			// splashImage.transform.matrix = m;
			
			return m;
		}
		
		
		/**
		 * Scales the display object to the container.
		 * 
		 *  The image scale mode:
		 *  
		 *  <ul>
		 *      <li>A value of <code>none</code> implies that the image size is set 
		 *      to match its intrinsic size.</li>
		 *
		 *      <li>A value of <code>stretch</code> sets the width and the height of the image to the
		 *      stage width and height, possibly changing the content aspect ratio.</li>
		 *
		 *      <li>A value of <code>letterbox</code> sets the width and height of the image 
		 *      as close to the stage width and height as possible while maintaining aspect ratio.  
		 *      The image is stretched to a maximum of the stage bounds,
		 *      with spacing added inside the stage to maintain the aspect ratio if necessary.</li>
		 *
		 *      <li>A value of <code>zoom</code> is similar to <code>letterbox</code>, except 
		 *      that <code>zoom</code> stretches the image past the bounds of the stage, 
		 *      to remove the spacing required to maintain aspect ratio.
		 *      This setting has the effect of using the entire bounds of the stage, but also 
		 *      possibly cropping some of the image.</li>
		 *  </ul>
		 * 
		 * */
		public static function scaleDisplayObject(container:DisplayObject,
												  displayObject:DisplayObject,
												  scaleMode:String="letterbox",
												  position:String="center",
												  dpi:Number=NaN):Boolean 
		{
			
			
			// DPI scaling factor of the stage
			var dpiScale:Number = 1;// = this.root.scaleX;
			
			// Get container dimensions at default orientation
			var maxWidth:Number = dpiScale ? container.width / dpiScale : container.width;
			var maxHeight:Number = dpiScale ? container.height / dpiScale : container.height;
			
			// The image dimensions
			var width:Number = displayObject.width;
			var height:Number = displayObject.height;
			
			// Start building a matrix
			var m:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			// for zoom?
			if (scaleX != 1 || scaleY != 0) {
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			if (position=="center") {
				m.translate(-width / 2, -height / 2);
				
				// Align center of image (0,0) to center of stage: 
				m.translate(maxWidth / 2, maxHeight / 2);
			}
			
			// Apply matrix
			displayObject.transform.matrix = m;
			
			return true;
		}
		
		/**
		 * Add mouse listener and set mouse enabled where transparent to true to so that we
		 * can listen to mouse events for drag over and drag and drop events. 
		 * Group ignores mouse events by default since it has no background or border. 
		 * */
		public static function addGroupMouseSupport(group:GroupBase, groupsDictionary:Dictionary = null):void {
			if (!groupsDictionary) groupsDictionary = applicationGroups;
			groupsDictionary[group] = new GroupOptions(group.mouseEnabledWhereTransparent);
			group.addEventListener(MouseEvent.MOUSE_OUT, enableGroupMouseHandler, false, 0, true);
			group.mouseEnabledWhereTransparent = true;
		}
		
		/**
		 * Remove the mouse listener and restore mouseEnabledWhereTransparent value to group. 
		 * */
		public static function removeGroupMouseSupport(group:GroupBase, groupsDictionary:Dictionary = null):void {
			if (!groupsDictionary) groupsDictionary = applicationGroups;
			//TypeError: Error #1010: A term is undefined and has no properties. (applicationGroups)
			if (group in groupsDictionary) {
				group.mouseEnabledWhereTransparent = groupsDictionary[group].mouseEnabledWhereTransparent;
				group.removeEventListener(MouseEvent.MOUSE_OUT, enableGroupMouseHandler);
				groupsDictionary[group] = null;
				delete groupsDictionary[group];
			}
		}
		
		/**
		 * Handler for mouse events on groups. Group needs mouse event listener to track mouse
		 * events over it. This is the handler we add to the group. It does nothing. 
		 * */
		public static function enableGroupMouseHandler(event:MouseEvent):void
		{
			// this is used to enable mouse events where transparent 
		}
		
		
		/**
		 * Get red value from uint
		 * */
		public static function extractRed(color:uint):uint {
			return (( color >> 16 ) & 0xFF);
		}
		
		/**
		 * Get green value from uint
		 * */
		public static function extractGreen(color:uint):uint {
			return ((color >> 8) & 0xFF);
		}
		
		/**
		 * Get blue value from uint
		 * */
		public static function extractBlue(color:uint):uint {
			return (color & 0xFF);
		}
		
		/**
		 * Get combined RGB value
		 * */
		public static function combineRGB(red:uint, green:uint, blue:uint):uint {
			return (( red << 16) | (green << 8) | blue);
		}
		
		/**
		 * Get color value in hex value format
		 **/
		public static function getColorInHex(color:uint, addHash:Boolean = false):String {
			var red:String = extractRed(color).toString(16).toUpperCase();
			var green:String = extractGreen(color).toString(16).toUpperCase();
			var blue:String = extractBlue(color).toString(16).toUpperCase();
			var value:String = "";
			var zero:String = "0";
			
			if (red.length==1) {
				red = zero.concat(red);
			}
			
			if (green.length==1) {
				green = zero.concat(green);
			}
			
			if (blue.length==1) {
				blue = zero.concat(blue);
			}
			
			value = addHash ? "#" + red + green + blue : red + green + blue;
			
			return value;
		}
		
		/**
		 * Gets the color as type from uint. 
		 * */
		public static function getColorAsType(color:uint, type:String):Object {
			
				if (type==HEXIDECIMAL_HASH_COLOR_TYPE) {
					return getColorInHex(color, true);
				}
				else if (type==HEXIDECIMAL_COLOR_TYPE) {
					return getColorInHex(color, false);
				}
				else if (type==STRING_UINT_COLOR_TYPE) {
					return String(color);
				}
				else if (type==NUMBER_COLOR_TYPE) {
					return Number(color);
				}
				else if (type==UINT_COLOR_TYPE) {
					return uint(color);
				}
				else if (type==INT_COLOR_TYPE) {
					return int(color);
				}
				
				return color;
		}
		
		
		/**
		 * Gets the color under the mouse pointer. 
		 * Returns null if taking bitmap screen shot results in a security violation.
		 * IE location is an image showing content from another domain. 
		 * 
		 * @param type. If type is raw then returns the color as a uint. If type
		 * is hex then returns the color as a number 0xFFFFFF. If prefix is set
		 * then returns the color as a string with a pound sign before it, "#ffffff".
		 * */
		public static function getColorUnderMouse(event:MouseEvent):Object {
			var eyeDropperColorValue:uint;
			var screenshot:BitmapData;
			var output:String = "";
			var stageX:Number;
			var stageY:Number;
			var value:String;
			var scale:Number;
			
			screenshot = new BitmapData(FlexGlobals.topLevelApplication.width, FlexGlobals.topLevelApplication.height, false);
			
			try {
				drawBitmapData(screenshot, DisplayObject(FlexGlobals.topLevelApplication));
			}
			catch (e:Error) {
				// could not draw it possibly because of security sandbox 
				// so we return null
				return null;
			}
	
			scale = FlexGlobals.topLevelApplication.applicationDPI / FlexGlobals.topLevelApplication.runtimeDPI;
			stageX = event.stageX * scale;
			stageY = event.stageY * scale;
		
			eyeDropperColorValue = screenshot.getPixel(stageX, stageY);
			
			return eyeDropperColorValue;
			
		}
	
	}
}
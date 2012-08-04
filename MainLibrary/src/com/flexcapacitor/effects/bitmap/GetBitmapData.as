

package com.flexcapacitor.effects.bitmap {
	
	import com.flexcapacitor.effects.bitmap.supportClasses.GetBitmapDataInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.effects.IEffect;
	
	import spark.components.supportClasses.Range;
	import spark.core.IContentLoader;
	import spark.primitives.BitmapImage;
	
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when content loading is complete. This
	 *  event is only dispatched for url and ByteArray based
	 *  sources (those sources requiring a Loader).
	 * 
	 *  <p>Note that for content loaded by Loader, both
	 *  <code>ready</code> and <code>complete</code> events
	 *  are dispatched.</p>  For other source types such as
	 *  embeds, only <code>ready</code> is dispatched.
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *  Dispatched when a network request is made over HTTP 
	 *  and Flash Player or AIR can detect the HTTP status code.
	 * 
	 *  @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 *  Dispatched when an input or output error occurs.
	 *  @see flash.events.IOErrorEvent
	 *
	 *  @eventType flash.events.IOErrorEvent.IO_ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 *  Dispatched when content is loading.
	 *
	 *  <p><strong>Note:</strong> 
	 *  The <code>progress</code> event is not guaranteed to be dispatched.
	 *  The <code>complete</code> event may be received, without any
	 *  <code>progress</code> events being dispatched.
	 *  This can happen when the loaded content is a local file.</p>
	 *
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 *  Dispatched when content loading is complete.  Unlike the
	 *  <code>complete</code> event, this event is dispatched for 
	 *  all source types.  
	 *  
	 *  <p>Note that for content loaded via Loader, both
	 *  <code>ready</code> and <code>complete</code> events
	 *  are dispatched.</p>  For other source types such as
	 *  embeds, only <code>ready</code> is dispatched.
	 *
	 *  @eventType mx.events.FlexEvent.READY
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="ready", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched when a security error occurs.
	 *  @see flash.events.SecurityErrorEvent
	 *
	 *  @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * Gets the bitmap data from an object. The object can be: <br/><br/>
	 * A DisplayObject. <br/>
	 * A Bitmap or BitmapData instance.<br/>
	 * An instance of a DisplayObject.<br/>
	 * An Embedded Image.<br/>
	 * A Multi-DPI Image.<br/>
	 * The path to an image.<br/><br/>
	 * 
	 * Basically this class passes the value in the source property into the source property of a BitmapImage class instance.<br/><br/>
	 * 
	 * The generated bitmap data is copied into the bitmapData property of this class.<br/><br/>
	 * 
	 * Usage<br/>
	 * <pre>
	 * &lt;bitmap:GetBitmapData source="{displayObject}" /><br/>
	 * &lt;bitmap:GetBitmapData source="path/to/image.png" />
	 * </pre><br/>
	 * 
	 * Notes<br/>
	 * If the image is not in the path the image is not loaded and an ioError is dispatched
	 * and the effects are canceled. 
	 * At some point this may branch to play an image not found effect.
	 * <br/><br/>
	 * 
	 * Sometimes an image is not copied to the target location by Flash Builder.
	 * The image must be copied to the desired location if it is not embedded.
	 * You can also embed the image by setting the source property like so, @Embed('path/to/image.png')
	 * <br/><br/>
	 * @see spark.primitives.BitmapImage#source
	 * @see com.flexcapacitor.effects.display.Rasterize
	 * */
	public class GetBitmapData extends ActionEffect {
		
		public static const IOERROR:String 			= "ioError";
		public static const SECURITY_ERROR:String 	= "securityError";
		public static const READY:String			= "ready";
		public static const PROGRESS:String 		= "progress";
		public static const HTTP_STATUS:String 		= "httpStatus";
		public static const COMPLETE:String 		= "complete";
		
		/**
		 * Constructor
		 */
		public function GetBitmapData(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = GetBitmapDataInstance;
		}
		
		/**
		 *  @copy spark.primitives.BitmapImage#source
		 */
		public function set source(value:Object):void {
			if (_source == value)
				return;
			_source = value;
		}
		
		[Bindable]
		[Inspectable(category="General")]
		
		/**
		 *  @private
		 */
		public function get source():Object {
			return _source;
		}
		
		private var _source:Object;
		
		/**
		 *  The progress value is automatically updated
		 *  with the percentage complete while loading.
		 */
		[Bindable]
		public var progressValue:Number;  
		
		/**
		 *  @copy spark.primitives.BitmapImage#bitmapData
		 * 
		 */
		[Bindable]
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void {
			if (_bitmapData==value)
				return;
			
			_bitmapData = value;
		}
		
		private var _bitmapData:BitmapData;
		
		/**
		 * Helper component for loading the source data.
		 * You do not set this.
		 */
		public var bitmapImage:BitmapImage;
		
		/**
		 * @copy spark.primitives.BitmapImage#clearOnLoad
		 * */
		public var clearOnLoad:Boolean;
		
		/**
		 * Padding
		 * */
		public var padding:int;
		
		/**
		 * @copy spark.primitives.BitmapImage#contentLoader
		 * */
		[Bindable]
		public var contentLoader:IContentLoader;
		
		/**
		 * @copy spark.primitives.BitmapImage#contentLoaderGrouping
		 * */
		[Bindable]
		public var contentLoaderGrouping:String;
		
		/**
		 * Reference to Progress event
		 * */
		public var progressEvent:ProgressEvent;
		
		/**
		 * Reference to IO Error event
		 * */
		public var ioErrorEvent:IOErrorEvent;
		
		/**
		 * Reference to Security Error event
		 * */
		public var securityErrorEvent:SecurityErrorEvent;
		
		/**
		 * Effect played when an io error occurs
		 * */
		public var ioErrorEffect:IEffect;
		
		/**
		 * Effect played when a security error occurs
		 * */
		public var securityErrorEffect:IEffect;
		
		/**
		 * Effect played on the complete event
		 * */
		public var completeEffect:IEffect;
		
		/**
		 * Effect played on a progress event
		 * */
		public var progressEffect:IEffect;
		
		/**
		 * Effect played on a ready event
		 * */
		public var readyEffect:IEffect;
		
		/**
		 * Effect played on an HTTP status event
		 * */
		public var httpStatusEffect:IEffect;
		
	}
}
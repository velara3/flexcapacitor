

package com.flexcapacitor.effects.status {
	
	import com.flexcapacitor.effects.status.supportClasses.ShowStatusMessageInstance;
	import com.flexcapacitor.effects.status.supportClasses.StatusMessage;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.Sprite;
	
	/**
	 * Displays a message and then fades out the message. The duration must be more than 1 second.  
	 * If you have data that you want to display set the data property.
	 * It will be converted to a string. <br/><br/>
	 * 
	 * <b>Usage</b>:<br/> 
	 * To show a message at the bottom of the screen,
	 * <pre>
&lt;status:ShowStatusMessage location="bottom" message="Your email has been sent" />
	 * </pre>
	 * 
	 * <b>Usage</b>:<br/> 
	 * How to hide a status message early,
	 * <pre>
&lt;status:ShowStatusMessage id="showRenderingStatus" message="Rendering" keepReference="true"/>
&lt;core:CallMethod method="renderImage" startDelay="250"/>
&lt;status:HideStatusMessage statusMessagePopUp="{showRenderingStatus.statusMessagePopUp}"/>
	 * </pre>
	 * 
	 * <b>Usage</b>:<br/> 
	 * How to show data object which is converted to a readable string,
	 * <pre>
&lt;status:ShowStatusMessage message="Your email has been sent" 
			data="{errorMessage}"
			textAlignment="left" 
			duration="3000"/>
	 * </pre>
	 * 
	 * <b>Usage</b>:<br/> 
	 * How to show a message for as long as it takes to read it,
	 * <pre>
&lt;status:ShowStatusMessage message="Your email has been sent" 
			data="{errorMessage}" 
			matchDurationToTextContent="true"
			moveToNextEffectImmediately="false"/>
	 * </pre>
	 * 
	 * <b>Usage</b>:<br/> 
	 * How to show a message until someone clicks it,
	 * <pre>
&lt;status:ShowStatusMessage message="Your email has been sent" 
			doNotClose="true"
			moveToNextEffectImmediately="false"/>
	 * </pre>
	 * 
	 * The suggested duration for displaying messages is 250-500 milliseconds per word. If you 
	 * have a message containing ten words and you expect slow readers then set the duration to
	 * 5000 since 10words * 500milliseconds = 5000milliseconds. You can also set the 
	 * matchDurationToTextContent to true and 
	 * 
	 * @see HideStatusMessage
	 * */
	public class ShowStatusMessage extends ActionEffect {
		
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var CENTER:Number = .5;
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var TOP:Number = .25;
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var BOTTOM:Number = .75;
		
		/**
		 *  Constructor.
		 * */
		public function ShowStatusMessage(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 2000;
			
			instanceClass = ShowStatusMessageInstance;
		}
		
		/**
		 * Status message class
		 * */
		public var statusMessageClass:Class = StatusMessage;
		
		/**
		 * Status message class properties
		 * */
		public var statusMessageProperties:Object;
		
		/**
		 * Title of item
		 * */
		public var title:String;
		
		/**
		 * The parent display object that this will be centered above. 
		 * */
		[Bindable]
		public var parentView:Sprite;
		
		/**
		 * Message to display
		 * */
		public var message:String;
		
		/**
		 * Data to show
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * If data is null show that it is null. 
		 * */
		public var showNullData:Boolean;
		
		/**
		 * If the modal is true then 
		 * no interaction is possible until the status message is closed.
		 * */
		public var modal:Boolean;
		
		/**
		 * Display message until clicked 
		 * */
		public var doNotClose:Boolean;
		
		/**
		 * Show busy icon
		 * */
		public var showBusyIcon:Boolean;
		
		/**
		 * Text alignment
		 * */
		public var textAlignment:String = "center";
		
		/**
		 * The location the message will appear at. 
		 * Top is a quarter of the way down, middle is half and bottom is 3/4ths.
		 * You can set a specific value with the locationPosition property. 
		 * @see locationPosition
		 * */
		[Inspectable(enumeration="top,center,bottom")]
		public var location:String = "center";
		
		/**
		 * The location the message will appear at. 
		 * This is a value from 0 to 1 that signifies how far down
		 * the message should appear. For example, .8 would be 80% of the way down.
		 * This overrides the location value. 
		 * */
		public var locationPosition:Number;
		
		/**
		 * Function to run when item is clicked on
		 * */
		public var closeHandler:Function;
		
		/**
		 * If set to true and if part of a sequence then moves the next effect 
		 * right away. If set to false then the next effect is played 
		 * after the status message is faded out. Default is true. 
		 * */
		public var moveToNextEffectImmediately:Boolean = true;
		
		/**
		 * Keeps a reference of the status message object
		 * */
		public var keepReference:Boolean = false;
		
		/**
		 * Reference to the status message object. Must set keep reference to true.
		 *  
		 * @see keepReference
		 * */
		[Bindable]
		public var statusMessagePopUp:Object;
		
		/**
		 * Fade in duration
		 * */
		 public var fadeInDuration:int = 250;
		 
		 /**
		  * If set to true uses ObjectUtil.toString(data). 
		  * Otherwise it uses data + ""
		  * */
		 public var useObjectUtilToString:Boolean;
		 
		 /**
		  * Sets the duration to match the text content.
		  * @see durationPerWord 
		  * */
		 public var matchDurationToTextContent:Boolean;
		 
		 /**
		  * When matchDurationToTextContent is set to true this 
		  * sets the duration of time for each word. 
		  * Reading speed for fast readers is 250ms per word.
		  * Reading speed for normal to slow is 350ms-450ms per word.
		  * Default is 350 milliseconds. 
		  * @see matchDurationToTextContent
		  * */
		 public var durationPerWord:int = 350;
		 
		 /**
		  * Minimum duration when using matchDurationToTextContent.
		  * Default is two and a half seconds or 2500. 
		  * */
		 public var minimumDuration:int = 2500;
		 
		 /**
		  * Maximum duration when using matchDurationToTextContent.
		  * Default is ten seconds which or 10000. 
		  * */
		 public var maximumDuration:int = 10000;
	}
}
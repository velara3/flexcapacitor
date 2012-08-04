




package com.flexcapacitor.utils {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *This is a class of utilities for movie clips.
	 * 
	 * Usage:
	 * 

button.addEventListener("click", clickHandler);
 
function clickHandler(event:DataEvent):void {
	var targetLabel:String = event.data;
	trace("Going to = "+targetLabel);
	
	if (targetLabel=="frameLabel1") {
		animateToLabel(MovieClip(event.currentTarget), "frameLabel1");
	}
	else if (targetLabel=="frameLabel2") {
		animateToLabel(MovieClip(event.currentTarget), "frameLabel2");
	}
	else if (targetLabel=="frameLabel3") {
		animateToLabel(MovieClip(event.currentTarget), "frameLabel3");
	}
	else if (targetLabel=="frameLabel4") {
		animateToLabel(MovieClip(event.currentTarget), "frameLabel4");
	}
	else if (targetLabel=="frameLabel5") {
		animateToLabel(MovieClip(event.currentTarget), "frameLabel5");
	}
}

var targetLabel:String;
var targetFrame:int;

// in button click handler - psuedo code
dispatchEvent(new DataEvent("data", "frameLabel3"));
 * 
 * 
	 * */
	public class AnimatedSprite {
		
		
		public function AnimatedSprite() {
			
		}
		
		/**
		 * Plays the movie clip forward or reverse until it reaches the label specified
		 * */
		public function animateToLabel(sprite:MovieClip, toLabel:String, stopAtEnd:Boolean = true, fromLabel:String = null):void {
			sprite.buttonMode = true;
			var toLabelNumber:int = getLabelFrameNumber(sprite, toLabel);
			var fromLabelNumber:int = getLabelFrameNumber(sprite, fromLabel);
			var currentLabelNumber:int = sprite.currentFrame;
			var delta:int = toLabelNumber - currentLabelNumber;
			
			if (delta>0) {
				
				if (fromLabel) {
					sprite.
					sprite.gotoAndStop(fromLabel);
				}
				
				if (stopAtEnd) {
					//sprite.addEventListener(Event.ENTER_FRAME, playAndStop);
				}
				else {
					sprite.play();
				}
			}
			else if (delta<0) {
				
				if (fromLabel) {
					sprite.gotoAndStop(fromLabel);
				}
				
				if (stopAtEnd) {
					sprite.addEventListener(Event.ENTER_FRAME, reverseAndStop);
				}
				else {
					sprite.addEventListener(Event.ENTER_FRAME, reverseAndPlay);
				}
				
			}
			
			function reverseAndPlay(event:Event):void {
				event.target.prevFrame();
					
				if (event.target.label==toLabel) {
					sprite.removeEventListener(Event.ENTER_FRAME, reverseAndPlay);
					sprite.play();
				}
			}
			
			function reverseAndStop(event:Event):void {
				event.target.prevFrame();
				
				if (event.target.label==toLabel) {
					sprite.removeEventListener(Event.ENTER_FRAME, reverseAndStop);
				}
			}
			
			function getLabelFrameNumber(sprite:MovieClip, name:String):int {
				
				for (var i:int = 0; i < sprite.currentLabels.length; i++) {
					var label:String = sprite.currentLabels[i].name;
					var number:Number = sprite.currentLabels[i].frame;
					trace("Label '" + label + "' is at frame number: " + number + ".");
					if (label==name) {
						return i;
					}
				}
				return -1;
			}
		}
	}
}

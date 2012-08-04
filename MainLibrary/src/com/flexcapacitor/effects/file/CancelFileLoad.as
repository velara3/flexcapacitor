

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.CancelFileLoadInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Cancels a load operation on a file
	 * 
	 * */
	public class CancelFileLoad extends ActionEffect {
		
		/**
		 *  Constructor.
		 * */
		public function CancelFileLoad(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = CancelFileLoadInstance;
			
		}
		
		
		/**
		 * Reference to the selected list of files. 
		 * */
		[Bindable]
		public var fileReferenceList:FileReferenceList;
		
		/**
		 * Reference to the selected file. Use fileReferenceList if
		 * multiple files were expected. 
		 * 
		 * @see allowMultipleSelection
		 * */
		[Bindable]
		public var fileReference:FileReference;
		
	}
}
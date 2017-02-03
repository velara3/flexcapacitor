
package com.flexcapacitor.model {
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ListCollectionView;
	
	
	/**
	 * Interface for document
	 * */
	public interface IDocument {
		
		/**
		 * ID of parent project. May support multiple projects in the future. 
		 * */
		function set projectID(value:String):void;
		function get projectID():String;
		
		/**
		 * Reference to last source data object 
		 * */
		function set sourceData(value:SourceData):void;
		function get sourceData():SourceData;
		
		
		/**
		 * Class type that contains this document
		 * */
		function get containerType():Class;
		function set containerType(value:Class):void;
		
		/**
		 * Name of class type that contains this document
		 * */
		function get containerTypeName():String;
		function set containerTypeName(value:String):void;
		
		/**
		 * Language to export this document to
		 * */
		function get language():String;
		function set language(value:String):void;
		
		/**
		 * Reference to the document xml. Used when loading in an MXML document. 
		 * */
		function get xml():XML;
		function set xml(value:XML):void;
		
		/**
		 * Reference to the document instance. 
		 * */
		function get instance():Object;
		function set instance(value:Object):void;
		
		/**
		 * Reference to component tree
		 * */
		function get componentDescription():ComponentDescription;
		function set componentDescription(value:ComponentDescription):void;
		
		/**
		 * Collection of history events
		 * */
		function get history():ListCollectionView;
		function set history(value:ListCollectionView):void;
		
		/**
		 * Errors 
		 * */
		function get errors():Array;
		function set errors(value:Array):void;
		
		/**
		 * Warnings 
		 * */
		function get warnings():Array;
		function set warnings(value:Array):void;
		
		/**
		 * Current history event index
		 * */
		function get historyIndex():int;
		function set historyIndex(value:int):void;
		
		/**
		 * Index that history was at when last saved. 
		 * */
		function get lastSavedHistoryIndex():int;
		function set lastSavedHistoryIndex(value:int):void;
		
		/**
		 * Property that tells if document preview is open
		 * */
		function get isPreviewOpen():Boolean;
		function set isPreviewOpen(value:Boolean):void;
		
		/**
		 * Use this to get a reference to a component description by component instance
		 * var descriptor:ComponentDescription = selectedDocument.descriptionsDictionary[component];
		 * */
		function get descriptionsDictionary():Dictionary;
		function set descriptionsDictionary(value:Dictionary):void;
		
		/**
		 * Scale of the document for design view
		 * */
		function get scale():Number;
		function set scale(value:Number):void;
		
		/**
		 * Hook to update data as it's being served
		 * */
		function get saveFunction():Function;
		function set saveFunction(value:Function):void;
		
		/**
		 * Gets the component description for the item from the component dictionary
		 * */
		function getItemDescription(value:*):ComponentDescription;
		
		/**
		 * Adds the instance and component description into the component dictionary
		 * */
		function setItemDescription(value:*, itemDescription:ComponentDescription):void;
		
		/**
		 * Updates the component tree
		 * */
		function updateComponentTree(value:Object = null):void;
		
		/**
		 * Adds the component description into the component dictionary
		 * */
		function addComponentDescription(value:*):ComponentDescription;
		
		/**
		 * Resets the save status after loading a document
		 * */
		function resetSaveStatus():void;
		
		/**
		 * Creates the web template
		 * */
		function createTemplate():void;
	}
}
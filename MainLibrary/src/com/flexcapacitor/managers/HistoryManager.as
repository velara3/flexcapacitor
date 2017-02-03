package com.flexcapacitor.managers
{
	
	import com.flexcapacitor.events.HistoryEvent;
	import com.flexcapacitor.model.HistoryEventData;
	import com.flexcapacitor.model.HistoryEventItem;
	import com.flexcapacitor.model.IDocument;
	import com.flexcapacitor.states.AddItems;
	import com.flexcapacitor.utils.ClassUtils;
	import com.flexcapacitor.utils.supportClasses.log;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.ClassFactory;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.effectClasses.PropertyChanges;
	import mx.managers.LayoutManager;
	import mx.utils.ArrayUtil;
	
	import spark.components.Application;
	import spark.components.Group;
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.BasicLayout;

	use namespace mx_internal;
	
	/**
	 * Dispatched on history change
	 * */
	[Event(name="historyChange", type="com.flexcapacitor.events.HistoryEvent")]
	
	/**
	 * Dispatched on beginning of undo history
	 * */
	[Event(name=BEGINNING_OF_UNDO_HISTORY, type="com.flexcapacitor.events.HistoryEvent")]
	
	/**
	 * Dispatched on end of undo history
	 * */
	[Event(name=END_OF_UNDO_HISTORY, type="com.flexcapacitor.events.HistoryEvent")]
	
	/**
	* History Management<br/><br/>
	
	* NOTE: THIS IS WRITTEN THIS WAY TO WORK WITH FLEX STATES AND TRANSITIONS
	* there is probably a better way but I am attempting to use the flex sdk's
	* own code to apply changes. we could extract that code, create commands, 
	* etc but it seemed like less work and less room for error at the time<br/><br/>
	
	* update oct 27, 2013
	* i think it would be better to move these calls and data to the document class
	* then different document types can handle undo, redo in the way that best 
	* makes sense to it's own needs. 
	* For example, an text editor will handle undo redo differently than 
	* a design or application document. <br/><br/>
	* 
	* and another way we could do history management is create a sequence and 
	* add actions to it (SetAction, AddItem, RemoveItem, etc)
	* that would probably enable easy to use automation and playback
	* if we had proxied these methods here we could have extended the default
	* document and over write the methods to try the sequence method
	 * */
	public class HistoryManager extends EventDispatcher {
		
		
		public function HistoryManager(s:SINGLEDOUBLE):void {
			
		}
		
		private static var _instance:HistoryManager;
		
		public static function get instance():HistoryManager
		{
			if (!_instance) {
				_instance = new HistoryManager(new SINGLEDOUBLE());
			}
			return _instance;
		}
		
		public static function getInstance():HistoryManager {
			return instance;
		}
		
		///public static var radiate:Radiate;
		public static var layoutManager:LayoutManager = LayoutManager.getInstance();
		
		public static var REMOVE_ITEM_DESCRIPTION:String = "Remove";
		public static var ADD_ITEM_DESCRIPTION:String = "Add";
		public static var MOVE_ITEM_DESCRIPTION:String = "Move";
		private static var BEGINNING_OF_HISTORY:String = "Reverted";
		public static var debug:Boolean;
		
		/**
		 * Indicates if undo is available
		 * */
		[Bindable]
		public static var canUndo:Boolean;
		
		/**
		 * Indicates if redo is available
		 * */
		[Bindable]
		public static var canRedo:Boolean;
		
		/**
		 * Collection of items in the property change history
		 * */
		[Bindable]
		public static var history:ListCollectionView = new ArrayCollection();
		
		/**
		 * Dictionary of property change objects
		 * */
		public static var historyEventsDictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Flag to set if you do not want to add an event to history. 
		 * Remember to set this back to false when you are done
		 * */
		[Bindable]
		public static var doNotAddEventsToHistory:Boolean;
		
		/**
		 * Get generic move description 
		 * */
		public static function getMoveDescription(element:Object = null):String {
			if (element==null) {
				return MOVE_ITEM_DESCRIPTION;
			}
			return MOVE_ITEM_DESCRIPTION + " " + ClassUtils.getClassName(element);
		}
		
		/**
		 * Get generic add description 
		 * */
		public static function getAddDescription(element:Object = null):String {
			if (element==null) {
				return ADD_ITEM_DESCRIPTION;
			}
			return ADD_ITEM_DESCRIPTION + " " + ClassUtils.getClassName(element);
		}
		
		/**
		 * Get generic remove description 
		 * */
		public static function getRemoveDescription(element:Object = null):String {
			if (element==null) {
				return REMOVE_ITEM_DESCRIPTION;
			}
			return REMOVE_ITEM_DESCRIPTION + " " + ClassUtils.getClassName(element);
		}
		
		/**
		 * Travel to the specified history index.
		 * Going too fast may cause some issues. Need to test thoroughly 
		 * We may need to call validateNow somewhere and set usePhasedInstantiation? or call calllater()
		 * */
		public static function goToHistoryIndex(document:IDocument, index:int, dispatchEvents:Boolean = false):int {
			//var document:IDocument = instance.selectedDocument;
			var newIndex:int = index;
			var oldIndex:int = document.historyIndex;
			var time:int = getTimer();
			var currentIndex:int;
			var difference:int;
			var phasedInstantiation:Boolean = layoutManager.usePhasedInstantiation;
			
			layoutManager.usePhasedInstantiation = false;
			
			if (newIndex<oldIndex) {
				difference = oldIndex - newIndex;
				for (var i:int;i<difference;i++) {
					if (difference>1) {
						// if we're not on last redo then use faster redo
						if (i+1!=difference) { 
							currentIndex = undo(document, false, dispatchEvents, false);
						}
						else {
							currentIndex = undo(document, dispatchEvents, dispatchEvents);
						}
					}
					else {
						currentIndex = undo(document, dispatchEvents, dispatchEvents);
					}
				}
			}
			else if (newIndex>oldIndex) {
				difference = oldIndex<0 ? newIndex+1 : newIndex - oldIndex;
				
				for (var j:int;j<difference;j++) {
					if (difference>1) {
						// if we're not on last redo then use faster redo
						if (j+1!=difference) {
							currentIndex = redo(document, false, dispatchEvents, false); 
						}
						else {
							currentIndex = redo(document, dispatchEvents, dispatchEvents);
						}
					}
					else {
						currentIndex = redo(document, dispatchEvents, dispatchEvents);
					}
				}
			}
			
			layoutManager.usePhasedInstantiation = phasedInstantiation;
			
			document.history.refresh();
			updateUndoRedoBindings(document, getHistoryPosition(document));
			
			///radiate.dispatchHistoryChangeEvent(document, historyIndex, oldIndex);
			
			
			return currentIndex;
		}
		
		/**
		 * Undo last change. Returns the current index in the changes array. 
		 * The property change object sets the property "reversed" to 
		 * true.
		 * UPDATE 2015 problem below was caused by AddItems class. created new add items
		 * -Going too fast causes some issues (call validateNow somewhere)? 
		 * I think the issue with RangeError: Index 2 is out of range.
		 * is that the History List does not always do the first item in the 
		 * List. So we need to add a first item that does nothing, like a
		 * open history event. 
		 * OR we need to wait. If we could use callLater and not use validateNow
		 * I think it may solve some issues and not lock the UI
		 * 
		 * We might also try not dispatching events until we are at the last or second to last index of a long
		 * undo list.
		 * */
		public static function undo(document:IDocument, dispatchEvents:Boolean = false, dispatchForApplication:Boolean = true, dispatchSetTargets:Boolean = true):int {
			var changeIndex:int = getPreviousHistoryIndex(document); // index of next change to undo 
			var currentIndex:int = getHistoryPosition(document);
			var numberOfHistoryEvents:int = getHistoryCount(document);
			var historyEventItem:HistoryEventItem;
			var previousHistoryEvent:HistoryEventData;
			var currentTargetDocument:Application;
			var setStartValues:Boolean = true;
			var historyEvent:HistoryEventData;
			var affectsDocument:Boolean;
			var historyEventItems:Array;
			var dictionary:Dictionary;
			var reverseItems:AddItems;
			var eventTargets:Array;
			var numberOfEvents:int;
			var numberOfTargets:int;
			var addItems:AddItems;
			var added:Boolean;
			var removed:Boolean;
			var action:String;
			var isInvalid:Boolean;
			var documentHistory:ListCollectionView;
			var description:String;
			
			currentTargetDocument = document.instance as Application;
			documentHistory = document.history;
			
			// no changes
			if (!numberOfHistoryEvents) {
				return -1;
			}
			
			// all changes have already been undone
			if (changeIndex<0) {
				if (dispatchEvents && instance.hasEventListener(HistoryEvent.BEGINNING_OF_UNDO_HISTORY)) {
					instance.dispatchEvent(new HistoryEvent(HistoryEvent.BEGINNING_OF_UNDO_HISTORY));
				}
				
				return -1;
			}
			
			// get current change to be redone
			historyEvent = documentHistory.length ? documentHistory.getItemAt(changeIndex) as HistoryEventData : null;
			historyEventItems = historyEvent.historyEventItems;
			numberOfEvents = historyEventItems.length;
			
			
			// loop through changes starting with newest change then going to oldest
			for (var i:int=numberOfEvents;i--;) {
				//changesLength = changes ? changes.length: 0;
				
				historyEventItem = historyEventItems[i];
				addItems = historyEventItem.addItemsInstance;
				action = historyEventItem.action;//==RadiateEvent.MOVE_ITEM && addItems ? RadiateEvent.MOVE_ITEM : RadiateEvent.PROPERTY_CHANGE;
				affectsDocument = dispatchForApplication && historyEventItem.targets.indexOf(currentTargetDocument)!=-1;
				description = historyEventItem.description;
				
				if (debug) {
					log("Undo: " + description + ", Action: " + action);
				}
				
				// undo the add
				if (action==HistoryEvent.ADD_ITEM) {
					eventTargets = historyEventItem.targets;
					numberOfTargets = eventTargets.length;
					dictionary = historyEventItem.reverseAddItemsDictionary;
					
					for (var j:int=0;j<numberOfTargets;j++) {
						reverseItems = dictionary[eventTargets[j]];
						addItems.remove(null);
						
						// check if it's reverse or property changes
						if (reverseItems) {
							reverseItems.apply(reverseItems.destination as UIComponent);
							
							// was it added - can be refactored
							if (reverseItems.destination==null) {
								added = true;
							}
						}
					}
					
					historyEventItem.reversed = true;
					
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						///radiate.dispatchRemoveItemsEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
					}
				}
				
				// undo the move - (most likely an add action with x and y changes)
				if (action==HistoryEvent.MOVE_ITEM) {
					eventTargets = historyEventItem.targets;
					numberOfTargets = eventTargets.length;
					dictionary = historyEventItem.reverseAddItemsDictionary;
					
					for (j=0;j<numberOfTargets;j++) {
						reverseItems = dictionary[eventTargets[j]];
						
						// check if it's remove items or property changes
						if (reverseItems) {
							isInvalid = layoutManager.isInvalid();
							if (isInvalid) {
								layoutManager.validateNow();
								///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 1.") : 0;
							}
							
							addItems.remove(null);
							isInvalid = layoutManager.isInvalid();
							if (isInvalid) {
								layoutManager.validateNow();
								///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 2.") : 0;
							}
							
							/*
							Below error fixed with new AddItems class
							RangeError: Index 2 is out of range.
										at spark.components::Group/checkForRangeError()[E:\dev\4.y\frameworks\projects\spark\src\spark\components\Group.as:1310]
										at spark.components::Group/setElementIndex()[E:\dev\4.y\frameworks\projects\spark\src\spark\components\Group.as:1474]
										at spark.components::Group/addElementAt()[E:\dev\4.y\frameworks\projects\spark\src\spark\components\Group.as:1371]
										at mx.states::AddItems/addItemsToContentHolder()[E:\dev\4.y\frameworks\projects\framework\src\mx\states\AddItems.as:782]
										at mx.states::AddItems/apply()[E:\dev\4.y\frameworks\projects\framework\src\mx\states\AddItems.as:563]
										at com.flexcapacitor.managers::HistoryManager$/undo()[/Users/monkeypunch/Documents/ProjectsGithub/Radii8/Radii8Library/src/com/flexcapacitor/managers/HistoryManager.as:325]
										at com.flexcapacitor.managers::HistoryManager$/goToHistoryIndex()[/Users/monkeypunch/Documents/ProjectsGithub/Radii8/Radii8Library/src/com/flexcapacitor/managers/HistoryManager.as:168]
										at com.flexcapacitor.managers::HistoryManager$/revert()[/Users/monkeypunch/Documents/ProjectsGithub/Radii8/Radii8Library/src/com/flexcapacitor/managers/HistoryManager.as:1211] 
							*/
							
							// check if out of range 
							//var newIndex:int = isOutOfRange(group,index,true);
							reverseItems.apply(reverseItems.destination as UIComponent);
							
							if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
								///radiate.dispatchRemoveItemsEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
							}
							
							// was it added - note: can be refactored
							if (reverseItems.destination==null) {
								added = true;
							}
						}
						else { // property change
							
							/***
							Radiate.applyChanges(historyEventItem.targets, [historyEventItem.propertyChanges], 
								historyEventItem.properties, historyEventItem.styles, historyEventItem.events,
								setStartValues);
							historyEventItem.reversed = true;
							
							Radiate.updateComponentProperties(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
							Radiate.updateComponentStyles(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.styles);
							Radiate.updateComponentEvents(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.events);
							***/
							
							if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
								///radiate.dispatchPropertyChangeEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties, historyEventItem.styles, historyEventItem.events);
							}
						}
					}
					
					historyEventItem.reversed = true;
				}
					// undo the remove
				else if (action==HistoryEvent.REMOVE_ITEM) {
					isInvalid = layoutManager.isInvalid();
					if (isInvalid) {
						layoutManager.validateNow();
						///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 3") : 0;
					}
					addItems.apply(addItems.destination as UIComponent);
					historyEventItem.reversed = true;
					removed = true;
					
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						///radiate.dispatchAddEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
					}
				}
					// undo the property changes
				else if (action==HistoryEvent.PROPERTY_CHANGED) {
					
					/***
					Radiate.applyChanges(historyEventItem.targets, [historyEventItem.propertyChanges], 
						historyEventItem.properties, historyEventItem.styles, historyEventItem.events,
						setStartValues);
					historyEventItem.reversed = true;
					
					Radiate.updateComponentProperties(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties, true);
					Radiate.updateComponentStyles(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.styles, true);
					Radiate.updateComponentEvents(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.events, true);
					 * 
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						radiate.dispatchPropertyChangeEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties, historyEventItem.styles, historyEventItem.events);
					}
					***/
				}
			}
			
			historyEvent.reversed = true;
			
			// select the target
			if (selectTargetOnHistoryChange) {
				var currentHistoryEvent:HistoryEventData = currentIndex>0 ? documentHistory.getItemAt(currentIndex-1) as HistoryEventData : null;
				
				/***
				if (currentHistoryEvent) {
					radiate.setTargets(currentHistoryEvent.targets, dispatchSetTargets);
				}
				else {
					radiate.setTarget(currentTargetDocument, dispatchSetTargets);
				}
				***/
				
				/*
				if (added) { 
					// item was added and now unadded - select previous available targets
					if (currentIndex>0) {
						
						var previousTargets:Array = getNextPreviousTargets(document, currentIndex);
						
						if (previousTargets) {
							//Radiate.info("Previous targets found");
							radiate.setTarget(previousTargets, dispatchSetTargets);
						}
						else {
							//Radiate.warn("Previous target NOT found. Selecting document");
							radiate.setTarget(currentTargetDocument, dispatchSetTargets);
						}
					}
					else {
						radiate.setTarget(currentTargetDocument, dispatchSetTargets);
					}
				}
				else if (removed) {
					radiate.setTargets(historyEventItem.targets, dispatchSetTargets);
				}
				else {
					radiate.setTargets(historyEventItem.targets, dispatchSetTargets);
				}
				*/
			}
			
			
			
			if (numberOfEvents) {
				updateUndoRedoBindings(document, getHistoryPosition(document));
				
				if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
					///radiate.dispatchHistoryChangeEvent(document, historyIndex, currentIndex, historyEvent);
				}
				
				// all changes have already been undone
				if (changeIndex-1<0) {
					if (dispatchEvents && instance.hasEventListener(HistoryEvent.BEGINNING_OF_UNDO_HISTORY)) {
						instance.dispatchEvent(new HistoryEvent(HistoryEvent.BEGINNING_OF_UNDO_HISTORY));
					}
				}
				
				return changeIndex-1;
			}
			
			return numberOfHistoryEvents;
		}
		
		/**
		 * Redo last change. See notes in undo method. 
		 * @see undo
		 * */
		public static function redo(document:IDocument, dispatchEvents:Boolean = false, dispatchForApplication:Boolean = true, dispatchSetTargets:Boolean = true):int {
			//var currentDocument:IDocument = instance.selectedDocument;
			var historyCollection:ListCollectionView = document.history;
			var currentTargetDocument:Application = document.instance as Application; // should be typed
			var numberOfHistoryEvents:int = historyCollection.length;
			var changeIndex:int = getNextHistoryIndex(document);
			var currentIndex:int = getHistoryPosition(document);
			var historyEventItem:HistoryEventItem;
			var historyEvent:HistoryEventData;
			var affectsDocument:Boolean;
			var setStartValues:Boolean;
			var historyEventItems:Array;
			var addItems:AddItems;
			var isInvalid:Boolean;
			var numberOfEvents:int;
			var remove:Boolean;
			var action:String;
			var description:String;
			
			
			// need to make sure everything is validated first
			// think about doing the following:
			// layoutManager.usePhasedInstantiation = false;
			// layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid. Needs a fix.") : 0;
			// also use in undo()
			
			// no changes made
			if (!numberOfHistoryEvents) {
				return -1;
			}
			
			// cannot redo any more changes
			if (changeIndex==-1 || changeIndex>=numberOfHistoryEvents) {
				if (instance.hasEventListener(HistoryEvent.END_OF_UNDO_HISTORY)) {
					instance.dispatchEvent(new HistoryEvent(HistoryEvent.END_OF_UNDO_HISTORY));
				}
				
				return numberOfHistoryEvents-1;
			}
			
			// get current change to be redone
			historyEvent = historyCollection.length ? historyCollection.getItemAt(changeIndex) as HistoryEventData : null;
			
			historyEventItems = historyEvent.historyEventItems;
			numberOfEvents = historyEventItems.length;
			
			for (var j:int=numberOfEvents;j--;) {
				historyEventItem = HistoryEventItem(historyEventItems[j]);
				
				addItems = historyEventItem.addItemsInstance;
				action = historyEventItem.action;
				affectsDocument = dispatchForApplication && historyEventItem.targets.indexOf(currentTargetDocument)!=-1;
				description = historyEventItem.description;
				
				if (debug) {
					log("Redo: " + description + ", Action: " + action);
				}
				
				if (action==HistoryEvent.ADD_ITEM) {
					isInvalid = layoutManager.isInvalid();
					if (isInvalid) {
						layoutManager.validateNow();
						///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 4.") : 0;
					}
					// redo the add
					addItems.apply(addItems.destination as UIComponent);
					historyEventItem.reversed = false;
					
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						///radiate.dispatchAddEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
					}
					
				}
				else if (action==HistoryEvent.MOVE_ITEM) {
					
					// redo the move
					if (addItems) {
						
						// RangeError: Index 2 is out of range. 
						// we must validate
						isInvalid = layoutManager.isInvalid();
						if (isInvalid) {
							layoutManager.validateNow();
							///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 5") : 0;
						}
						
						// RangeError: Index 2 is out of range. 
						// should we use a try catch? delay it somehow?
						try {
							addItems.apply(addItems.destination as UIComponent);
						}
						catch (e:*) {
							// if RangeError: Index 2 is out of range.
							historyEventItem.reversed = false;
							undo(document, false, false, false);
							
							///Radiate.error("There was an error moving one of the components. You may need to restart.");
							return -1;
							//return redo(document, dispatchEvents, dispatchForApplication, dispatchSetTargets);;
						}
						
						historyEventItem.reversed = false;
						
						if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
							///radiate.dispatchMoveEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
						}
					}
					else {
						
						/***
						Radiate.applyChanges(historyEventItem.targets, [historyEventItem.propertyChanges], 
							historyEventItem.properties, historyEventItem.styles, historyEventItem.events,
							setStartValues);
						
						historyEventItem.reversed = false;
						
						if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
							radiate.dispatchPropertyChangeEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties, historyEventItem.styles, historyEventItem.events);
						}
						***/
					}
					
				}
				else if (action==HistoryEvent.REMOVE_ITEM) {
					
					isInvalid = layoutManager.isInvalid();
					if (isInvalid) {
						layoutManager.validateNow();
						///layoutManager.isInvalid() ? Radiate.log.debug("Layout Manager is still invalid at note 6") : 0;
					}
					
					// redo the remove
					addItems.remove(addItems.destination as UIComponent);
					historyEventItem.reversed = false;
					remove = true;
					
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						///radiate.dispatchRemoveItemsEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
					}
				}
				else if (action==HistoryEvent.PROPERTY_CHANGED) {
					/***
					Radiate.applyChanges(historyEventItem.targets, [historyEventItem.propertyChanges], 
						historyEventItem.properties, historyEventItem.styles, historyEventItem.events,
						setStartValues);
					historyEventItem.reversed = false;
					
					Radiate.updateComponentProperties(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties);
					Radiate.updateComponentStyles(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.styles);
					Radiate.updateComponentEvents(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.events);
					
					if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
						radiate.dispatchPropertyChangeEvent(historyEventItem.targets, [historyEventItem.propertyChanges], historyEventItem.properties, historyEventItem.styles, historyEventItem.events);
					}
					***/
				}
			}
			
			
			historyEvent.reversed = false;
			
			// select target
			if (selectTargetOnHistoryChange) {
				/***
				if (remove) {
					radiate.setTargets(currentTargetDocument, dispatchSetTargets);
				}
				else {
					radiate.setTargets(historyEventItem.targets, dispatchSetTargets);
				}
				***/
			}
			
			if (numberOfEvents) {
				updateUndoRedoBindings(document, getHistoryPosition(document));
				
				/***
				if (dispatchEvents || (dispatchForApplication && affectsDocument)) {
					
					radiate.dispatchHistoryChangeEvent(document, historyIndex, currentIndex, historyEvent);
				}
				
				// cannot redo any more changes
				if (changeIndex>=numberOfHistoryEvents) {
					if (instance.hasEventListener(HistoryEvent.END_OF_UNDO_HISTORY)) {
						instance.dispatchEvent(new HistoryEvent(HistoryEvent.END_OF_UNDO_HISTORY));
					}
				}
				***/
				
				return changeIndex;
			}
			
			return numberOfHistoryEvents;
		}
		
		
		/**
		 *  @private 
		 *  Checks the range of index to make sure it's valid. 
		 * 
		 * Returns 0 if not out of range, -1 if less than zero and maxIndex if greater than range.
		 * 
		 * Use if (isOutOfRange(group,index,true)==0)  // not out of range
		 * Use if (isOutOfRange(group,index,true)<0)  // out of range - too low - use 0
		 * Use if (isOutOfRange(group,index,true)>0)  // out of range - too high - use var newIndex:int = isOutOfRange(group,index,true)
		 */ 
		public static function isOutOfRange(group:Group, index:int, addingElement:Boolean = false):int {
			var mxmlContent:Array = group.getMXMLContent();
			
			// figure out the maximum allowable index
			var maxIndex:int = (mxmlContent == null ? -1 : mxmlContent.length - 1);
			
			// if adding an element, we allow an extra index at the end
			if (addingElement) {
				maxIndex++;
			}
			
			if (index < 0) {
				return -1;
			}
			if (index > maxIndex) {
				return maxIndex;
			}
			
			return 0;
		}
		
		/**
		 * Get the targets from the previous history event as long as 
		 * the first one is on the stage
		 * */
		public static function getNextPreviousTargets(document:IDocument, index:int):Array {
			var previousHistoryEvent:HistoryEventData;
			
			while (index>0) {
				index--;
				previousHistoryEvent = document.history.getItemAt(index) as HistoryEventData;
				if (previousHistoryEvent.targets && previousHistoryEvent.targets.length
					&& previousHistoryEvent.targets[0].stage) {
					return previousHistoryEvent.targets;
				}
			}	
			
			return null;
		}
		
		//private static var _historyIndex:int = -1;
		
		/**
		 * Selects the target on undo and redo
		 * */
		public static var selectTargetOnHistoryChange:Boolean = true;
		
		private static var _historyIndex:int = -1;
		
		/**
		 * Current history index. 
		 * The history index is the index of last applied change. Or
		 * to put it another way the index of the last reversed change minus 1. 
		 * If there are 10 total changes and one has been reversed then 
		 * we would be at the 9th change. The history index would 
		 * be 8 since 9-1 = 8 since the array is a zero based index. 
		 * 
		 * value -1 means no history
		 * value 0 means one item
		 * value 1 means two items
		 * value 2 means three items
		 * */
		public static function get historyIndex():int {
			
			return _historyIndex;
			//var document:IDocument = instance.selectedDocument;
			//return document ? document.historyIndex : -1;
		}
		
		/**
		 * This sets the canUndo and canRedo bindable properties. It may be worth 
		 * updating to prevent events when opening a document.
		 * @private
		 */
		public static function updateUndoRedoBindings(document:IDocument, value:int, setBindables:Boolean = true):void {
			if (document==null) return;
			
			if (document.historyIndex==value) {
				//
			}
			else {
				document.historyIndex = value;
			}
			
			_historyIndex = value;
			
			var totalItems:int = document.history ? document.history.length : 0;
			var hasItems:Boolean = totalItems>0;
			
			// has forward history
			if (hasItems && historyIndex+1<totalItems) {
				canRedo = true;
			}
			else {
				canRedo = false;
			}
			
			// has previous items
			if (hasItems && historyIndex>-1) {
				canUndo = true;
			}
			else {
				canUndo = false;
			}
		}
		
		/**
		 * Get the index of the next item that can be undone. 
		 * If there are 10 changes and one has been reversed the 
		 * history index would be 8 since 10-1=9-1=8 since the array is 
		 * a zero based index. 
		 * */
		public static function getPreviousHistoryIndex(document:IDocument):int {
			var numberOfEvents:int = getHistoryCount(document);var listCollectionView:ListCollectionView = document.history;
			var historyEvent:HistoryEventData;
			var index:int;
			
			for (var i:int;i<numberOfEvents;i++) {
				historyEvent = listCollectionView.getItemAt(i) as HistoryEventData;
				
				if (historyEvent.reversed) {
					return i-1;
				}
			}
			
			return numberOfEvents-1;
		}
		
		/**
		 * Get the index of the next item that can be redone in the history array. 
		 * If there are 10 changes and one has been reversed the 
		 * next history index would be 9 since 10-1=9-1=8+1=9 since the array is 
		 * a zero based index. 
		 * */
		public static function getNextHistoryIndex(document:IDocument):int {
			var numberOfEvents:int = getHistoryCount(document);
			var historyItem:HistoryEventData;
			var index:int;
			
			// start at the beginning and find the next item to redo
			for (var i:int;i<numberOfEvents;i++) {
				historyItem = document.history.getItemAt(i) as HistoryEventData;
				
				if (historyItem.reversed) {
					return i;
				}
			}
			
			return numberOfEvents;
		}
		
		/**
		 * Get history index. This should return the index of the 
		 * last action that was performed. 
		 * */
		public static function getHistoryPosition(document:IDocument):int {
			var numberOfEvents:int = getHistoryCount(document);
			var historyEvent:HistoryEventData;
			var events:IList = document ? document.history as IList : null;
			
			// go through and find last item that is reversed
			for (var i:int;i<numberOfEvents;i++) {
				historyEvent = events.getItemAt(i) as HistoryEventData;
				
				if (historyEvent.reversed) {
					return i-1;
				}
			}
			
			return numberOfEvents-1;
		}
		
		/**
		 * Returns the current history event. Think about adding an "Open"
		 * event so we always have something to work with.
		 * */
		public static function getCurrentHistoryEvent(document:IDocument):HistoryEventData {
			var index:int = getHistoryPosition(document);
			var historyEvent:HistoryEventData = getHistoryEventAtIndex(document, index) as HistoryEventData;
			
			return historyEvent;
		}
		
		/**
		 * Returns the history event by index
		 * */
		public static function getHistoryEventAtIndex(document:IDocument, index:int):HistoryEventData {
			var numberOfEvents:int = getHistoryCount(document);
			var historyEvent:HistoryEventData;
			
			// no changes
			if (numberOfEvents < 1) {
				return null;
			}
			
			// all changes have already been undone
			if (index<0) {
				return null;
			}
			
			// get history event 
			historyEvent = document.history.length ? document.history.getItemAt(index) as HistoryEventData : null;
			
			return historyEvent;
		}
		
		/**
		 * Returns the history event by index
		 * */
		public static function removeHistoryItemAtIndex(document:IDocument, index:int, purge:Boolean = true):HistoryEventData {
			var numberOfEvents:int = getHistoryCount(document);
			var historyEvent:HistoryEventData;
			
			// no changes
			if (numberOfEvents < 1) {
				return null;
			}
			
			// all changes have already been undone
			if (index<0) {
				return null;
			}
			
			// get removed history 
			historyEvent = numberOfEvents ? document.history.removeItemAt(index) as HistoryEventData : null;
			
			if (purge) {
				historyEvent.purge();
			}
			
			return historyEvent;
		}
		
		private static var _disableHistoryManagement:Boolean;
		
		/**
		 * Disables history management. We do this when importing documents since
		 * it creates the document 5x faster. 
		 * */
		public static function get disableHistoryManagement():Boolean {
			return _disableHistoryManagement;
		}
		
		/**
		 * @private
		 */
		[Bindable(event="disableHistoryManagement")]
		public static function set disableHistoryManagement(value:Boolean):void {
			if (_disableHistoryManagement == value) return;
			_disableHistoryManagement = value;
		}
		
		
		/**
		 * Creates a history event items that will be stored in the history collection. 
		 * Changes can contain a property or style changes or add items. 
		 * Must call addHistoryEvent with the event items returned from this call.
		 * */
		public static function createHistoryEventItems(targets:Array, changes:Array, properties:*, styles:*, events:*, value:*, description:String = null, action:String=HistoryEvent.PROPERTY_CHANGED, remove:Boolean = false):Array {
			var factory:ClassFactory = new ClassFactory(HistoryEventItem);
			var historyEventItem:HistoryEventItem;
			var reverseAddItems:AddItems;
			var eventItems:Array = [];
			var change:Object;
			var numberOfTargets:int;
			var numberOfChanges:int = changes ? changes.length : 0;
			
			if (disableHistoryManagement) return [];
			
			// create property change objects for each
			for (var i:int;i<numberOfChanges;i++) {
				change = changes[i];
				
				historyEventItem 						= factory.newInstance();
				historyEventItem.action 				= action;
				historyEventItem.targets 				= targets;
				historyEventItem.description 			= description;
				
				// check for property change or add display object
				if (change is PropertyChanges) {
					historyEventItem.events				= ArrayUtil.toArray(events);
					historyEventItem.properties 		= ArrayUtil.toArray(properties);
					historyEventItem.styles 			= ArrayUtil.toArray(styles);
					historyEventItem.propertyChanges 	= PropertyChanges(change);
				}
				else if (change is AddItems && !remove) {
					historyEventItem.addItemsInstance 	= AddItems(change);
					numberOfTargets = targets.length;
					
					// trying to add support for multiple targets - it's not all there yet
					// probably not the best place to get the previous values or is it???
					for (var j:int=0;j<numberOfTargets;j++) {
						historyEventItem.reverseAddItemsDictionary[targets[j]] = createReverseAddItems(targets[j]);
					}
				}
				else if (change is AddItems && remove) {
					historyEventItem.removeItemsInstance 	= AddItems(change);
					numberOfTargets = targets.length;
					
					// trying to add support for multiple targets - it's not all there yet
					// probably not the best place to get the previous values or is it???
					for (j=0;j<numberOfTargets;j++) {
						historyEventItem.reverseRemoveItemsDictionary[targets[j]] = createReverseAddItems(targets[j]);
					}
				}
				
				eventItems[i] = historyEventItem;
			}
			
			return eventItems;
			
		}
		
		/**
		 * Creates a remove item from an add item. 
		 * */
		public static function createReverseAddItems(target:Object):AddItems {
			var elementContainer:IVisualElementContainer;
			var position:String = AddItems.LAST;
			var visualElement:IVisualElement;
			var reverseAddItems:AddItems;
			var elementIndex:int = -1;
			var propertyName:String; 
			var destination:Object;
			var description:String;
			var relativeTo:Object; 
			var vectorClass:Class;
			var isStyle:Boolean; 
			var isArray:Boolean; 
			var index:int = -1; 
			
			if (!target) return null;
			
			// create add items with current values we can revert back to
			reverseAddItems = new AddItems();
			reverseAddItems.destination = target.parent;
			reverseAddItems.items = target;
			
			destination = reverseAddItems.destination;
			
			visualElement = target as IVisualElement;
			
			// set default
			if (!position) {
				position = AddItems.LAST;
			}
			
			// Check for non basic layout destination
			// if destination is not a basic layout
			// find the position and set the relative object 
			if (destination is IVisualElementContainer 
				&& destination.numElements>0) {
				elementContainer = destination as IVisualElementContainer;
				index = elementContainer.getElementIndex(visualElement);
				
				
				if (elementContainer is GroupBase 
					&& !(GroupBase(elementContainer).layout is BasicLayout)) {
					
					
					// add as first item
					if (index==0) {
						position = AddItems.FIRST;
					}
						
						// get relative to object
					else if (index<=elementContainer.numElements) {
						
						
						// if element is already child of container account for remove of element before add
						if (visualElement && visualElement.parent == destination) {
							elementIndex = destination.getElementIndex(visualElement);
							index = elementIndex < index ? index-1: index;
							
							if (index<=0) {
								position = AddItems.FIRST;
							}
							else {
								relativeTo = destination.getElementAt(index-1);
								position = AddItems.AFTER;
							}
						}
							// add as last item
						else if (index>=destination.numElements) {
							position = AddItems.LAST;
						}
							// add after first item
						else if (index>0) {
							relativeTo = destination.getElementAt(index-1);
							position = AddItems.AFTER;
						}
					}
				}
			}
			
			
			reverseAddItems.destination = destination;
			reverseAddItems.position = position;
			reverseAddItems.relativeTo = relativeTo;
			reverseAddItems.propertyName = propertyName;
			reverseAddItems.isArray = isArray;
			reverseAddItems.isStyle = isStyle;
			reverseAddItems.vectorClass = vectorClass;
			
			return reverseAddItems;
		}
		
		/**
		 * Stores a history event in the history events dictionary
		 * Changes can contain a property changes object or add items object
		 * UPDATE: Looks like this is old code. Not sure this is removing 
		 * history event items?
		 * */
		public static function removeHistoryEvent(changes:Array):void {
			var change:Object;
			
			// delete change objects
			for each (change in changes) {
				historyEventsDictionary[change] = null;
				delete historyEventsDictionary[change];
			}
			
		}
		
		/**
		 * Adds a single event change to the history collection
		 * */
		public static function addHistoryEvent(document:IDocument, historyEventItem:HistoryEventItem, description:String = null):void {
			if (!doNotAddEventsToHistory) {
				addHistoryEvents(document, ArrayUtil.toArray(historyEventItem), description);
			}
		}
		
		/**
		 * Creates a new entry with multiple changes to the history collection
		 * Changes include property changes, add or remove event items 
		 * */
		public static function addHistoryEvents(document:IDocument, historyEventItems:Array, description:String = null, mergeWithPrevious:Boolean = false, dispatchEvents:Boolean = true):void {
			if (doNotAddEventsToHistory) { return; }
			var currentIndex:int = getHistoryPosition(document);
			var numberOfHistoryEvents:int = getHistoryCount(document);
			var numberOfHistoryEventItems:int;
			var historyEventItem:HistoryEventItem;
			var historyEvent:HistoryEventData;
			var numberOfTargets:int;
			var historyTargets:Array;
			var historyTarget:Object;
			var noPreviousChanges:Boolean = !hasPreviousEvents(document);
			
			if (disableHistoryManagement) return;
			
			document.history.disableAutoUpdate();
			
			// trim history 
			if (currentIndex!=numberOfHistoryEvents-1) {
				for (var i:int = numberOfHistoryEvents-1;i>currentIndex;i--) {
					historyEvent = document.history.removeItemAt(i) as HistoryEventData;
					historyEvent.purge();
				}
			}
			
			if (!mergeWithPrevious || noPreviousChanges) {
				historyEvent = new HistoryEventData();
				historyEvent.description = description ? description : HistoryEventItem(historyEventItems[0]).description;
				historyEvent.historyEventItems = historyEventItems;
			}
			else {
				historyEvent = getHistoryEventAtIndex(document, i);
				historyEvent.historyEventItems.concat(historyEventItems);
			}
			
			numberOfHistoryEventItems = historyEventItems.length;
			
			// UPDATE: We could remove the following and let other code pull the targets from the event item changes
			// add targets that are affected by this history change
			// so we can select them later
			// we should remember to remove these references when truncating history
			for (i=0;i<numberOfHistoryEventItems;i++) {
				historyEventItem = historyEventItems[i];
				historyTargets = historyEventItem.targets;
				numberOfTargets = historyTargets.length;
				
				for (var j:int=0;j<numberOfTargets;j++) {
					historyTarget = historyTargets[j];
					
					if (historyEvent.targets.indexOf(historyTarget)==-1) {
						historyEvent.targets.push(historyTarget);
					}
				}
			}
			
			if (!mergeWithPrevious || noPreviousChanges) {
				document.history.addItem(historyEvent);
				document.historyIndex = getHistoryPosition(document);
			}
			
			document.history.enableAutoUpdate();
			
			// the next few lines could be refactored. 
			// we created a history manager class and 
			// now document is passed in rather than a member
			// so we can probably fix what this is trying to do...
			document.historyIndex = getHistoryPosition(document);
			
			updateUndoRedoBindings(document, getHistoryPosition(document));
			
			if (dispatchEvents) {
				var eventTargets:Array = getHistoryEventTargets(historyEventItems);
				if (!mergeWithPrevious || noPreviousChanges) {
					///radiate.dispatchHistoryChangeEvent(document, currentIndex+1, currentIndex, historyEvent);
				}
				else {
					///radiate.dispatchHistoryChangeEvent(document, currentIndex, currentIndex, historyEvent);
				}
			}
		}
		
		/**
		 * Get targets from history event items
		 * */
		public static function getHistoryEventTargets(historyEventItems:Array):Array {
			var targets:Array = [];
			var historyEventItem:HistoryEventItem;
			var target:Object;
			var eventTargets:Array;
			
			for (var i:int = 0; i < historyEventItems.length; i++) {
				historyEventItem = historyEventItems[i];
				eventTargets = historyEventItem.targets;
				
				for (var j:int = 0; j < historyEventItems.length; j++) 
				{
					target = eventTargets[j];
					
					if (targets.indexOf(target)==-1) {
						targets.push(target);
					}
				}
				
			}
			
			return targets;
		}
		
		/**
		 * Merges last history event with history event before it if one exists.
		 * The description of the oldest event is used unless you pass one in. 
		 * Returns HistoryEvent with merged changes or null if no merges available
		 * */
		public static function mergeLastHistoryEvent(document:IDocument, description:String = null):HistoryEventData {
			var currentPosition:int = getHistoryPosition(document);
			var numberOfEvents:int = getHistoryCount(document);
			var currentHistoryEvent:HistoryEventData;
			var previousHistoryEvent:HistoryEventData;
			var numberOfHistoryEventItems:int;
			var historyEventItems:Array;
			var historyEventItem:HistoryEventItem;
			var numberOfHistoryTargets:int;
			var historyTargets:Array;
			var historyTarget:Object;
			var historyCollection:ListCollectionView;var prev:String;var current:String;
			
			// more than one thing has happened
			if (!hasPreviousEvents(document)) {
				return null;
			}
			
			currentHistoryEvent = getHistoryEventAtIndex(document, currentPosition);
			previousHistoryEvent = getHistoryEventAtIndex(document, currentPosition-1);
			
			prev = previousHistoryEvent.description;
			current = currentHistoryEvent.description;
			
			// the order seems to matter - if you are removing something then adding something else
			// the position in non basic layout changes when an object is removed 
			previousHistoryEvent.historyEventItems = currentHistoryEvent.historyEventItems.concat(previousHistoryEvent.historyEventItems);
			//previousHistoryEvent.historyEventItems = previousHistoryEvent.historyEventItems.concat(currentHistoryEvent.historyEventItems);
			
			if (description!=null) {
				previousHistoryEvent.description = description;
			}
			
			if (disableHistoryManagement) return null;
			
			historyCollection = document.history;
			
			historyCollection.disableAutoUpdate();
			
			historyEventItems = previousHistoryEvent.historyEventItems;
			numberOfHistoryEventItems = historyEventItems.length;
			
			// add targets so we can select them later
			// we should remember to remove these references when truncating history
			for (var i:int=0;i<numberOfHistoryEventItems;i++) {
				historyEventItem = historyEventItems[i];
				historyTargets = historyEventItem.targets;
				numberOfHistoryTargets = historyTargets.length;
				
				for (var j:int=0;j<numberOfHistoryTargets;j++) {
					historyTarget = historyTargets[j];
					
					if (previousHistoryEvent.targets.indexOf(historyTarget)==-1) {
						previousHistoryEvent.targets.push(historyTarget);
					}
				}
			}
			
			historyCollection.removeItem(currentHistoryEvent);
			
			historyCollection.enableAutoUpdate();
			
			historyCollection.refresh();
			
			// the next few lines could be refactored. 
			// we created a history manager class and 
			// now document is passed in rather than a member
			// so we can probably fix what this is trying to do...
			document.historyIndex = getHistoryPosition(document);
			
			updateUndoRedoBindings(document, getHistoryPosition(document));
			
			///radiate.dispatchHistoryChangeEvent(document, currentPosition-1, currentPosition, previousHistoryEvent);
			
			return previousHistoryEvent;
		}
		
		/**
		 * Returns true if previous history events are available.
		 * Prevents merge into nothing
		 * */
		public static function hasPreviousEvents(document:IDocument):Boolean {
			var currentPosition:int = getHistoryPosition(document);
			
			// more than one thing has happened
			if (currentPosition<1) {
				return false;
			}
			
			return true;
		}
		
		/**
		 * Get length of history events
		 * */
		public static function getHistoryCount(document:IDocument):int
		{
			return document && document.history ? document.history.length : 0;
		}
		
		/**
		 * Removes property change items in the history array. May be outdated 
		 * and broken.
		 * */
		public static function removeHistoryItem(document:IDocument, changes:Array):void {
			var currentIndex:int = getHistoryPosition(document);
			
			// haven't checked this but this may not work and be old code
			// history should be storing history events not changes
			var itemIndex:int = document.history.getItemIndex(changes);
			
			if (itemIndex>0) {
				document.history.removeItemAt(itemIndex);
			}
			
			document.historyIndex = getHistoryPosition(document);
			updateUndoRedoBindings(document, document.historyIndex);
			
			///Radiate.instance.dispatchHistoryChangeEvent(document, currentIndex-1, currentIndex);
		}
		
		/**
		 * Removes all history in the history array. 
		 * */
		public static function removeAllHistory(document:IDocument):void {
			//var document:IDocument = instance.selectedDocument;
			var currentIndex:int = getHistoryPosition(document);
			var collection:ListCollectionView = document.history;
			var numberOfHistoryEvents:int = collection.length;
			var historyEvent:HistoryEventData;
			
			for (var i:int = numberOfHistoryEvents-1;i>currentIndex;i--) {
				historyEvent = collection.getItemAt(i) as HistoryEventData;
				historyEvent.purge();
			}
			collection.removeAll();
			collection.refresh();
			
			///Radiate.instance.dispatchHistoryChangeEvent(document, -1, currentIndex);
		}
		
		/**
		 * Reverts the document to the opening state.
		 * This means it removes all action events and the document should be blank.
		 * */
		public static function revert(iDocument:IDocument):void
		{
			goToHistoryIndex(iDocument, -1);
			removeAllHistory(iDocument);
		}
		
		/**
		 * Selects the targets at the specific history event
		 * */
		public static function selectTargetsAtIndex(document:IDocument, index:int, dispatchEvent:Boolean = true):void {
			var historyEvent:HistoryEventData = getHistoryEventAtIndex(document, index);
			
			if (historyEvent) {
				///Radiate.setTargets(historyEvent.targets, dispatchEvent);
			}
			
		}
		
		/**
		 * Selects the targets of the current history event
		 * */
		public static function selectCurrentEventTargets(document:IDocument, dispatchEvent:Boolean = true):void {
			var historyEvent:HistoryEventData = getCurrentHistoryEvent(document);
			
			if (historyEvent) {
				///Radiate.setTargets(historyEvent.targets, dispatchEvent);
			}
		}
		
		/**
		 * Useful if you need to perform an action if the first action is successful 
		 * */
		public static function swapLastHistoryEvents(document:IDocument, offset:int = 1, dispatchEvent:Boolean = true):void {
			var history:ListCollectionView = document.history;
			var lastItem:HistoryEventData;
			var previousItem:HistoryEventData;
			
			history.disableAutoUpdate();
			
			lastItem = history.removeItemAt(history.length-1) as HistoryEventData;
			previousItem = history.removeItemAt(history.length-1) as HistoryEventData;
			
			history.addItem(lastItem);
			history.addItem(previousItem);
			
			history.enableAutoUpdate();
			history.refresh();
			
			if (dispatchEvent) {
				///Radiate.instance.dispatchHistoryChangeEvent(document, history.length-2, history.length-1, previousItem);
			}
			
		}
	}
}

class SINGLEDOUBLE{}
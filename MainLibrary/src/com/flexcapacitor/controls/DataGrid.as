



package com.flexcapacitor.controls
{
	import spark.components.DataGrid;
	
	
	/**
	 *  Dispatched before the data in item editor has been saved into the data provider
	 *  and the editor has been closed. 
	 *
	 *  @eventType com.flexcapacitor.controls.DataGrid.GRID_ITEM_EDITOR_SESSION_SAVING
	 *  
	 *  @see spark.components.DataGrid.itemEditorInstance
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="gridItemEditorSessionSaving", type="spark.events.GridItemEditorEvent")]
	
	
	/**
	 * 
	 * Adds a gridItemEditorSessionSaving event. 
	 * It is up to the grid item editor to dispatch this event
	 * 
	 * 
	 * Use com.flexcapacitor.skins.DataGridSkin for showHeader option.
	 * @inherit
	 * 
	 * */
	public class DataGrid extends spark.components.DataGrid
	{
		
		public static const GRID_ITEM_EDITOR_SESSION_SAVING:String = "gridItemEditorSessionSaving";
		
		public function DataGrid()
		{
			super();
		}
	}
}
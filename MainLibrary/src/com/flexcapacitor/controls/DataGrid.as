



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
	 * Shows or hides the header
	 * */
	[Style(name="showHeader", inherit="no", type="Boolean")]
	
	/**
	 * Sets the color of the header row separator
	 * */
	[Style(name="headerRowSeparatorColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Vertical column separator color
	 * */
	[Style(name="columnSeparatorColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the alpha on the column separator
	 * */
	[Style(name="columnSeparatorAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
	/**
	 * Sets the alpha on the column separator
	 * */
	[Style(name="columnSeparatorWeight", inherit="no", type="int")]
	
	/**
	 * Row separator color
	 * */
	[Style(name="rowSeparatorColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the alpha on the row separator
	 * */
	[Style(name="rowSeparatorAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
	/**
	 * Sets the weight on the row separator line
	 * */
	[Style(name="rowSeparatorWeight", inherit="no", type="int")]
	
	/**
	 * Header column separator color
	 * */
	[Style(name="headerColumnSeparatorColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Header background color
	 * */
	[Style(name="headerBackgroundColor", inherit="yes", type="uint", format="Color")]
	
	/**
	 * 
	 * Adds a gridItemEditorSessionSaving event. 
	 * It is up to the grid item editor to dispatch this event
	 * 
	 * 
	 * Make sure this is using com.flexcapacitor.skins.DataGridSkin
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
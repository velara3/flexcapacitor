



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
	 * Shows or hides the border
	 * */
	[Style(name="borderVisible", inherit="no", type="Boolean")]
	
	/**
	 * Sets the color of the caret
	 * */
	[Style(name="selectionBorderColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the alpha of the caret
	 * */
	[Style(name="selectionBorderAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
	/**
	 * Sets the alpha of the roll over color
	 * */
	[Style(name="rollOverAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
	/**
	 * Sets the background color
	 * */
	[Style(name="backgroundColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the background alpha
	 * */
	[Style(name="backgroundAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
	/**
	 * Sets the color of the header text
	 * */
	[Style(name="headerTextColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the color of the header row separator
	 * */
	[Style(name="headerRowSeparatorColor", inherit="no", type="uint", format="Color")]
	
	/**
	 * Sets the alpha on the header row separator
	 * */
	[Style(name="headerRowSeparatorAlpha", inherit="no", type="Number", minValue="0", maxValue="1")]
	
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
	 * Adds additional styles: <br/> <br/>
	 * 
	 * - Added columnSeparatorAlpha <br/>
	 * - Added columnSeparatorColor <br/>
	 * - Added columnSeparatorWeight <br/>
	 * - Added headerBackgroundColor <br/>
	 * - headerRowSeparatorColor <br/>
	 * - headerRowSeparatorAlpha <br/>
	 * - rowSeparatorAlpha <br/>
	 * - rowSeparatorColor <br/>
	 * - rowSeparatorWeight <br/>
	 * - showHeader <br/>
	 * - selectionBorderColor style check which is alternative for caretColor <br/>
	 * - selectionBorderAlpha <br/>
	 * - rollOverAlpha <br/>
	 * - backgroundColor<br/>
	 * - backgroundAlpha<br/>
	 * - Fixes the header top line showing when borderVisible is false. <br/>
	 * - Adds a gridItemEditorSessionSaving event. It is up to the grid item editor to dispatch this event. <br/>
	 * - Backwards compatible with Flex 4.6 <br/> <br/>
	 *
	 *  <p>The <code>&lt;s:DataGrid&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:DataGrid
	 *    <strong>Events</strong>
	 *    gridItemEditorSessionSaving="<i>No default</i>"
	 *  
	 *    <strong>Styles</strong>
	 *    columnSeparatorAlpha="0x0099FF"
	 *    columnSeparatorColor="useDominantBaseline"
	 *    columnSeparatorWeight="1"
	 *    headerBackgroundColor="1.0"
	 *    headerRowSeparatorColor="0xFFFFFF"
	 *    headerRowSeparatorAlpha="1"
	 *    rowSeparatorAlpha="1.0"
	 *    rowSeparatorColor="red"
	 *    rowSeparatorWeight="1"
	 *    selectionBorderColor="blue"
	 *    selectionBorderAlpha="1"
	 *    backgroundColor="0xFFFFFF"
	 *    backgroundAlpha="1"
	 *    rollOverAlpha="1"
	 *    showHeader="true"
	 *  /&gt;
	 *  </pre>
	 * 
	 * Backwards compatible with Flex 4.6.
	 * 
	 * Make sure this is using com.flexcapacitor.skins.DataGridSkin
	 * @inheritDoc
	 * 
	 * */
	public class DataGrid extends spark.components.DataGrid {
		
		public static const GRID_ITEM_EDITOR_SESSION_SAVING:String = "gridItemEditorSessionSaving";
		
		public function DataGrid() {
			super();
		}
	}
}
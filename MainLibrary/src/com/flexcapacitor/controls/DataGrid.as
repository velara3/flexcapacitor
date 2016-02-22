



package com.flexcapacitor.controls
{
	import com.flexcapacitor.controls.supportClasses.GridItemRenderer;
	
	import mx.core.ClassFactory;
	
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
	 * This is an attempt at a better DataGrid. It uses the com.flexcapacitor.skins.DataGridSkin skin class
	 * and com.flexcapacitor.renderers.GridItemRenderer item renderer class. 
	 * This skin and item renderer are set in the defaults.css of the Flex Capacitor library (FCLibrary). 
	 * If you don't need text selection and text roll over color you can set the item renderer 
	 * back to the default spark.skins.spark::DefaultGridItemRenderer and it may save a few cycles. 
	 * With our grid item renderer it's only purpose is to allow setting the color of the text on hover and select. 
	 * <br/><br/>
	 * 
	 * This control also fixes the header top line showing when borderVisible is false. <br/>
	 * 
	 * It also adds a gridItemEditorSessionSaving event so you can check the value
	 * the user input before accepting it and cancel the saving if you so choose. 
	 * It is up to the grid item editor to dispatch this event. <br/>
	 * 
	 * The following are the original and additional styles, properties and events: <br/> <br/>
	 * 
	 * - columnSeparatorAlpha - Alpha of column separator. Default is 1. <br/>
	 * - columnSeparatorColor - Color of column separator. Default is #E6E6E6. <br/>
	 * - columnSeparatorWeight - Width of column separator. Default is 1px. <br/><br/>
	 * 
	 * - headerBackgroundColor - Background color of the header. Default is #D8D8D8. <br/>
	 * - headerRowSeparatorColor - Color of the separator between the header and the datagrid rows. Deafult is #696969. <br/>
	 * - headerRowSeparatorAlpha - Alpha of the header separator row. Default is 1. <br/><br/>
	 * 
	 * - rowSeparatorAlpha - Alpha of the row separator line. Default is 1. <br/>
	 * - rowSeparatorColor - Color of the row separator line. Default is #E6E6E6. <br/>
	 * - rowSeparatorWeight - Height of the row separator line. Default is 1. <br/><br/>
	 * 
	 * - showHeader - If enabled header is shown. Default is true. <br/><br/>
	 * 
	 * - selectionBorderColor - Color of the border around the selected or caret item. Default is #000000. <br/>
	 * - selectionBorderAlpha - Alpha of the border around the selected or caret item. Default is 1. <br/><br/>
	 * 
	 * - rollOverAlpha - Alpha of the background color on roll over. Default is 1. <br/>
	 * - rollOverColor - Color of the background on roll over. Default is <br/><br/>
	 * 
	 * - color - Color of the text. Default is #000000. <br/>
	 * - textSelectionColor - Color of the text when selected. Default is #000000. <br/>
	 * - textRollOverColor - Color of the text on roll over. Default is #000000. <br/><br/>
	 * 
	 * - backgroundColor - Background color of the DataGrid. Default is <br/>
	 * - backgroundAlpha - Background alpha of the DataGrid. Default is <br/><br/>
	 * 
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
	 *    columnSeparatorAlpha="1"
	 *    columnSeparatorColor="0xFF00FF"
	 *    columnSeparatorWeight="1"
	 *    headerBackgroundColor="1.0"
	 *    headerRowSeparatorColor="0xFFFFFF"
	 *    headerRowSeparatorAlpha="1"
	 *    rowSeparatorAlpha="1"
	 *    rowSeparatorColor="red"
	 *    rowSeparatorWeight="1"
	 *    selectionBorderColor="blue"
	 *    selectionBorderAlpha="1"
	 *    backgroundColor="0xFFFFFF"
	 *    backgroundAlpha="1"
	 *    useRollOver="true"
	 *    rollOverAlpha="1"
	 *    rollOverColor="1"
	 *    selectionColor="blue"
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
			
			itemRenderer = new ClassFactory(GridItemRenderer);
		}
	}
}
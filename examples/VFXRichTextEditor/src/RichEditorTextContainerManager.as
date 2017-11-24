package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.mx_internal;
	
	import spark.components.RichEditableText;
	import spark.components.supportClasses.RichEditableTextContainerManager;
	
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.elements.IConfiguration;
	
	
	use namespace mx_internal;
	use namespace tlf_internal;
	
	public class RichEditorTextContainerManager extends RichEditableTextContainerManager
	{
		public function RichEditorTextContainerManager(container:RichEditableText, configuration:IConfiguration =  null)
		{
			super(container, configuration);
		}
		
		/** @private
		 * Removes a <code>flash.display.DisplayObject</code> object from its parent. 
		 * The default implementation of this method, which may be overriden, removes the object
		 * from <code>container</code> if it is a direct child of the latter.
		 * 
		 * This method may be called even if the object is not a descendant of <code>parent</code>.
		 * Any implementation of this method must ensure that no action is taken in this case.
		 * 
		 * @param float the <code>flash.display.DisplayObject</code> object to remove 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 * 
		 * @see flash.display.DisplayObjectContainer
		 * @see flash.display.DisplayObject
		 * @see #container
		 * 
		 */	
		override tlf_internal function removeInlineGraphicElement(parent:DisplayObjectContainer, inlineGraphicElement:DisplayObject):void
		{
			if (parent && inlineGraphicElement.parent == parent)
				parent.removeChild(inlineGraphicElement);
		}
	}
}
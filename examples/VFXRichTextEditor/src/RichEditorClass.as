package
{
	import mx.core.mx_internal;
	
	import spark.components.RichEditableText;
	import spark.components.supportClasses.RichEditableTextContainerManager;
	
	import flashx.textLayout.tlf_internal;
	
	use namespace mx_internal;
	use namespace tlf_internal;
	
	public class RichEditorClass extends RichEditableText
	{
		public function RichEditorClass()
		{
			super();
		}
		
		/**
		 *  @private
		 */
		override mx_internal function createTextContainerManager():RichEditableTextContainerManager
		{
			return new RichEditorTextContainerManager(this);
		}
	}
}
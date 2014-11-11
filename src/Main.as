package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Main extends MovieClip
	{
		static private var MIN_AIR_VERSION :String = "15.0";
		static private var APP_URL         :String = "HelloWorld.air";
		static private var APP_ID          :String = "examples.html.HelloWorld";
		static private var PUB_ID          :String = "3299727775564FF8C4453846E5C8363BD602BFE8.1";
		
		private var airSWF       :Object; // This is the reference to the main class of air.swf 
		private var airSWFLoader :Loader;
		private var textField    :TextField;
		private var textFormat   :TextFormat;
		
		public function Main()
		{ 
			// Load air.SWF
			airSWFLoader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();  
			loaderContext.applicationDomain = ApplicationDomain.currentDomain; 
			
			airSWFLoader.contentLoaderInfo.addEventListener(Event.INIT, onInit); 
			airSWFLoader.load(new URLRequest("http://airdownload.adobe.com/air/browserapi/air.swf"),  
				loaderContext);
			
			textField = new TextField();
			textField.width = 415;
			textField.height = 380;
			textField.border = true;
			
			textFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 16;
			textFormat.color = 0xff0000;
			
			addChild(textField);
			//textField.text = "";
			textField.setTextFormat(textFormat);
		}
		
		private function onInit(e:Event):void  
		{ 
			airSWF = e.target.content;
			
			// It seems that we NEED to call getStatus() before doing anything else.
			var status :String = airSWF.getStatus();
			appendOutput("Status: " + status);
			
			try
            {
				airSWF.getApplicationVersion(APP_ID, PUB_ID, versionDetectCallback);
            }
            catch (e:Error)
            {
				// It's important we catch any exceptions here. It gives us a chance to
				// install the app, which will also force the AIR runtime to be installed
				// if it isn't already.
				appendOutput("AIR not installed: " + e);
				installApp();
            }
			
			// Add a click handler to allow the user to launch the app.
			appendOutput("Click anywhere on the screen to launch the application.");		
			stage.addEventListener(MouseEvent.CLICK, launchApplication);
		}
		
		private function launchApplication(e:MouseEvent):void
		{
			appendOutput("launchApplication");
			
			var arguments:Array = ["launchFromBrowser"]; // Optional 
			airSWF.launchApplication(APP_ID, PUB_ID, arguments);
		}
		
		private function versionDetectCallback(version:String):void 
		{
			if (version == null)
			{ 
				installApp();
			} 
			else 
			{
				appendOutput("Version " + version + " installed.");
			} 
		}
		
		private function installApp():void
		{
			airSWF.installApplication(APP_URL, MIN_AIR_VERSION, [] );
		}
		
		private function appendOutput(str:String):void
		{
			textField.appendText(str + "\n");
			textField.setTextFormat(textFormat);
			trace(str);
		}
	}
}
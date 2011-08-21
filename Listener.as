package {

	import flash.external.*;

    public class Listener extends Object {

        private var m_metaData : String = null;
        private var m_handlerMetaData : String = null;


        public function setHandlerMetaData(handlerName : String) : void {
            m_handlerMetaData = handlerName;
        }

        public function getMetaData() : String {
            return m_metaData;
        }

        public function onMetaData(info : Object) : void {
            if (m_handlerMetaData && info["StreamTitle"]) {
                m_metaData = info["StreamTitle"];
                ExternalInterface.call(m_handlerMetaData, info["StreamTitle"]);
            }
			//ExternalInterface.call("window.console.log", "[MD1] " + info["StreamTitle"]);
        }

    }

}

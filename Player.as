package {

	import flash.display.Sprite;
	import flash.external.*;


	public class Player extends Sprite {

        private var m_engineRtmp : EngineAbstract = null;
        private var m_engineHttp : EngineAbstract = null;
        private var m_engineCurrent : EngineAbstract = null;
        private var m_listener : Listener = null;


        public function Player() {
            m_engineRtmp = new EngineRtmp();
            m_engineHttp = new EngineHttp();
            m_listener = new Listener();

            ExternalInterface.addCallback("play", this.play);
            ExternalInterface.addCallback("stop", this.stop);
            ExternalInterface.addCallback("setVolume", this.setVolume);
            ExternalInterface.addCallback("getVolume", this.getVolume);
            ExternalInterface.addCallback("mute", this.mute);
            ExternalInterface.addCallback("getMetaData", this.getMetaData);
            ExternalInterface.addCallback("setHandlerMetaData", this.setHandlerMetaData);
        }

        public function play(url : String, instance : String) : void {
            stop();
            if ("rtmp" == url.substr(0, 4)) {
                m_engineCurrent = m_engineRtmp;
            }
            else {
                m_engineCurrent = m_engineHttp;
            }
            m_engineCurrent.setListener(m_listener);
            m_engineCurrent.play(url, instance);
        }

        public function stop() : void {
            if (m_engineCurrent) {
                m_engineCurrent.stop();
            }
        }

        public function setVolume(vol : Number) : void {
			if (vol < 0) vol = 0;
			if (vol > 1) vol = 1;
            m_engineCurrent.setVolume(vol);
        }
        public function getVolume() : Number {
            return m_engineCurrent.getVolume();
        }

        public function mute(m : Boolean) : void {
            m_engineCurrent.mute(m);
        }

        public function getMetaData() : String {
            return m_listener.getMetaData();
        }

        public function setHandlerMetaData(handlerName : String) : void {
            m_listener.setHandlerMetaData(handlerName);
        }

		public static function log(msg : String) : void {
			ExternalInterface.call("window.console.log", "[LOG] " + msg);
		}

    }

}

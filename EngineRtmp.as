package {

	import flash.net.*;
	import flash.events.NetStatusEvent;
    import flash.media.SoundTransform;

	import flash.external.*;
    import flash.utils.setTimeout


    public class EngineRtmp extends EngineAbstract {

        private var m_nc : NetConnection = null;
        private var m_netStream : NetStream = null;

        private var m_url : String = null;
        private var m_instance : String = null;
		private var m_client : Object = new Object();


        public function EngineRtmp() {
			this.m_client.onMetaData = onMetaData;
        }

        public override function play(url : String, instance : String) : void {
            m_url = url;
            m_instance = instance;
            m_nc = new NetConnection();
            m_nc.addEventListener(NetStatusEvent.NET_STATUS, ncEvent);
            m_nc.connect(m_url);
        }

        public override function stop() : void {
			m_playing = false;
			if (m_netStream != null) {
				m_netStream.close();
				m_netStream = null;
			}
			if (m_nc != null) {
				if (m_nc.connected) {
					m_nc.close();
				}
				m_nc = null;
			}
        }

        public function reconnect(wait : Boolean = false) : void {
            stop();
            if (wait) {
                setTimeout(function() : void { play(m_url, m_instance); }, 1000);
            }
            else {
                play(m_url, m_instance);
            }
        }

        public override function setVolume(vol : Number) : void {
            m_volume = vol;
            if (!m_playing || null == m_netStream) return;
            var sound : SoundTransform = m_netStream.soundTransform;
            sound.volume = vol;
            m_netStream.soundTransform = sound;
        }

        public override function getVolume() : Number {
            if (!m_playing || null == m_netStream) return 0;
            var sound : SoundTransform = m_netStream.soundTransform;
            return sound.volume;
        }



        public function ncEvent(event : NetStatusEvent) : void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    playStream();
                    break;
				case "NetConnection.Connect.Failed":
					reconnect(true);
					break;
				case "NetConnection.Connect.Closed":
					if (m_playing && m_nc != null) {
						// connection closed by server
						reconnect(true);
					}
					break;
				default:
					trace("unexpected ncEvent! " + event.info.code);
					break;
            }
        }

        private function playStream() : void {
            try {
                m_nc.call("setStreamType", null, "shoutcast");
                m_netStream = new NetStream(m_nc);
                m_netStream.client = m_client;
                m_netStream.bufferTime = 2;
                m_netStream.play(m_instance);
                m_playing = true;
                setVolume(m_volume);
            }
            catch(errObject : Error) {
                trace(errObject);
            }
        }

		private function onMetaData(info : Object) : void {
            if (m_listener) {
                m_listener.onMetaData(info);
            }
        }
    }

}

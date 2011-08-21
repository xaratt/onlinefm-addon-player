package {

    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.media.SoundLoaderContext;
    import flash.net.URLRequest;

	import flash.external.*;
    import flash.events.*;


    public class EngineHttp extends EngineAbstract {

        private var m_url : String = null;

        private var m_sound : Sound = null;
        private var m_channel : SoundChannel = null;
        private var m_context : SoundLoaderContext = new SoundLoaderContext(8000, true);


        public function EngineHttp() {
            m_context.checkPolicyFile = false;
        }

        public override function play(url : String, instance : String) : void {
            m_url = url;
            m_sound = new Sound();
            m_sound.load(new URLRequest(m_url), m_context);
            m_channel = m_sound.play();
            m_playing = Boolean(m_channel);
            setVolume(m_volume);
        }

        public override function stop() : void {
            if (!m_playing || null == m_channel) return;
            m_channel.stop();
            m_sound.close();
            m_playing = false;
        }

        public override function setVolume(vol : Number) : void {
            m_volume = vol;
            if (!m_playing || null == m_channel) return;
            var transform : SoundTransform = m_channel.soundTransform;
            transform.volume = vol;
            m_channel.soundTransform = transform;
        }

        public function _getVolume() : Number {
            if (!m_playing || null == m_channel) return 0;
            var transform : SoundTransform = m_channel.soundTransform;
            return transform.volume;
        }

    }

}

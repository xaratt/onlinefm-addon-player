package {

    public class EngineAbstract {

		protected var m_volume : Number = 0.5;
		protected var m_mute : Boolean = false;
        protected var m_listener : Object = null;
        protected var m_playing : Boolean = false;


        public function play(url : String, instance : String) : void {}

        public function stop() : void {}

        public function setVolume(vol : Number) : void {}

        public function getVolume() : Number {
            return 0;
        }

        public function mute(mute : Boolean) : void {
            m_mute = mute;
            if (m_mute) {
                var volume : Number = getVolume();
                setVolume(0);
                m_volume = volume;
            }
            else {
                setVolume(m_volume);
            }
        }

        public function setListener(listener : Object) : void {
            m_listener = listener;
        }

        public function isPlaying() : Boolean {
            return m_playing;
        }

    }

}

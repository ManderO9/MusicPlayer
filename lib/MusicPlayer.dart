import 'package:audioplayers/audioplayers.dart';

class MusicPlayer{
  static AudioPlayer? player;

  static init(){
    player =  AudioPlayer();
  }

  static playSong(String path){
    player?.play(DeviceFileSource(path));
  }

  static pauseCurrentSong(){
    player?.pause();
  }

  static stopPlaying(){
    player?.stop();
  }

}
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:podcast_app/api/soundplayer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio = '/sdcard/Download/recording.wav';

class SoundRecorder{
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async{
    _audioRecorder = FlutterSoundRecorder();

    Directory directory = Directory(path.dirname(pathToSaveAudio));
    if(!directory.existsSync()){
      directory.createSync();
    }

    final status = await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      throw RecordingPermissionException('Mic permission denied');
    }
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    await _audioRecorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
      device: AudioDevice.speaker
    );
    _isRecorderInitialised = true;
  }

  void dispose() {
    if(!_isRecorderInitialised) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async{
    if(!_isRecorderInitialised) return;

    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async{
    if(!_isRecorderInitialised) return;

    await _audioRecorder!.stopRecorder();
  }

  Future toggle() async{
    if(_audioRecorder!.isStopped){
      await _record();
    }else{
      await _stop();
    }
  }
}
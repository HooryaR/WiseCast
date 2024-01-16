
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/api/soundplayer.dart';
import 'package:podcast_app/api/soundrecorder.dart';
import 'package:podcast_app/widget/timerwidget.dart';

class StudioPage extends StatefulWidget{
  const StudioPage({Key? key}) : super(key: key);

  @override
  _StudioPageState createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage>{
  final timerController = TimerController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }
  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFA2B38B),
        body: Column(
            children: <Widget>[
              Container(
                height: 60,
                width: 500,
                color: Colors.lightBlueAccent,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: const Text(
                  'STUDIO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 100, 20, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildPlayer(),
                    SizedBox(height: 16),
                    buildStart(),
                    SizedBox(height: 16),
                    buildPlay(),
                  ],
                ),
              )
            ],
          ),
    );
  }

  Widget buildStart(){
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.redAccent : Colors.lightBlueAccent;
    final onPrimary = isRecording ? Colors.white : Colors.white;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(200,50),
          primary: primary,
          onPrimary: onPrimary
      ),
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
      onPressed: () async {
        await recorder.toggle();
        final isRecording = recorder.isRecording;
        setState(() {});
        if(isRecording){
          timerController.startTimer();
        }else{
          timerController.stopTimer();
        }
      },
    );
  }

  Widget buildPlayer(){
    final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder.isRecording;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.amber,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, size: 32, color: Colors.white,),
              TimerWidget(controller: timerController),
              SizedBox(height: 8),
              Text(text, style: TextStyle(
                color: Colors.white
              ),),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildPlay(){
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'Stop Recording' : 'Play Recording';

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(200,50),
          primary: Colors.lightBlueAccent,
          onPrimary: Colors.white
      ), icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ), onPressed: () async {
        await player.togglePlaying(whenFinished: () => setState(() {}));
        setState(() {});
    },
    );
  }
}
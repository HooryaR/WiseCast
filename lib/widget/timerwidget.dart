import 'dart:async';

import 'package:flutter/material.dart';

class TimerController extends ValueNotifier<bool>{
    TimerController({bool isPlaying = false}) : super(isPlaying);

    void startTimer() => value = true;
    void stopTimer() => value = false;
}

class TimerWidget extends StatefulWidget{
  final TimerController controller;

  const TimerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState(){
    super.initState();
    widget.controller.addListener(() {
      if(widget.controller.value){
        startTimer();
      }else{
        stopTimer();
      }
    });
  }

  void reset() => setState(() => duration = Duration());

  void addTime(){
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if(seconds<0){
        timer?.cancel();
      }else{
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_)=>addTime());
  }

  void stopTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Center(
    child: buildTime());

  Widget buildTime(){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: minutes),
        const SizedBox(width: 2),
        const Text(':', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 40
        ),),
        const SizedBox(width: 2),
        buildTimeCard(time: seconds),
      ],
    );
  }

  Widget buildTimeCard({required String time}) =>
      Container(
        child: Text(
          time,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 40
          ),
        ),
      );
}

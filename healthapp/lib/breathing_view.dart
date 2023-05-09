import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/breathing_bloc.dart';

class BreathingAudioView extends StatefulWidget {
  @override
  _BreathingAudioViewState createState() => _BreathingAudioViewState();
}

class _BreathingAudioViewState extends State<BreathingAudioView> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;
  Duration duration = Duration();
  Duration position = Duration();

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        this.duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        this.position = position;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BreathingBloc, BreathingState>(
        builder: (context, state) {
          final audioUri = state.audioUri;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Take a deep breath', style: TextStyle(fontSize: 35)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await audioPlayer.play(UrlSource(audioUri.toString()));
                    },
                    icon: Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () async {
                      await audioPlayer.pause();
                    },
                    icon: Icon(Icons.pause),
                  ),
                  IconButton(
                    onPressed: () async {
                      await audioPlayer.stop();
                    },
                    icon: Icon(Icons.stop),
                  ),
                ],
              ),
              Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  });
                },
              ),
              Text('Audio Position: ${position.toString()}'),
              Text('Audio Duration: ${duration.toString()}'),
              Text('Audio State: ${playerState.toString()}'),
            ],
          );
        },
      ),
    );
  }
}

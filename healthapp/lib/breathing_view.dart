import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/breathing_bloc.dart';

class AudioView extends StatefulWidget {
  @override
  _AudioViewState createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
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
    return BlocBuilder<BreathingBloc, BreathingState>(
      builder: (context, state) {
        final audioUri = state.audioUri;
        return Scaffold(
          appBar: AppBar(
            title: Text(state.category ?? ""),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Text(
                'Take a deep breath',
                style: TextStyle(
                  fontSize: 35,
                ),
              ), */
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      audioPlayer.seek(Duration(seconds: value.toInt()));
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}"),
                    Text(
                        "-${(duration - position).inMinutes}:${((duration - position).inSeconds % 60).toString().padLeft(2, '0')}"),
                  ],
                ),
              ),
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
                    icon: Icon(Icons.restart_alt_outlined),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

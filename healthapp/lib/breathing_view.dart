import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/breathing_bloc.dart';

const Color transparentGreyBackgroundColor = Color.fromARGB(170, 29, 28, 28);

class AudioView extends StatefulWidget {
  @override
  _AudioViewState createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;
  Duration duration = Duration();
  Duration position = Duration();
  String _imgUrl = "";

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          playerState = state;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          this.duration = duration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          this.position = position;
        });
      }
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
      if (state.status == BreathingStatus.success) {
        switch (state.category!.toLowerCase()) {
          case ("relax"):
            _imgUrl = "assets/images/hammoc.png";
            break;
          case ("focus"):
            _imgUrl = "assets/images/waterfall.png";
            break;
          case ("energize"):
            _imgUrl = "assets/images/mountain_range.png";
            break;
          default:
            _imgUrl = "assets/images/fireplace.png";
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "",
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(
                  _imgUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Text(
                  'Take a deep breath',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ), */
                SizedBox(height: 500),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  color: transparentGreyBackgroundColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey[700],
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                                "-${(duration - position).inMinutes}:${((duration - position).inSeconds % 60).toString().padLeft(2, '0')}",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (playerState == null) {
                              await audioPlayer
                                  .play(UrlSource(audioUri.toString()));
                            } else if (playerState == PlayerState.paused) {
                              await audioPlayer.resume();
                            } else {
                              await audioPlayer.pause();
                            }
                          },
                          icon: Icon(
                            playerState == PlayerState.paused ||
                                    playerState == null
                                ? Icons.play_arrow
                                : Icons.pause,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}

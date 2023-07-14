import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class showingVideo extends StatefulWidget {
  String videoTitle;
  String videoLink;
  showingVideo({Key? key, required this.videoTitle, required this.videoLink})
      : super(key: key);

  @override
  State<showingVideo> createState() => _showingVideoState();
}

class _showingVideoState extends State<showingVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Videos"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.videoTitle),
              ),
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: widget.videoLink,
                ),
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                ],
                showVideoProgressIndicator: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

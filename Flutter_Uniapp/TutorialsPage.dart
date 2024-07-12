import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoList(),
    );
  }
}

class VideoList extends StatelessWidget {
  final List<String> videoUrls = [
    'https://syfer001testing.000webhostapp.com/alphaweblink/savefile/media_20240625_144136_2408919964349168771.mp4',
    'https://syfer001testing.000webhostapp.com/alphaweblink/savefile/media_20240625_144136_2408919964349168771.mp4',
    'https://syfer001testing.000webhostapp.com/alphaweblink/savefile/media_20240625_144136_2408919964349168771.mp4',
    'https://syfer001testing.000webhostapp.com/alphaweblink/savefile/media_20240625_144136_2408919964349168771.mp4',
    // Add more video URLs here
  ];
  final List<String> videoNames = [
    'USA',
    'UK',
    'Canada',
    'Australia',
    // Add corresponding video names here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videoNames[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerPage(
                    videoUrl: videoUrls[index],
                    videoName: videoNames[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String videoName;

  VideoPlayerPage({required this.videoUrl, required this.videoName});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  void seek(double offset) {
    final newPosition = _videoPlayerController.value.position + Duration(seconds: offset.toInt());
    if (newPosition.inSeconds < 0) {
      _videoPlayerController.seekTo(Duration(seconds: 0));
    } else {
      _videoPlayerController.seekTo(newPosition);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = MediaQuery.of(context).size.width / 2;

          if (tapPosition > screenWidth / 2) {
            // Right side, seek forward
            seek(10);
          } else {
            // Left side, seek backward
            seek(-10);
          }
        },
        child: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}

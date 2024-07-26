import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Playlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'name': 'Big Buck Bunny',
      'thumbnail': 'https://peach.blender.org/wp-content/uploads/title_anouncement.jpg?x11217'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'name': 'Elephants Dream',
      'thumbnail': 'https://orange.blender.org/wp-content/themes/orange/images/common/elephants-dream-poster-iso.jpg?x11217'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'name': 'For Bigger Blazes',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'name': 'For Bigger Escapes',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'name': 'For Bigger Fun',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'name': 'For Bigger Joyrides',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'name': 'For Bigger Meltdowns',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'name': 'Sintel',
      'thumbnail': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Sintel_poster.jpg/800px-Sintel_poster.jpg'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'name': 'Subaru Outback On Street And Dirt',
      'thumbnail': 'https://via.placeholder.com/150'
    },
    {
      'url': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'name': 'Tears of Steel',
      'thumbnail': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Tears_of_Steel_poster.jpg/800px-Tears_of_Steel_poster.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Playlist',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: Image.network(
                  videos[index]['thumbnail']!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  videos[index]['name']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoUrl: videos[index]['url']!,
                        videoName: videos[index]['name']!,
                        videoList: videos,
                        currentIndex: index,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoName;
  final List<Map<String, String>> videoList;
  final int currentIndex;

  VideoPlayerScreen({
    required this.videoUrl,
    required this.videoName,
    required this.videoList,
    required this.currentIndex,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeAndPlay(widget.videoUrl);
  }

  void _initializeAndPlay(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        if (_controller.value.isInitialized) {
          _controller.play();
          _isPlaying = true;
        } else {
          setState(() {
            _isError = true;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _seekToRelativePosition(Duration position) {
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition + position;
    _controller.seekTo(targetPosition);
  }

  void _playNext() {
    if (widget.currentIndex < widget.videoList.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: widget.videoList[widget.currentIndex + 1]['url']!,
            videoName: widget.videoList[widget.currentIndex + 1]['name']!,
            videoList: widget.videoList,
            currentIndex: widget.currentIndex + 1,
          ),
        ),
      );
    }
  }

  void _playPrevious() {
    if (widget.currentIndex > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: widget.videoList[widget.currentIndex - 1]['url']!,
            videoName: widget.videoList[widget.currentIndex - 1]['name']!,
            videoList: widget.videoList,
            currentIndex: widget.currentIndex - 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _isError
            ? Text('Failed to load video')
            : _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onDoubleTap: () => _seekToRelativePosition(Duration(seconds: 10)),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.lightBlue,
                backgroundColor: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: _playPrevious,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isPlaying ? _controller.pause() : _controller.play();
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: _playNext,
                ),
              ],
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

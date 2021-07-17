import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/widget/music_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicMain(),
    );
  }
}

class MusicMain extends StatefulWidget {
  const MusicMain({Key? key}) : super(key: key);

  @override
  _MusicMainState createState() => _MusicMainState();
}

class _MusicMainState extends State<MusicMain> {
  List musicList = [
    {
      'title': "Hazy After Hours",
      'singer': "Alejandro Magaña",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3",
      'coverUrl':
          "https://cdn.pixabay.com/photo/2016/03/23/12/53/clock-1274699_960_720.jpg",
    },
    {
      'title': "A Very Happy Christmas",
      'singer': "Michael Ramir C.",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-a-very-happy-christmas-897.mp3",
      'coverUrl':
          "https://cdn.pixabay.com/photo/2010/12/13/10/34/christmas-2918_960_720.jpg",
    },
    {
      'title': "Valley Sunset",
      'singer': "Alejandro Magaña",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-valley-sunset-127.mp3",
      'coverUrl':
          "https://cdn.pixabay.com/photo/2016/11/08/19/08/sun-rise-1809198_960_720.jpg",
    },
  ];

  String currentTitle = "";
  String currentCover = "";
  String currentUrl = "";
  String currentSinger = "";
  IconData curentIcon = Icons.play_arrow;
  Duration duration = Duration();
  Duration position = Duration();

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;

  void playMusic(String url) async {
    if (isPlaying && currentUrl != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentUrl = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          curentIcon = Icons.pause;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Music App",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: musicList.length,
                    itemBuilder: (context, idx) => GestureDetector(
                          onTap: () {
                            playMusic(musicList[idx]['url']);
                            setState(() {
                              currentTitle = musicList[idx]['title'];
                              currentCover = musicList[idx]['coverUrl'];
                              currentSinger = musicList[idx]['singer'];
                            });
                          },
                          child: MusicCard(
                              musicList[idx]['title'],
                              musicList[idx]['singer'],
                              musicList[idx]['coverUrl']),
                        ))),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Color(0x5521212121), blurRadius: 8.0)
              ]),
              child: Column(
                children: [
                  Slider.adaptive(
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {}),
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 12.0, right: 12.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: DecorationImage(
                                image: NetworkImage(currentCover),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              currentSinger,
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          iconSize: 42.0,
                          onPressed: () {
                            setState(() async {
                              if (isPlaying) {
                                audioPlayer.stop();
                                setState(() {
                                  curentIcon = Icons.play_arrow;
                                  isPlaying = false;
                                });
                              } else {
                                await audioPlayer.seek(position);
                                setState(() {
                                  curentIcon = Icons.pause;
                                  isPlaying = true;
                                });
                              }
                            });
                          },
                          icon: Icon(curentIcon))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}

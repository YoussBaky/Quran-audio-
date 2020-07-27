import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_musik/music.dart';
import 'package:flutter_simple_musik/app.dart';

// A function that converts a response body into a List<Music>.
List<Music> parseMusic(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Music>((json) => Music.fromJson(json)).toList();
}

Future<List<Music>> fetchMusic() async {
  final response = await rootBundle.loadString("lib/data/arabic_frensh.json");
  return compute(parseMusic, response);
}

Future<void> main() async {
  runApp(MyApp());
  await fetchMusic();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Le Saint Coran'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Music>>(
          future: fetchMusic(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? SourateList(sourates: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// class SourateList extends StatefulWidget {
//   final List<Music> sourates;
//   SourateList({Key key, this.sourates}) : super(key: key);

//   @override
//   _SourateListState createState() => _SourateListState();
// }

// enum ActionType {
//   play,
//   pause,
//   rewind,
//   forward,
// }

// enum PlayerState {
//   playing,
//   stopped,
//   paused,
// }

// class _SourateListState extends State<SourateList> {
//   AudioPlayer audioPlayer;

//   int actualAudio;
//   Duration progress = Duration(seconds: 0);
//   Duration time = Duration(seconds: 0);
//   PlayerState statut = PlayerState.stopped;

//   void _intAudioplayer() {
//     audioPlayer = AudioPlayer();
//     audioPlayer.onAudioPositionChanged.listen((event) {
//       setState(() {
//         progress = event;
//       });
//     });

//     audioPlayer.onPlayerCompletion.listen((event) {
//       setState(() {
//         forward();
//       });
//     });

//     audioPlayer.onPlayerStateChanged.listen((state) {
//       if (state == AudioPlayerState.PLAYING) {
//         audioPlayer.onDurationChanged.listen((dure) {
//           time = dure;
//         });
//       } else if (state == AudioPlayerState.STOPPED) {
//         statut = PlayerState.stopped;
//       }
//     }, onError: (error) {
//       print(error);
//       setState(() {
//         statut = PlayerState.stopped;
//         time = Duration(seconds: 0);
//         progress = Duration(seconds: 0);
//       });
//     });
//   }

//   Future play() async {
//     if (statut == PlayerState.paused)
//       audioPlayer.resume();
//     else
//       await audioPlayer.play(widget.sourates[actualAudio].urlSong);
//     setState(() {
//       statut = PlayerState.playing;
//     });
//   }

//   Future pause() async {
//     await audioPlayer.pause();
//     setState(() {
//       statut = PlayerState.paused;
//     });
//   }

//   void forward() {
//     if (actualAudio < widget.sourates.length - 1)
//       actualAudio++;
//     else
//       actualAudio = 0;

//     audioPlayer.stop();
//     _intAudioplayer();
//     play();
//   }

//   void rewind() {
//     if (progress > Duration(seconds: 3))
//       audioPlayer.seek(Duration(seconds: 0));
//     else if (actualAudio > 0)
//       actualAudio--;
//     else
//       actualAudio = widget.sourates.length - 1;

//     audioPlayer.stop();
//     _intAudioplayer();
//     play();
//   }

//   IconButton button(IconData icon, double size, ActionType action) {
//     return IconButton(
//       icon: Icon(icon),
//       onPressed: () {
//         switch (action) {
//           case ActionType.play:
//             play();
//             break;
//           case ActionType.pause:
//             pause();
//             break;
//           case ActionType.rewind:
//             rewind();
//             break;
//           case ActionType.forward:
//             forward();
//             break;
//         }
//       },
//     );
//   }

//   Text textFormate(String text, double scale) {
//     return Text(
//       text,
//       textScaleFactor: scale,
//       textAlign: TextAlign.center,
//       style: TextStyle(),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     actualAudio = 0;
//     _intAudioplayer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         textFormate(widget.sourates[actualAudio].title, 1.5),
//         Card(
//           elevation: 9.0,
//           child: Container(
//             width: MediaQuery.of(context).size.height / 2.9,
//             height: MediaQuery.of(context).size.width / 1.5,
//             child: Image.asset(
//               widget.sourates[0].imagePath,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         //textFormate(widget.sourates[actualAudio].sourateNumber, 1.0),
//         Column(
//           children: <Widget>[
//             Slider(
//               value: progress.inSeconds.toDouble(),
//               activeColor: Colors.green,
//               inactiveColor: Colors.blueGrey,
//               max: time.inSeconds.toDouble(),
//               onChanged: (double value) {
//                 setState(() {
//                   progress = Duration(seconds: value.toInt());
//                   audioPlayer.seek(progress);
//                 });
//               },
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(left: 20.0, right: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       textFormate(progress.toString().split('.').first, 0.8),
//                       //textFormate(time.toString().split('.').first, 0.8),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       button(Icons.fast_rewind, 30.0, ActionType.rewind),
//                       button(
//                         (statut == PlayerState.playing)
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                         30.0,
//                         (statut == PlayerState.playing)
//                             ? ActionType.pause
//                             : ActionType.play,
//                       ),
//                       button(Icons.fast_forward, 30.0, ActionType.forward),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 20.0, right: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       //textFormate(progress.toString().split('.').first, 0.8),
//                       textFormate(time.toString().split('.').first, 0.8),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ));
//   }
// }

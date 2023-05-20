import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicplayer/Models/SongModel.dart';
import 'package:musicplayer/MusicPlayer.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicPlayer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'MusicPlayer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final Directory musicDir = Directory("/storage/emulated/0/downloads");

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SongModel> songs = List.empty(growable: true);
  MusicPlayer musicPlayer = MusicPlayer();
  IconData playPauseIcon = Icons.play_arrow;
  bool musicPlaying = false;
  int currentPlayingSongIndex = 0;
  MethodChannel methodChannel = const MethodChannel("messages");

  void initMethodChannel() {
    // Listen for events coming from the android side
    methodChannel.setMethodCallHandler((call) async {
      // If we pressed next in the notification
      if (call.method == "Next") {
        // Play next song
        nextSong();
      }
      // If we pressed previous in the notification
      else if (call.method == "Previous") {
        // Play the previous song
        previousSong();
      }
      // If we pressed the play/pause button in the notification
      else if (call.method == "PlayPause") {
        // Play/stop the music accordingly
        playStopMusic();
      }
    });
  }

  Future<void> startService() async {
    await methodChannel.invokeMethod("StartService");
  }

  Future<void> stopService() async {
    await methodChannel.invokeMethod("StopService");
  }

  Future<void> loadSongs() async {
    // Folder to start searching for songs from
    var dir = Directory("/storage/emulated/0/Download/");

    // Get all children items that end with mp3
    var children = await dir
        .list(recursive: true, followLinks: false)
        .where((item) => item.path.endsWith(".mp3"))
        .toList();

    // Delete all existing songs
    songs.clear();

    // For each file item
    for (var element in children) {
      // Get the name of the file
      var name = element.path.split("/").last;

      // Create a new song and add it to the list of songs
      songs.add(SongModel(name, element.path));
    }

    setState(() {});
  }

  void playSong(int index) {
    setState(() {
      // Set icon to pause
      playPauseIcon = Icons.pause;
    });

    // Set index of current song to play
    currentPlayingSongIndex = index;

    // Set music playing flag
    musicPlaying = true;

    // Play the requested song
    // TODO: maybe have a check if we are already playing another song or not
    musicPlayer.playSong(songs[index].path);
  }

  void pauseSong() {
    setState(() {
      // Set icon to play
      playPauseIcon = Icons.play_arrow;
    });

    // Set music playing flag
    musicPlaying = false;

    // Pause current song
    musicPlayer.pauseCurrentSong();
  }

  void playStopMusic() {
    // If we are playing music
    if (musicPlaying) {
      pauseSong();
      // Otherwise, if we are not playing music
    } else {
      playSong(currentPlayingSongIndex);
    }
  }

  void nextSong() {
    playSong((currentPlayingSongIndex + 1) % songs.length);
  }

  void previousSong() {
    playSong((currentPlayingSongIndex - 1) % songs.length);
  }

  @override
  void initState() {
    super.initState();

    // Load song from file
    loadSongs();

    // Initialize method channel between android and flutter
    initMethodChannel();

    // Start the music service
    startService();
  }

  @override
  void dispose(){
    stopService();
    super.dispose();
  }

  Widget getBody() {
    if (songs.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(20), child: Text("loading..."));
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 140),
        child: ListView.builder(
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                playSong(i);
              },
              child: Card(
                color: Colors.white70,
                margin: const EdgeInsets.all(5),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(songs[i].name)),
              ),
            );
          },
          itemCount: songs.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // Songs list
      body: getBody(),

      // Control buttons
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(songs.isEmpty
                      ? ""
                      : songs[currentPlayingSongIndex].name)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        previousSong();
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.navigate_before))),
                  ElevatedButton(
                      onPressed: () {
                        playStopMusic();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(playPauseIcon))),
                  ElevatedButton(
                      onPressed: () {
                        nextSong();
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.navigate_next))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

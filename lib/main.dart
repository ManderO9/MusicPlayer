import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicplayer/DataAccess.dart';
import 'package:musicplayer/FavorisPage.dart';
import 'package:musicplayer/Models/SongModel.dart';
import 'package:musicplayer/MusicPlayer.dart';
import 'package:flutter/services.dart';

import 'DownloadPage.dart';

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

    // Get the favorite songs
    var favorites = await DataAccess.GetFavories();

    // For each file item
    for (var element in children) {
      // Get the name of the file
      var name = element.path.split("/").last;

      // Whether this song is a favorite
      bool isFavorite = false;

      // Check if this song is a favorite
      if(favorites.any((fav) => fav.path ==element.path )) {
        isFavorite = true;
      }

      // Create a new song and add it to the list of songs
      songs.add(SongModel(name, element.path, isFavorite));
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
    MusicPlayer.playSong(songs[index].path);
  }

  void pauseSong() {
    setState(() {
      // Set icon to play
      playPauseIcon = Icons.play_arrow;
    });

    // Set music playing flag
    musicPlaying = false;

    // Pause current song
    MusicPlayer.pauseCurrentSong();
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

    // Initialize music player service
    MusicPlayer.init();
  }

  @override
  void dispose() {
    stopService();
    MusicPlayer.stopPlaying();
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
        actions: [
          IconButton(
              onPressed: () async {
                // Reload songs
                await loadSongs();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavorisPage()));
              },
              icon: const Icon(Icons.heart_broken)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DownloadPage()));
              },
              icon: const Icon(Icons.download))
        ],
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
                  GestureDetector(
                    onTap: () {
                      if (songs.isNotEmpty) {
                        setState(() {
                          songs[currentPlayingSongIndex].isFavorite =
                              !songs[currentPlayingSongIndex].isFavorite;
                          if (songs[currentPlayingSongIndex].isFavorite) {
                            DataAccess.AddFavorie(
                                songs[currentPlayingSongIndex]);
                          } else {
                            DataAccess.RemoveFavorie(
                                songs[currentPlayingSongIndex]);
                          }
                        });
                      }
                    },
                    child: Icon(
                      Icons.heart_broken,
                      color: (songs.isEmpty ||
                              !songs[currentPlayingSongIndex].isFavorite)
                          ? Colors.black12
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

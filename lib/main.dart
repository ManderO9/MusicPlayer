import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicplayer/Models/SongModel.dart';

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

  Future<void> loadSongs() async {
    // Folder to start searching for songs from
    var dir = Directory("/storage/emulated/0/Download/");

    // Get all children items that end with mp3
    var children = dir
        .listSync(recursive: true, followLinks: false)
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

  @override
  void initState() {
    loadSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white70,
            margin: const EdgeInsets.all(5),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(songs[index].name)),
          );
        },
        itemCount: songs.length,
      ),
    );
  }
}

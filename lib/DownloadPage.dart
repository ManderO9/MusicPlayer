import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicplayer/Models/SongModel.dart';
import 'package:musicplayer/MusicPlayer.dart';
import 'package:flutter/services.dart';


class DownloadPage extends StatefulWidget {
  DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      // Songs list
      body: const Text("downloads page"),
    );
  }
}

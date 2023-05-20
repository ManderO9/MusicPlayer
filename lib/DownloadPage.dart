import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Models/SongModel.dart';
import 'package:musicplayer/MusicPlayer.dart';
import 'package:flutter/services.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String downloadsDirectory = "/storage/emulated/0/Download";

  Future<String> downloadFile(String url) async {
    // Create Http client
    var httpClient = HttpClient();
    // Send request and get response
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    // Get response body
    var bytes = await consolidateHttpClientResponseBytes(response);

    // Create a file to store new song in
    var filePath =
        "$downloadsDirectory/${DateTime.now().microsecondsSinceEpoch}.mp3";
    File file = File(filePath);
    var createdFile = await file.create();

    // Store the song
    await createdFile.writeAsBytes(bytes);

    // Return the path to the song
    return file.path;
  }

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      // Songs list
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: textController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var url = textController.value.text;
                    var filePath = await downloadFile(url);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("File downloaded\nPath: $filePath")));
                  },
                  child: const Text("Download"))
            ],
          ),
        ),
      ),
    );
  }
}

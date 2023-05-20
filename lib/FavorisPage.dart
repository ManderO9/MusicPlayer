import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicplayer/DataAccess.dart';
import 'package:musicplayer/Models/SongModel.dart';
import 'package:musicplayer/MusicPlayer.dart';
import 'package:flutter/services.dart';

class FavorisPage extends StatefulWidget {
  FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  List<SongModel> FavorisSongs = List.empty(growable: true);

  Future<void> loadSongs() async {
    FavorisSongs.clear();
    FavorisSongs.addAll(await DataAccess.GetFavories());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Load songs from database
    loadSongs();
  }

  Widget getBody() {
    if (FavorisSongs.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(20), child: Text("loading..."));
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView.builder(
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                MusicPlayer.playSong(FavorisSongs[i].path);
              },
              child: GestureDetector(
                onLongPress: ()async {
                  await DataAccess.RemoveFavorie(FavorisSongs[i]);
                  setState(() {
                    FavorisSongs.remove(FavorisSongs[i]);
                  });
                },
                child: Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.all(5),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(FavorisSongs[i].name)),
                ),
              ),
            );
          },
          itemCount: FavorisSongs.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris"),
      ),
      // Songs list
      body: getBody(),
    );
  }
}

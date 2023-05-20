
import 'Models/SongModel.dart';

class DataAccess{
  // Add favorites and saving them to the database

  static final List<SongModel> _Favories= List.empty(growable: true);

  static Future<List<SongModel>> GetFavories()async {
    return _Favories;
  }

  static Future<void> AddFavorie(SongModel song)async {
    for(var fav in _Favories){
      if(fav.path == song.path) {
        return;
      }
    }
    _Favories.add(song);
  }

  static Future<void> RemoveFavorie(SongModel song)async{
    for(var fav in _Favories){
      if(fav.path == song.path) {
        _Favories.remove(fav);
        break;
      }
    }

  }

}
class SongModel {
  String name;
  String path;
  bool isFavorite;

  SongModel(this.name, this.path, this.isFavorite);

  SongModel.fromMap(Map<String, dynamic> result)
      : name = result["name"],
        path = result["path"],
        isFavorite = result["isFavorite"] == 0 ? false : true;

  Map<String, Object> toMap() {
    return {"name": name, "path": path, "isFavorite": isFavorite ? 1 : 0};
  }
}

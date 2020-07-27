class Music {
  String title;
  String sourateNumber;
  String imagePath;
  String urlSong;

  Music(
    String title,
    String sourateNumber,
    String urlSong,
  ) {
    this.title = title;
    this.sourateNumber = sourateNumber;
    this.imagePath = 'images/quran.jpg';
    this.urlSong = urlSong;
  }

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(json['title'] as String, json['sourateNumber'].toString(),
        json['urlSong'] as String);
  }
}

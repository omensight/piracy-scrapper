class EpisodeScrapper {
  String? getEpisodeUrl({required String episodePageContent}) {
    RegExp regExp =
        RegExp(r'(?<=sources: \[{src: ").+(?=", type: "video/mp4",)');
    return regExp.stringMatch(episodePageContent);
  }

  String? getEpisodeNumber({required String episodePageContent}) {
    RegExp regExp = RegExp(r'(?<=Capitulo )\d+(?= Completo)');
    return regExp.stringMatch(episodePageContent);
  }
}

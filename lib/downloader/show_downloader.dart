import 'package:dio/dio.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';

class ShowDownloader {
  final String showUrl;
  final Dio dio;
  final ShowScrapper showScrapper;
  final EpisodeDownloader episodeDownloader;
  ShowDownloader({
    required this.showUrl,
    required this.dio,
    required this.showScrapper,
    required this.episodeDownloader,
  });
  Future<void> download() async {
    final showResponse = await dio.get<String>(showUrl);
    if (showResponse.statusCode == 200 && showResponse.data != null) {
      final showName = showScrapper.getShowName(showResponse.data!);
      final episodes = showScrapper.getEpisodeLinks(showResponse.data!);
      final first = episodes.first;
      //s
      for (int i = 0; i < episodes.length; i++) {
        await episodeDownloader.downloadEpisode(episodes[i]);
      }
    }
  }
}

import 'package:dio/dio.dart';
import 'package:scrapper/data/episode_scrapped_data.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';

class ShowDownloaderManager {
  final Dio dio;
  final ShowScrapper showScrapper;
  final EpisodeDownloader episodeDownloader;
  late List<String> episodesUriLinks;
  late List<EpisodeScrappedData> episodeDataList;
  ShowDownloaderManager({
    required this.dio,
    required this.showScrapper,
    required this.episodeDownloader,
  });

  Future<void> initialize(String showUrl) async {
    final showResponse = await dio.get<String>(showUrl);
    if (showResponse.statusCode == 200) {
      episodesUriLinks = showScrapper.getEpisodeLinks(showResponse.data!);
      episodeDataList =
          showScrapper.getEpisodeDataList(showResponse.data!, episodesUriLinks);
    }
  }

  Future<void> download() async {
    for (int i = 0; i < episodesUriLinks.length; i++) {
      await episodeDownloader.downloadEpisode(episodesUriLinks[i]);
    }
  }
}

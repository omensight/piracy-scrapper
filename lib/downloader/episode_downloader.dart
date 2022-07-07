import 'package:dio/dio.dart';
import 'package:scrapper/data/episode_content_data.dart';
import 'package:scrapper/downloader/url_generator.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';

typedef OnEpisodeDownloadProgress = void Function(
    int episodeNumber, int percent);

class EpisodeDownloader {
  final Dio dio;
  final EpisodeScrapper episodeScrapper;
  final OnEpisodeDownloadProgress? episodeDownloaderListener;
  EpisodeDownloader({
    required this.dio,
    required this.episodeScrapper,
    this.episodeDownloaderListener,
  });

  Future<void> downloadEpisode(String episodeUrl) async {
    final firstResponse = await dio.get<String>(episodeUrl);
    await Future.delayed(const Duration(seconds: 1));
    final secondResponse = await dio.get<String>(episodeUrl);
    if (firstResponse.statusCode == 200 && secondResponse.statusCode == 200) {
      final String? firstSample = episodeScrapper.getEpisodeUrl(
          episodePageContent: firstResponse.data!);
      final String? secondSample = episodeScrapper.getEpisodeUrl(
          episodePageContent: secondResponse.data!);
      final generator =
          UrlGenerator(sample1: firstSample!, sample2: secondSample!);
      print(
          '${episodeScrapper.getEpisodeNumber(episodePageContent: firstResponse.data!)}: ${generator.getGeneratedUrl()}');
      final episodeNumber = episodeScrapper.getEpisodeNumber(
          episodePageContent: firstResponse.data!);

      await dio.download(
        generator.getGeneratedUrl(),
        'downloads/$episodeNumber.mp4',
        onReceiveProgress: (count, total) => episodeDownloaderListener != null
            ? episodeDownloaderListener!(
                int.parse(episodeNumber!),
                (count / total * 100).round(),
              )
            : null,
      );
    }
  }
}

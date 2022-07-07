import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrapper/data/episode_scrapped_data.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader_manager.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';

final episodeListNotifierProvider = Provider<List<EpisodeScrappedData>>((ref) {
  final episodes =
      ref.watch(showDownloaderStateNotifierProvider).episodeDataList;
  return episodes;
});

class EpisodeListChangeNotifier extends StateNotifier<List> {
  EpisodeListChangeNotifier() : super([]);
}

final dioProvider = Provider((ref) => Dio());
final episodeScrapperProvider = Provider((ref) => EpisodeScrapper());
final episodeDownloaderProvider = Provider(
  (ref) => EpisodeDownloader(
    dio: ref.read(dioProvider),
    episodeScrapper: ref.read(episodeScrapperProvider),
    episodeDownloaderListener: (count, total) => () {
      print('Percent is: ${count / total * 100}');
    },
  ),
);
final showScrapperProvider = Provider((ref) => ShowScrapper());
final showDownloaderStateNotifierProvider = StateNotifierProvider<
    ShowDownloaderManagerStateNotifier, ShowDownloaderManager>(
  (ref) => ShowDownloaderManagerStateNotifier(
    ShowDownloaderManager(
      dio: ref.read(dioProvider),
      episodeDownloader: ref.read(episodeDownloaderProvider),
      showScrapper: ref.read(showScrapperProvider),
    ),
  ),
);

class ShowDownloaderManagerStateNotifier
    extends StateNotifier<ShowDownloaderManager> {
  ShowDownloaderManagerStateNotifier(
      ShowDownloaderManager showDownloaderManager)
      : super(showDownloaderManager);

  Future<void> initialize(String showUrl) async {
    await state.initialize(showUrl);
    state = state;
  }
}

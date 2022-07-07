import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrapper/data/episode_scrapped_data.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader_manager.dart';
import 'package:scrapper/presentation/show_downloader_viewmodel.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:test/test.dart';

void main() {
  test('Episode list is empty at start', () {
    final mockShowDownloaderManager = MockShowDownloaderManager();
    final container = ProviderContainer(overrides: [
      dioProvider.overrideWithValue(Dio()),
      episodeScrapperProvider.overrideWithValue(EpisodeScrapper()),
      showDownloaderStateNotifierProvider.overrideWithValue(
        ShowDownloaderManagerStateNotifier(mockShowDownloaderManager),
      ),
    ]);
    when(() => mockShowDownloaderManager.episodeDataList).thenReturn(
      [],
    );
    expect(container.read(episodeListNotifierProvider), isEmpty);
  });

  test('Episode list is not empty after initialize manager', () {
    final mockShowDownloaderManager = MockShowDownloaderManager();
    final container = ProviderContainer(overrides: [
      dioProvider.overrideWithValue(Dio()),
      episodeScrapperProvider.overrideWithValue(EpisodeScrapper()),
      showDownloaderStateNotifierProvider.overrideWithValue(
        ShowDownloaderManagerStateNotifier(mockShowDownloaderManager),
      ),
    ]);
    when(() => mockShowDownloaderManager.initialize(any()))
        .thenAnswer((realInvocation) => Future.value());
    when(() => mockShowDownloaderManager.episodeDataList).thenReturn(
      [
        EpisodeScrappedData(episodeName: 'E01', url: 'URL1'),
        EpisodeScrappedData(episodeName: 'E02', url: 'URL2'),
      ],
    );
    addTearDown(container.dispose);
    container.read(showDownloaderStateNotifierProvider.notifier).initialize('');
    expect(container.read(episodeListNotifierProvider), isNotEmpty);
  });
}

class MockShowDownloaderManager extends Mock implements ShowDownloaderManager {}

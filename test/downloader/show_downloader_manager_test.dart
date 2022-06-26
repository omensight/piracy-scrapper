import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader_manager.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';
import 'package:test/test.dart';

void main() {
  test('Show downloader have download the show page on init', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    var mockShowScrapper = MockShowScrapper();
    when(() => mockShowScrapper.getShowName(any())).thenReturn('Name');
    when(() => mockShowScrapper.getEpisodeLinks(any()))
        .thenReturn(['first', 'second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
      dio: mockDio,
      showScrapper: mockShowScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockShowScrapper.getEpisodeDataList(any(), any()))
        .thenReturn([]);

    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    await showDownloader.initialize(showUrl);
    verify(() => mockDio.get<String>(any())).called(1);
  });

  test('Show downloader haven\'t scrapped the episodes if http failed',
      () async {
    const showUrl = 'showUrl';
    final mockDio = _getInvalidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: MockEpisodeDownloader(),
    );
    when(() => showScrapper.getEpisodeLinks(any())).thenReturn([]);
    await showDownloader.initialize(showUrl);
    verifyNever(() => showScrapper.getEpisodeLinks(any()));
  });

  test('Downloader manager haven\'t used get on download', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    when(() => showScrapper.getShowName(any())).thenReturn('');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['First', 'Second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    when(() => showScrapper.getEpisodeDataList(any(), any())).thenReturn([]);

    await showDownloader.initialize(showUrl);
    verify(() => mockDio.get<String>(any())).called(1);
    await showDownloader.download();
    verifyNever(() => mockDio.get<String>(any()));
  });

  test('Downloader have retrieved episodes list', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    when(() => showScrapper.getShowName(any())).thenReturn('');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['First', 'Second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    when(() => showScrapper.getEpisodeDataList(any(), any())).thenReturn([]);

    await showDownloader.initialize(showUrl);
    await showDownloader.download();
    verify(() => showScrapper.getEpisodeLinks(any())).called(1);
  });

  test('Downloader have download the episodes', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    final episodeDownloader = MockEpisodeDownloader();
    when(() => showScrapper.getShowName(any())).thenReturn('');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['First', 'Second']);
    when(() => episodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    when(() => showScrapper.getEpisodeDataList(any(), any())).thenReturn([]);
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
        dio: mockDio,
        showScrapper: showScrapper,
        episodeDownloader: episodeDownloader);

    await showDownloader.initialize(showUrl);
    await showDownloader.download();
    verify(() => episodeDownloader.downloadEpisode(any())).called(2);
  });

  test('Dowloader have retrieved scrapped data', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    final episodeDownloader = MockEpisodeDownloader();
    when(() => showScrapper.getShowName(any())).thenReturn('');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['First', 'Second']);
    when(() => episodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    when(() => showScrapper.getEpisodeDataList(any(), any())).thenReturn([]);
    final ShowDownloaderManager showDownloader = ShowDownloaderManager(
        dio: mockDio,
        showScrapper: showScrapper,
        episodeDownloader: episodeDownloader);

    await showDownloader.initialize(showUrl);
    verify(() => showScrapper.getEpisodeDataList(any(), any())).called(1);
    expect(showDownloader.episodeDataList, isNotNull);
  });
}

Dio _getValidDioForShowDownload(String path) {
  final mockDio = MockDio();
  when(() => mockDio.get<String>(any())).thenAnswer(
    (_) => Future(
      () => Response(
        data: '',
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      ),
    ),
  );
  return mockDio;
}

Dio _getInvalidDioForShowDownload(String path) {
  final mockDio = MockDio();
  when(() => mockDio.get<String>(path)).thenAnswer(
    (_) => Future(
      () => Response(
        data: '',
        statusCode: 400,
        requestOptions: RequestOptions(path: path),
      ),
    ),
  );
  return mockDio;
}

class MockDio extends Mock implements Dio {}

class MockShowScrapper extends Mock implements ShowScrapper {}

class MockEpisodeDownloader extends Mock implements EpisodeDownloader {}

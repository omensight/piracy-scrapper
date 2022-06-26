import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Show downloader have download the show page', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    var mockShowScrapper = MockShowScrapper();
    when(() => mockShowScrapper.getShowName(any())).thenReturn('Name');
    when(() => mockShowScrapper.getEpisodeLinks(any()))
        .thenReturn(['first', 'second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloader showDownloader = ShowDownloader(
      showUrl: showUrl,
      dio: mockDio,
      showScrapper: mockShowScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    await showDownloader.download();
    verify(() => mockDio.get<String>(any())).called(1);
  });

  test('Show downloader have scrapped the episodes', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    when(() => showScrapper.getShowName(any())).thenReturn('Show Name');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['first', 'second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloader showDownloader = ShowDownloader(
      showUrl: showUrl,
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
    await showDownloader.download();
    verify(() => showScrapper.getShowName(any())).called(1);
  });

  test('Show downloader haven\'t scrapped the episodes if http failed',
      () async {
    const showUrl = 'showUrl';
    final mockDio = _getInvalidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    final ShowDownloader showDownloader = ShowDownloader(
      showUrl: showUrl,
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: MockEpisodeDownloader(),
    );
    await showDownloader.download();
    verifyNever(() => showScrapper.getShowName(any()));
  });

  test('Downloader have retrieved episodes list', () async {
    const showUrl = 'showUrl';
    final mockDio = _getValidDioForShowDownload(showUrl);
    final showScrapper = MockShowScrapper();
    when(() => showScrapper.getShowName(any())).thenReturn('');
    when(() => showScrapper.getEpisodeLinks(any()))
        .thenReturn(['First', 'Second']);
    var mockEpisodeDownloader = MockEpisodeDownloader();
    final ShowDownloader showDownloader = ShowDownloader(
      showUrl: showUrl,
      dio: mockDio,
      showScrapper: showScrapper,
      episodeDownloader: mockEpisodeDownloader,
    );
    when(() => mockEpisodeDownloader.downloadEpisode(any()))
        .thenAnswer((((_) => Future(() => () {}))));
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
    final ShowDownloader showDownloader = ShowDownloader(
        showUrl: showUrl,
        dio: mockDio,
        showScrapper: showScrapper,
        episodeDownloader: episodeDownloader);

    await showDownloader.download();
    verify(() => episodeDownloader.downloadEpisode(any())).called(2);
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

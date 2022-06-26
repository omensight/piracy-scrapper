import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:test/test.dart';

bool firstRequest = true;

EpisodeDownloader _setupEpisodeDownloader(
  Dio dio,
  EpisodeScrapper episodeScrapper,
) {
  final episodeDownloader =
      EpisodeDownloader(dio: dio, episodeScrapper: episodeScrapper);

  return episodeDownloader;
}

Dio _setupMockedDio() {
  final dio = MockDio();
  when((() => dio.get<String>(any()))).thenAnswer(
    (invocation) => Future(
      () => Response(
        requestOptions: RequestOptions(path: ''),
        data: '',
        statusCode: 200,
      ),
    ),
  );
  when(() => dio.download(any(), any())).thenAnswer((invocation) =>
      Future(() => Response(requestOptions: RequestOptions(path: ''))));
  return dio;
}

EpisodeScrapper _setupMockedEpisodeScrapper() {
  final EpisodeScrapper episodeScrapper = MockEpisodeScrapper();
  when(() => episodeScrapper.getEpisodeUrl(
          episodePageContent: any(named: 'episodePageContent')))
      .thenAnswer((invocation) => getResponse());
  when(() => episodeScrapper.getEpisodeNumber(
      episodePageContent: any(named: 'episodePageContent'))).thenReturn('01');
  return episodeScrapper;
}

void main() {
  tearDown(() => firstRequest = true);
  test('''Episode downloader downloaded two times an
  episode if the show content is valid''', () async {
    final mockDio = _setupMockedDio();
    var mockEpisodeScrapper = _setupMockedEpisodeScrapper();
    final EpisodeDownloader episodeDownloader =
        _setupEpisodeDownloader(mockDio, mockEpisodeScrapper);
    await episodeDownloader.downloadEpisode('');
    verify(() => mockDio.get<String>(any())).called(2);
  });

  test('''Episode downloader haven't scrapped the episode
   if the two request are not OK''', () {
    final mockDio = _getInvalidDioForEpisodeDownload();
    EpisodeScrapper episodeScrapper = MockEpisodeScrapper();
    final EpisodeDownloader episodeDownloader = EpisodeDownloader(
      dio: mockDio,
      episodeScrapper: episodeScrapper,
    );
    episodeDownloader.downloadEpisode('');

    verifyNever(() => episodeScrapper.getEpisodeUrl(
        episodePageContent: any(named: 'episodePageContent')));
  });
  test('Episode downloader have scrapped the episode url two times', () async {
    final mockDio = _setupMockedDio();
    var mockEpisodeScrapper = MockEpisodeScrapper();
    when(() => mockEpisodeScrapper.getEpisodeUrl(
            episodePageContent: any(named: 'episodePageContent')))
        .thenAnswer((invocation) => 'some');
    final EpisodeDownloader episodeDownloader =
        EpisodeDownloader(dio: mockDio, episodeScrapper: mockEpisodeScrapper);
    when(() => mockEpisodeScrapper.getEpisodeUrl(
            episodePageContent: any(named: 'episodePageContent')))
        .thenAnswer((r) => getResponse());
    when(() => mockEpisodeScrapper.getEpisodeNumber(
        episodePageContent: any(named: 'episodePageContent'))).thenReturn('01');
    when(() => mockDio.download(any(), any())).thenAnswer((invocation) =>
        Future(() => Response(requestOptions: RequestOptions(path: ''))));
    await episodeDownloader.downloadEpisode('');
    verify(() => mockEpisodeScrapper.getEpisodeUrl(
        episodePageContent: any(named: 'episodePageContent'))).called(2);
  });

  test('Downloader have used the specified url', () async {
    final Dio mockDio = _setupMockedDio();
    final EpisodeScrapper mockEpisodeScrapper = MockEpisodeScrapper();
    EpisodeDownloader downloader = EpisodeDownloader(
      dio: mockDio,
      episodeScrapper: mockEpisodeScrapper,
    );
    String episodeUrl = 'https://someurl.com';
    when(() => mockDio.get(episodeUrl)).thenAnswer(
      (invocation) => Future(
        () => Response(
          requestOptions: RequestOptions(path: ''),
          data: '',
        ),
      ),
    );
    when(() => mockEpisodeScrapper.getEpisodeUrl(
            episodePageContent: any(named: 'episodePageContent')))
        .thenAnswer((invocation) => getResponse());
    when(() => mockEpisodeScrapper.getEpisodeNumber(
        episodePageContent: any(named: 'episodePageContent'))).thenReturn('01');
    when(() => mockDio.download(any(), any())).thenAnswer((invocation) =>
        Future(() => Response(requestOptions: RequestOptions(path: ''))));
    await downloader.downloadEpisode(episodeUrl);
    verify(() => mockDio.get<String>(episodeUrl)).called(2);
  });

  test('Downloader have called to download', () async {
    final Dio mockDio = _setupMockedDio();
    final EpisodeScrapper mockEpisodeScrapper = MockEpisodeScrapper();
    EpisodeDownloader downloader = EpisodeDownloader(
      dio: mockDio,
      episodeScrapper: mockEpisodeScrapper,
    );
    String episodeUrl = 'https://someurl.com';
    when(() => mockEpisodeScrapper.getEpisodeUrl(
            episodePageContent: any(named: 'episodePageContent')))
        .thenAnswer((invocation) => getResponse());
    when(() => mockEpisodeScrapper.getEpisodeNumber(
        episodePageContent: any(named: 'episodePageContent'))).thenReturn('01');
    when(() => mockDio.download(any(), any())).thenAnswer((invocation) =>
        Future(() => Response(requestOptions: RequestOptions(path: ''))));
    await downloader.downloadEpisode(episodeUrl);
    verify(() => mockDio.download(any(), any())).called(1);
  });
}

String getResponse() {
  var response = firstRequest ? 'SomeUrl' : 'SomeSecondUrl';
  firstRequest = false;
  return response;
}

Dio _getInvalidDioForEpisodeDownload() {
  final dio = MockDio();
  when((() => dio.get<String>(any()))).thenAnswer(
    (invocation) => Future(
      () => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 400,
      ),
    ),
  );
  return dio;
}

class MockDio extends Mock implements Dio {}

class MockEpisodeScrapper extends Mock implements EpisodeScrapper {}

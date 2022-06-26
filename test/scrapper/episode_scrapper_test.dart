import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:test/test.dart';

import '../test_data/episode_page_content.dart';

void main() {
  test('Episode url is not empty', () async {
    EpisodeScrapper episodeScrapper = EpisodeScrapper();
    String? videoUrl =
        episodeScrapper.getEpisodeUrl(episodePageContent: episodePageContent);
    expect(videoUrl,
        'https://10-ukr-sv.ennovelas.com/wloopdydopz54amjhxwii5orhdi6btvwb5hv5vkxtr7kiy7yh63zpmjqdjga/v.mp4');
  });

  test('Episode name is exactly', () async {
    EpisodeScrapper episodeScrapper = EpisodeScrapper();
    String? videoUrl = episodeScrapper.getEpisodeNumber(
        episodePageContent: episodePageContent);
    expect(videoUrl, '01');
  });
}

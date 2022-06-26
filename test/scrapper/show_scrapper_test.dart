import 'package:scrapper/scrapper/show_scrapper.dart';
import 'package:test/test.dart';

import '../test_data/show_page_content.dart';

void main() {
  test('First item is a real link', () {
    final scrapper = ShowScrapper();
    final links = scrapper.getEpisodeLinks(showPageContent);
    expect(links.first, 'https://www.ennovelas.com/6bvl10yx30da');
  });
  test('First scrapped title item is a real title', () {
    final scrapper = ShowScrapper();
    final data = scrapper.getEpisodeDataList(
        showPageContent, scrapper.getEpisodeLinks(showPageContent));
    expect(data[0].episodeName, 'En los tacones de Eva - Capitulo 01');
  });
  test('First item has its rescpective url', () {
    final scrapper = ShowScrapper();
    final data = scrapper.getEpisodeDataList(
        showPageContent, scrapper.getEpisodeLinks(showPageContent));
    expect(data[0].url, 'https://www.ennovelas.com/6bvl10yx30da');
  });
  test('Name is En los tacones de Eva', () {
    final scrapper = ShowScrapper();
    expect(scrapper.getShowName(showPageContent), 'En los tacones de Eva');
  });
}

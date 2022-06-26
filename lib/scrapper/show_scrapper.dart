import 'package:scrapper/data/episode_scrapped_data.dart';

class ShowScrapper {
  List<String> getEpisodeLinks(String pageContent) {
    List<String> episodeLinkList = [];
    RegExp episodeRegx = RegExp(r'(?<=href=").+(?=" class="video200 ")');
    final matches = episodeRegx.allMatches(pageContent);
    for (final match in matches) {
      String? urlMatch = match.group(0);
      if (urlMatch != null) {
        episodeLinkList.add(urlMatch);
      }
    }
    return episodeLinkList;
  }

  List<EpisodeScrappedData> getEpisodeDataList(
      String pageContent, List<String> episodeLinks) {
    final List<EpisodeScrappedData> episodeDataList = [];
    for (String episodeLink in episodeLinks) {
      RegExp findEpisodeNameRegex = _buildEpisodeNameRegex(episodeLink);
      final String? episodeName = findEpisodeNameRegex.stringMatch(pageContent);
      if (episodeName != null) {
        episodeDataList.add(
            EpisodeScrappedData(episodeName: episodeName, url: episodeLink));
      }
    }
    return episodeDataList;
  }

  RegExp _buildEpisodeNameRegex(String episodeLink) {
    final String behind = '''
					<a href="$episodeLink" style="display: block;
    font-weight: normal;
    color: #00488f;
    font-weight: bold;
    padding: 1px 0 0;
    margin: 0 0 5px;
	width: 90%;
	font-size: 100.01%;
	text-decoration: none;" align="center">''';
    return RegExp('(?<=$behind).+(?=</a>)');
  }

  String getShowName(String pageContent) {
    RegExp nameRegex =
        RegExp(r'(?<=<h3><span class="first-word">).+(?=</span></h3>)');
    return nameRegex.stringMatch(pageContent)!;
  }
}

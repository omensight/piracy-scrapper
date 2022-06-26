import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';

void main() {
  runApp(ScrapperApp());
}

class ScrapperApp extends StatefulWidget {
  const ScrapperApp({super.key});

  @override
  State<ScrapperApp> createState() => _ScrapperAppState();
}

class _ScrapperAppState extends State<ScrapperApp> {
  void download() async {
    final showDOwnlaoder = ShowDownloader(
      showUrl: 'https://www.ennovelas.com/category/En+los+tacones+de+Eva',
      dio: Dio(),
      showScrapper: ShowScrapper(),
      episodeDownloader: EpisodeDownloader(
        dio: Dio(),
        episodeScrapper: EpisodeScrapper(),
      ),
    );
    await showDOwnlaoder.download();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Some good app')),
        body: ElevatedButton(onPressed: download, child: Text('')),
      ),
    );
  }
}

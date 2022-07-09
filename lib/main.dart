import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/downloader/episode_downloader.dart';
import 'package:scrapper/downloader/show_downloader_manager.dart';
import 'package:scrapper/scrapper/episode_scrapper.dart';
import 'package:scrapper/scrapper/show_scrapper.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ScrapperApp());
}

class ScrapperApp extends StatefulWidget {
  const ScrapperApp({super.key});

  @override
  State<ScrapperApp> createState() => _ScrapperAppState();
}

class _ScrapperAppState extends State<ScrapperApp> {
  void onProgressChange(int episodeNumber, int percent) {
    log('Episode $episodeNumber is $percent completed');
  }

  void download() async {
    final showDOwnlaoder = ShowDownloaderManager(
      dio: Dio(),
      showScrapper: ShowScrapper(),
      episodeDownloader: EpisodeDownloader(
        dio: Dio(),
        episodeScrapper: EpisodeScrapper(),
        episodeDownloaderListener: onProgressChange,
      ),
    );
    await showDOwnlaoder
        .initialize('https://www.ennovelas.com/category/En+los+tacones+de+Eva');
    await showDOwnlaoder.downloadEpisodesHumanReadable(
        [5, 9, 12, 14, 16, 18, 23, 25, 27, 3, 32, 33, 34, 38, 42, 43, 44]);

    // final downloader = EpisodeDownloader(
    //   dio: Dio(),
    //   episodeScrapper: EpisodeScrapper(),
    //   episodeDownloaderListener: onProgressChange,
    // );
    // await downloader.downloadEpisode('https://www.ennovelas.com/6bvl10yx30da');
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

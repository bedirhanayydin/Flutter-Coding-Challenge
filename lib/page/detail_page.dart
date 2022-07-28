import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/comic.dart';
import '../service/project_network_manager.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, this.characterComicId}) : super(key: key);
  final int? characterComicId;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final IProjectNetworkManager _projectDetailService;
  bool _isLoading = false;
  List<MarvelComic> charactersComic = [];

  @override
  void initState() {
    super.initState();
    _changeLoading();
    log('CHARACTER ID ${widget.characterComicId}');
    _projectDetailService = ProjectNetworkManager();
    fetchItemsWithId(widget.characterComicId ?? 0);
    setState(() {});
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> fetchItemsWithId(int postId) async {
    MarvelComic? comicItems;

    _changeLoading();
    comicItems = await _projectDetailService.fetchComic(postId);
    if (comicItems != null) {
      charactersComic.addAll(comicItems.data!.results);
    }
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: charactersComic.length,
            itemBuilder: (BuildContext contex, int index) {
              return Text('$charactersComic[index]');
            }));
  }
}

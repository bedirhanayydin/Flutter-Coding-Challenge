import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/marvelComic.dart';
import '../service/project_network_manager.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, this.characterComicId, this.characterName}) : super(key: key);
  final int? characterComicId;
  String? characterName;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final IProjectNetworkManager _projectDetailService;
  bool _isLoading = false;
  List<Results> charactersComic = [];
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
    print(comicItems);
    if (comicItems != null) {
      charactersComic.addAll(comicItems.data!.results!);
    } else {
      log('Error');
    }
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.characterName ?? 'Character'),
          backgroundColor: Colors.red,
        ),
        body: charactersComic.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: charactersComic.length,
                itemBuilder: (BuildContext contex, int index) {
                  log('${charactersComic.length}');
                  log('KARAKTERİN ÇİZGİ ROMANLARI ${charactersComic[index].title}');
                  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      charactersComic[index].title!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      '${charactersComic[index].thumbnail!.path}.${charactersComic[index].thumbnail!.extension}',
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),
                    Text(charactersComic[index].description ?? 'Açıklama Yok', style: const TextStyle(fontSize: 15)),
                  ]);
                }));
  }
}

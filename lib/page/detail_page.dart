import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        appBar: characterComicsAppBar(),
        body: charactersComic.isEmpty ? characterComicsIsEmptyWidget() : characterComicsList());
  }

  AppBar characterComicsAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Character: ${widget.characterName}',
        style: const TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
  }

  Center characterComicsIsEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitWave(
            size: 60.0,
            color: Colors.red,
          ),
          const SizedBox(
            height: 25,
          ),
          if (_isLoading)
            const Text(
              'No comics found after 2015. Turn back please.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  ListView characterComicsList() {
    return ListView.builder(
        itemCount: charactersComic.length,
        itemBuilder: (BuildContext contex, int index) {
          log('LENGTH ${charactersComic.length}');
          log('KARAKTERİN ÇİZGİ ROMANLARI ${charactersComic[index].title}');
          return Card(
            color: Colors.blue,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 30,
            child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                charactersComic[index].title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.network(
                '${charactersComic[index].thumbnail!.path}.${charactersComic[index].thumbnail!.extension}',
                fit: BoxFit.fill,
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                charactersComic[index].description ?? 'Not Description',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
        });
  }
}

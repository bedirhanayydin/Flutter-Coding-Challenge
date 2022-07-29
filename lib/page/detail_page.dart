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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Character: ${widget.characterName}',
            style: const TextStyle(fontSize: 17),
          ),
          backgroundColor: Colors.red,
        ),
        body: charactersComic.isEmpty
            ? const SpinKitWave(
                color: Colors.red,
              )
            : ListView.builder(
                itemCount: charactersComic.length,
                itemBuilder: (BuildContext contex, int index) {
                  log('${charactersComic.length}');
                  log('KARAKTERİN ÇİZGİ ROMANLARI ${charactersComic[index].title}');
                  return Card(
                    color: Colors.blue,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 30,
                    child: Column(children: [
                      Text(
                        charactersComic[index].title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Image.network(
                        '${charactersComic[index].thumbnail!.path}.${charactersComic[index].thumbnail!.extension}',
                        fit: BoxFit.fill,
                        width: 200,
                        height: 200,
                      ),
                      Text(
                        charactersComic[index].description ?? 'Not Description',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                  );
                }));
  }
}

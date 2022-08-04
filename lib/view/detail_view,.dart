import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/view_model/detail_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, this.characterComicId, this.characterName}) : super(key: key);
  final int? characterComicId;
  String? characterName;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailProvider _detailProvider;
  @override
  void initState() {
    _detailProvider = DetailProvider();
    _detailProvider.initHome(widget.characterComicId ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
      create: (_) => _detailProvider,
      builder: (context, child) => Scaffold(
        appBar: characterComicsAppBar(),
        body: Consumer<DetailProvider>(
          builder: ((context, value, child) {
            return value.charactersComic.isEmpty
                ? Center(
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
                        if (value.isLoading)
                          const Text(
                            'No comics found after 2015. Turn back please.',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: value.charactersComic.length,
                    itemBuilder: (BuildContext contex, int index) {
                      log('LENGTH ${value.charactersComic.length}');
                      log('KARAKTERİN ÇİZGİ ROMANLARI ${value.charactersComic[index].title}');
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
                            value.charactersComic[index].title!,
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
                            '${value.charactersComic[index].thumbnail!.path}.${_detailProvider.charactersComic[index].thumbnail!.extension}',
                            fit: BoxFit.fill,
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            value.charactersComic[index].description ?? 'Not Description',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                      );
                    });
          }),
        ),
      ),
    );
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
}

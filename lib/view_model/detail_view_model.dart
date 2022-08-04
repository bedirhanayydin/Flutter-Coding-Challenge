import 'package:flutter/material.dart';

import '../model/marvelComic_model.dart';
import '../service/project_network_manager.dart';

class DetailProvider with ChangeNotifier {
  late final IProjectNetworkManager projectDetailService;
  bool isLoading = false;
  List<Results> charactersComic = [];

  void initHome(int characterComicId) async {
    _changeLoading();
    projectDetailService = ProjectNetworkManager();
    await fetchItemsWithId(characterComicId);
    notifyListeners();
  }

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> fetchItemsWithId(int postId) async {
    MarvelComic? comicItems;
    _changeLoading();
    comicItems = await projectDetailService.fetchComic(postId);
    print(comicItems);
    if (comicItems != null) {
      charactersComic.addAll(comicItems.data!.results!);
    } else {
      print('Error');
    }
    _changeLoading();
    notifyListeners();
  }
}

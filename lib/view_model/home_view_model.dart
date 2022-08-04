import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/characters_model.dart';
import '../service/project_network_manager.dart';

class HomeProvider extends ChangeNotifier {
  late final IProjectNetworkManager projectService;
  bool isLoading = false;
  final RefreshController controller = RefreshController(initialRefresh: false);
  List<Results> characters = [];
  final ScrollController scrollController = ScrollController();

  Future<void> onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    controller.refreshCompleted();
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    fetchPostItemsAdvance();
    controller.loadComplete();
    notifyListeners();
  }

  Future<void> fetchPostItemsAdvance() async {
    MarvelCharacters? items;
    changeLoading();
    items = await projectService.fetchCharacter();
    if (items != null) {
      characters.addAll(items.data!.results!);
    }
    changeLoading();
    notifyListeners();
  }

  Future<void> initHome() async {
    changeLoading();
    projectService = ProjectNetworkManager();
    await fetchPostItemsAdvance();
    notifyListeners();
  }
}

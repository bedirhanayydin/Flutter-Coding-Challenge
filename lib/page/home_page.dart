import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/model/characters.dart';
import 'package:flutter_coding_challenge/service/project_network_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final IProjectNetworkManager _projectService;
  bool _isLoading = false;
  final RefreshController controller = RefreshController(initialRefresh: false);
  List<Results> characters = [];

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    controller.refreshCompleted();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    fetchPostItemsAdvance();
    if (mounted) {
      setState(() {});
    }
    controller.loadComplete();
  }

  Future<void> fetchPostItemsAdvance() async {
    MarvelCharacters? items;

    _changeLoading();
    items = await _projectService.fetchCharacter();
    if (items != null) {
      characters.addAll(items.data!.results!);
    }
    _changeLoading();
  }

  @override
  void initState() {
    super.initState();
    _changeLoading();
    _projectService = ProjectNetworkManager();
    fetchPostItemsAdvance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      body: characters.isEmpty
          ? loadingShimmerEffect()
          : SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: controller,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: character()),
    );
  }

  GridView character() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: characters.length,
        itemBuilder: ((context, index) {
          print(characters.length);
          return _PostCard(
            model: characters[index],
          );
        }));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      title: Text(
        "Marvel Characters",
        style: TextStyle(
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  Shimmer loadingShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(153, 255, 0, 0),
      highlightColor: const Color.fromARGB(171, 255, 255, 255),
      direction: ShimmerDirection.ltr,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const SizedBox(height: 40),
            );
          }),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    Key? key,
    required Results? model,
  })  : _model = model,
        super(key: key);

  final Results? _model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(_model!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                    characterComicId: _model!.id,
                    characterName: _model!.name,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 196, 11, 11),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 10),
        child: SizedBox(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.network(
              '${_model?.thumbnail?.path}.${_model?.thumbnail?.extension}',
              fit: BoxFit.fill,
              width: 150,
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              _model?.name ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

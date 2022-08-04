import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_coding_challenge/model/characters_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

import '../view_model/home_view_model.dart';
import 'detail_view,.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeProvider _homeProvider;
  bool isFabVisible = false;

  @override
  void initState() {
    _homeProvider = HomeProvider();
    _homeProvider.initHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => _homeProvider,
        builder: (context, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: appBar(context),
              floatingActionButton: Visibility(
                visible: isFabVisible,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_homeProvider.scrollController.hasClients) {
                      final position = _homeProvider.scrollController.position.minScrollExtent;
                      _homeProvider.scrollController.animateTo(
                        position,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  isExtended: true,
                  tooltip: "Scroll to Bottom",
                  child: const Icon(Icons.arrow_upward_sharp),
                ),
              ),
              body: NotificationListener<UserScrollNotification>(onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  isFabVisible = true;
                } else if (notification.direction == ScrollDirection.reverse) {
                  isFabVisible = false;
                }
                return true;
              }, child: Consumer<HomeProvider>(builder: ((context, value, child) {
                return value.characters.isEmpty
                    ? loadingShimmerEffect()
                    : SmartRefresher(
                        enablePullDown: false,
                        enablePullUp: true,
                        controller: value.controller,
                        onRefresh: value.onRefresh,
                        onLoading: value.onLoading,
                        child: GridView.builder(
                            controller: value.scrollController,
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: value.characters.length,
                            itemBuilder: ((context, index) {
                              log('${value.characters.isEmpty}');
                              return _PostCard(
                                model: value.characters[index],
                              );
                            })),
                      );
              }))),
            ));
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
        log('${_model!.id}');

        Get.to(DetailPage(
          characterComicId: _model!.id,
          characterName: _model!.name,
        ));
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
              height: 120,
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

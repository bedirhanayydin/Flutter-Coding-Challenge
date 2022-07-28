import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_coding_challenge/constants/app_constants.dart';

import '../model/characters.dart';
import '../model/comic.dart';

abstract class IProjectNetworkManager {
  Future<MarvelCharacters?> fetchCharacter();
}

class ProjectNetworkManager implements IProjectNetworkManager {
  final Dio dio;
  MarvelCharacters? characters;
  List<MarvelComic> comics = [];
  int limit = 30, offset = 0;

  ProjectNetworkManager() : dio = Dio(BaseOptions(baseUrl: AppConstants.url));

  characterUrl(String url) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final key = crypto('$ts${AppConstants.private_key}${AppConstants.public_key}');
    print(
        'KEY  ${"${AppConstants.url}$url?limit=$limit&offset=$offset&apikey=${AppConstants.public_key}&hash=$key&ts=$ts"}');
    return "${AppConstants.url}$url?limit=$limit&offset=$offset&apikey=${AppConstants.public_key}&hash=$key&ts=$ts";
  }

  @override
  Future<MarvelCharacters?> fetchCharacter() async {
    try {
      var response = await dio.get(characterUrl(_PostServicePath.characters.name));
      if (response.statusCode == 200) {
        characters = MarvelCharacters.fromJson(response.data);
        print(response.data);
        print(characters!.data?.results![0].name);
        offset = offset + 30;
        print(offset);
        return characters;
      }
    } on DioError catch (err) {
      debugPrint("error ${err.response?.statusCode}");
    }
    return null;
  }

  @override
  Future<MarvelCharacters?> fetchCharacterComics(int characterId) async {
    return null;
  }
}

crypto(String key) {
  return md5.convert(utf8.encode(key)).toString();
}

enum _PostServicePath {
  characters,
  comics,
}

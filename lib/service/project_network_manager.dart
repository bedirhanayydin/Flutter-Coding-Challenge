import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_coding_challenge/constants/app_constants.dart';
import 'package:flutter_coding_challenge/model/marvelComic.dart';
import 'package:intl/intl.dart';

import '../model/characters.dart';

abstract class IProjectNetworkManager {
  Future<MarvelCharacters?> fetchCharacter();
  Future<MarvelComic?> fetchComic(int characterComicId);
}

class ProjectNetworkManager implements IProjectNetworkManager {
  final Dio dio;
  MarvelCharacters? characters;
  MarvelComic? comics;
  int limit = 30, offset = 0;

  ProjectNetworkManager() : dio = Dio(BaseOptions(baseUrl: AppConstants.url));

  characterUrl(String url) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final key = crypto('$ts${AppConstants.private_key}${AppConstants.public_key}');
    print(
        'KEY  ${"${AppConstants.url}$url?limit=$limit&offset=$offset&apikey=${AppConstants.public_key}&hash=$key&ts=$ts"}');
    return "${AppConstants.url}$url?limit=$limit&offset=$offset&apikey=${AppConstants.public_key}&hash=$key&ts=$ts";
  }

  characterComicUrl(String urlCharacters, String urlComic, int characterId) {
    const int startYear = 2015;
    int limit = 10;
    String focDate = '-focDate';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final tsComic = DateTime.now().millisecondsSinceEpoch;
    final keyComic = crypto('$tsComic${AppConstants.private_key}${AppConstants.public_key}');

    print(
        'KEY character comic url  ${AppConstants.url}$urlCharacters/$characterId/$urlComic?dateRange=2015-01-01,$formattedDate&orderBy=$focDate&limit=$limit&apikey=${AppConstants.public_key}&hash=$keyComic&ts=$tsComic');

    return "${AppConstants.url}$urlCharacters/$characterId/$urlComic?dateRange=2015-01-01,$formattedDate&orderBy=$focDate&limit=$limit&apikey=${AppConstants.public_key}&hash=$keyComic&ts=$tsComic";
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
  Future<MarvelComic?> fetchComic(int characterComicId) async {
    try {
      var response = await dio
          .get(characterComicUrl(_PostServicePath.characters.name, _PostServicePath.comics.name, characterComicId));
      if (response.statusCode == 200) {
        comics = MarvelComic.fromJson(response.data);
        print(response.data);
        return comics;
      }
    } on DioError catch (err) {
      debugPrint("error ${err.response?.statusCode}");
    }
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

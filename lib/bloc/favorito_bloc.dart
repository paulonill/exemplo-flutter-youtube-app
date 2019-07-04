import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_app/model/video.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class FavoritoBloc implements BlocBase {

  Map<String, Video> _favoritos = {};

  final _favoritoController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  Stream<Map<String, Video>> get outFavorito => _favoritoController.stream;

  final String kEY_FAVORITOS = "favoritos";

  FavoritoBloc(){
    SharedPreferences.getInstance().then((preference) {
      if (preference.getKeys().contains(kEY_FAVORITOS)) {
        _favoritos = json.decode(preference.getString(kEY_FAVORITOS)).map((key, value){
          return MapEntry(key, Video.fromJson(value));
        }).cast<String, Video>();

        _favoritoController.add(_favoritos);
      }
    });
  }

  void toggleFavorito(Video video) {
    if (_favoritos.containsKey(video.id)) {
      _favoritos.remove(video.id);
    } else {
      _favoritos[video.id] = video;
    }

    _favoritoController.sink.add(_favoritos);

    _salvarFavorito();
  }

  void _salvarFavorito() {
    SharedPreferences.getInstance().then((preference) {
      preference.setString(kEY_FAVORITOS, json.encode(_favoritos));
    });
  }

  @override
  void dispose() {
    _favoritoController.close();
  }

}
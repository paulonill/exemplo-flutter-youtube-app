import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/api.dart';
import 'package:youtube_app/bloc/favorito_bloc.dart';
import 'package:youtube_app/bloc/video_bloc.dart';
import 'package:youtube_app/screen/home.dart';

void main(){
  Api api = Api();
  api.search("teste");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideoBloc(),
      child: BlocProvider(
        bloc: FavoritoBloc(),
          child: MaterialApp(
            title: 'Youtube - APP',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Home(),
          ))
    );
  }
}

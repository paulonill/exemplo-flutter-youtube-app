import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/bloc/favorito_bloc.dart';
import 'package:youtube_app/bloc/video_bloc.dart';
import 'package:youtube_app/delegate/data_search.dart';
import 'package:youtube_app/model/video.dart';
import 'package:youtube_app/screen/favorito.dart';
import 'package:youtube_app/widget/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<VideoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/logo.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.of<FavoritoBloc>(context).outFavorito,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("${snapshot.data.length}");
                  } else {
                    return Container();
                  }
                }),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorito()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
             String resultado = await showSearch(context: context, delegate: DataSearch());

             if (resultado != null) {
               bloc.inSearch.add(resultado);
             }
            },
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        stream: bloc.outVideos,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < snapshot.data.length) {
                      return VideoTile(snapshot.data[index]);
                    } else if(index > 1) {
                      bloc.inSearch.add(null);
                      return Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),
                      );
                    } else {
                      return Container();
                    }

                  },
              itemCount: snapshot.data.length + 1);
            } else {
              return Container();
            }
          })
    );
  }
}

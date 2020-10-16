import 'package:WolfBeat/app/modules/ui_components/mini_player.dart';
import 'package:WolfBeat/core/view_model/player/player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/view_model/song/songs_view_model.dart';
import '../../ui_components/music_tile.dart';

class PlaylistPage extends StatefulWidget {
  static const String id = 'playlist_page';

  final List<MusicTile> songs;
  final String playlistTitle;

  PlaylistPage({@required this.songs, @required this.playlistTitle});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final playerViewModel = GetIt.I.get<PlayerViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Observer(
        builder: (context) =>
            playerViewModel.currentSong != null ? MiniPlayer() : SizedBox(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.playlistTitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                builder: (context) => Container(),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                FlutterIcons.add_mdi,
                color: Color(0xFFF0F0F5),
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        if (widget.songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Essa playlist está vazia!',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 15.0),
                Text(
                  'Novas músicas aparecerão quando você adicionar',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: widget.songs.length,
          padding: EdgeInsets.symmetric(vertical: 13.0),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return widget.songs.elementAt(index);
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/player/player_controller.dart';
import '../models/song.dart';
import '../pages/player/player_page.dart';

class MusicTile extends StatelessWidget {
  MusicTile({@required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<PlayerController>(context, listen: false).stop();
          Provider.of<PlayerController>(context, listen: false)
              .updateCurrentSong(song);
          Navigator.pushNamed(context, PlayerPage.id);
        },
        onLongPress: () {
          // TODO: Refazer bottom sheet
          showBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).backgroundColor,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(
                          FlutterIcons.trash_can_outline_mco,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Remover dos favoritos',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(
                          FlutterIcons.share_2_fea,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Compartilhar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(
                          FlutterIcons.cancel_mco,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Fechar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: ListTile(
          leading: song.artworkURL != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(song.artworkURL),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Icon(
                      FlutterIcons.music_note_mdi,
                      color: Colors.white,
                    ),
                  ),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
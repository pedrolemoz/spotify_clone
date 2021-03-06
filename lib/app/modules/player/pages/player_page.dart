import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/helpers/assets_helper.dart';
import '../../../../core/view_model/player/player_view_model.dart';
import '../../../../utils/custom_track_shape.dart';

class PlayerPage extends StatefulWidget {
  static const String id = 'player_page';

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  final _playerViewModel = GetIt.I.get<PlayerViewModel>();

  @override
  void initState() {
    super.initState();
    _playerViewModel.checkFavorited();

    if (!_playerViewModel.isPlaying) {
      _playerViewModel.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _playerViewModel.checkFavorited();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [
                Hexcolor(_playerViewModel?.playerQueue
                            ?.elementAt(_playerViewModel.currentIndex)
                            ?.backgroundColor ??
                        '#00000') ??
                    Theme.of(context).scaffoldBackgroundColor,
                Colors.black38,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Column(
                children: [
                  Text(
                    'Tocando de'.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    _playerViewModel.playingFrom ?? 'Playlist',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: AssetsHelper.artworkFallback,
                        image: _playerViewModel?.playerQueue
                            ?.elementAt(_playerViewModel.currentIndex)
                            ?.artworkURL,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _playerViewModel?.playerQueue
                                    ?.elementAt(_playerViewModel.currentIndex)
                                    ?.title ??
                                'Música desconhecida',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            _playerViewModel?.playerQueue
                                    ?.elementAt(_playerViewModel.currentIndex)
                                    ?.artist ??
                                'Artista desconhecido',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                            softWrap: true,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _playerViewModel.favoriteSong();
                        },
                        child: Icon(
                          _playerViewModel.isFavorite
                              ? FlutterIcons.favorite_mdi
                              : FlutterIcons.favorite_border_mdi,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Theme.of(context).primaryColor,
                          thumbColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Colors.grey[400],
                          trackShape: CustomTrackShape(),
                          trackHeight: 1.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 7.0),
                          overlayColor:
                              Theme.of(context).primaryColor.withAlpha(80),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 20.0),
                        ),
                        child: Slider(
                          min: 0,
                          max: _playerViewModel?.totalDuration?.inSeconds
                                  ?.toDouble() ??
                              2,
                          value: _playerViewModel?.currentPosition?.inSeconds
                                  ?.toDouble() ??
                              0,
                          onChanged: (newValue) {
                            _playerViewModel
                                .seek(Duration(seconds: newValue.toInt()));
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _playerViewModel?.currentPosition
                                    ?.toString()
                                    ?.substring(2, 7) ??
                                '0:00',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            Duration(
                              seconds: _playerViewModel.playerQueue
                                  .elementAt(_playerViewModel.currentIndex)
                                  .duration,
                            ).toString().substring(2, 7),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _playerViewModel.toggleRepetead();
                        },
                        child: Icon(
                          FlutterIcons.repeat_mco,
                          color: _playerViewModel?.isRepeated ?? false
                              ? Color(0xFFF0F0F5)
                              : Colors.grey[900],
                          size: 30.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_playerViewModel?.canSkipPrevious ?? false) {
                            _playerViewModel.skipToPreviousSong();
                          }
                        },
                        child: Icon(
                          FlutterIcons.skip_previous_mco,
                          color: _playerViewModel?.canSkipPrevious ?? false
                              ? Color(0xFFF0F0F5)
                              : Colors.grey[900],
                          size: 40.0,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _playerViewModel?.isPlaying ?? false
                              ? _playerViewModel.pause()
                              : _playerViewModel.play();
                        },
                        fillColor: Color(0xFFF0F0F5),
                        splashColor: Colors.grey[400],
                        shape: CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            _playerViewModel?.isPlaying ?? false
                                ? FlutterIcons.pause_mco
                                : FlutterIcons.play_mco,
                            size: 40.0,
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_playerViewModel?.canSkipFoward ?? false) {
                            _playerViewModel.skipToNextSong();
                          }
                        },
                        child: Icon(
                          FlutterIcons.skip_next_mco,
                          color: _playerViewModel.canSkipFoward
                              ? Color(0xFFF0F0F5)
                              : Colors.grey[900],
                          size: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _playerViewModel.shuffleQueue();
                        },
                        child: Icon(
                          FlutterIcons.shuffle_mco,
                          color: _playerViewModel?.isShuffled ?? false
                              ? Color(0xFFF0F0F5)
                              : Colors.grey[900],
                          size: 30.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

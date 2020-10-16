import 'package:WolfBeat/core/models/playlist/playlist.dart';
import 'package:WolfBeat/core/models/song/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';

import '../../../app/modules/welcome/pages/welcome_page.dart';
import '../../helpers/firebase_helper.dart';

part 'user_view_model.g.dart';

/// [UserViewModel] receives the user information from Firebase.
/// Used in [ProfileSettingsPage], [SettingsPage]
/// and in [loginUserWithEmailAndPassword].
class UserViewModel = _UserViewModelBase with _$UserViewModel;

/// This is a [Store] for [UserViewModel]
abstract class _UserViewModelBase with Store {
  _UserViewModelBase() {
    recoverUserData();
  }

  @observable
  var playlists = <Playlist>[].asObservable();

  @observable
  String userID = '';

  @observable
  String userName = '';

  @observable
  String userEmail = '';

  @observable
  String imageURI = 'https://www.musicdot.com.br/assets/api/share/musicdot.jpg';

  @observable
  String type = '';

  @action
  Future<void> recoverUserData() async {
    var auth = FirebaseAuth.instance;
    var database = Firestore.instance;
    var user = await auth.currentUser();

    var snapshot = await database
        .collection(FirebaseHelper.usersCollection)
        .document(user.uid)
        .get();

    var data = snapshot.data;

    if (data.isNotEmpty) {
      await _recoverUserPlaylists(snapshot);
      userID = user.uid;
      userName = data[FirebaseHelper.nameAttribute];
      userEmail = data[FirebaseHelper.emailAttribute];
      imageURI = data[FirebaseHelper.imageURIAttribute];
      type = data[FirebaseHelper.typeAttribute];
    }
  }

  @action
  Future<void> signOutUser(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    var googleSignIn = GoogleSignIn();

    await auth.signOut().then((value) {
      googleSignIn.signOut().then((_) {
        debugPrint('Logged out');
      });
    });

    await Navigator.pushNamedAndRemoveUntil(
      context,
      WelcomePage.id,
      (route) => false,
    );
  }

  // ignore: use_setters_to_change_properties
  @action
  void updateImageURI(String newImageURI) => imageURI = newImageURI;

  @action
  Future<void> _recoverUserPlaylists(DocumentSnapshot snapshot) async {
    var data = snapshot.data;

    var _playlists = data[FirebaseHelper.playlistsAttribute];

    for (var playlist in _playlists) {
      playlists.add(
        Playlist(
          playlistName: playlist[FirebaseHelper.playlistNameAttribute],
          songs: playlist[FirebaseHelper.playlistSongsAttribute],
        ),
      );
    }
  }

  @action
  Future<void> addSongToPlaylist(
      {@required Playlist playlist, @required Song song}) async {
    var auth = FirebaseAuth.instance;
    var database = Firestore.instance;
    var user = await auth.currentUser();

    var snapshot = await database
        .collection(FirebaseHelper.usersCollection)
        .document(user.uid)
        .get();

    var data = snapshot.data;

    var _songs = playlist.songs;
    _songs.add(song.reference);

    var userPlaylists = data[FirebaseHelper.playlistsAttribute];

    Map<String, dynamic> currentPlaylist = userPlaylists.singleWhere(
        (userPlaylist) =>
            userPlaylist[FirebaseHelper.playlistNameAttribute] ==
            playlist.playlistName);

    var index = userPlaylists.indexOf(currentPlaylist);

    currentPlaylist[FirebaseHelper.playlistSongsAttribute] = _songs;

    // print([currentPlaylist, index]);

    // userPlaylists.add(
    //   <String, dynamic>{
    //     FirebaseHelper.playlistNameAttribute: newPlaylist.playlistName,
    //     FirebaseHelper.playlistSongsAttribute: newPlaylist.songs,
    //   },
    // );

    await database
        .collection(FirebaseHelper.usersCollection)
        .document(user.uid)
        .updateData(
            {FirebaseHelper.playlistsAttribute[index]: currentPlaylist});

    // playlist.copyWith(songs: _songs);
  }

  @action
  Future<void> createNewPlaylist({@required Playlist newPlaylist}) async {
    var auth = FirebaseAuth.instance;
    var database = Firestore.instance;
    var user = await auth.currentUser();

    var snapshot = await database
        .collection(FirebaseHelper.usersCollection)
        .document(user.uid)
        .get();

    var data = snapshot.data;

    List<dynamic> userPlaylists = data[FirebaseHelper.playlistsAttribute];

    userPlaylists.add(
      <String, dynamic>{
        FirebaseHelper.playlistNameAttribute: newPlaylist.playlistName,
        FirebaseHelper.playlistSongsAttribute: newPlaylist.songs,
      },
    );

    await database
        .collection(FirebaseHelper.usersCollection)
        .document(user.uid)
        .updateData({FirebaseHelper.playlistsAttribute: userPlaylists});

    playlists.add(newPlaylist);
  }
}

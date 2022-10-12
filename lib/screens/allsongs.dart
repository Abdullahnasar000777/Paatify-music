import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:paatify/controller/getsongs.dart';
import 'package:paatify/database.dart/favouritedb.dart';
import 'package:paatify/screens/nowplaying.dart';
import 'package:paatify/screens/favourite/favoritebut.dart';
import 'package:paatify/screens/home/home.dart';
import 'package:paatify/screens/playlist/playlist.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({
    Key? key,
  }) : super(key: key);
  static List<SongModel> plaYsong = [];

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final _audioQuery = OnAudioQuery();

  // int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const Text(
          "All Songs",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                ),
              );
            }
            AllSongs.plaYsong = item.data!;
            if (!FavoriteDB.isIntialized) {
              FavoriteDB.intialize(item.data!);
            }
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: QueryArtworkWidget(
                  keepOldArtwork: true,
                  quality: 100,
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(0),
                  nullArtworkWidget: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Lottie.asset(
                      'assets/listnull.json',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                onTap: () {
                  GetSongs.player.setAudioSource(
                      GetSongs.createSongList(
                        item.data!,
                      ),
                      initialIndex: index);
                  // GetSongs.player.pause();
                  GetSongs.player.play();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlaying(
                        playerSong: item.data!,
                      ),
                    ),
                  );
                },
                title: TExt(
                  teXt: item.data![index].displayNameWOExt,
                ),
                subtitle: Sub(
                  sub: "${item.data![index].artist}",
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        child: TextButton(
                          onPressed: () {
                            FavoriteBut(
                              song: AllSongs.plaYsong[index],
                            );
                          },
                          child: FavoriteBut(
                            song: AllSongs.plaYsong[index],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PlayListSc(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add To PLayList",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ),
              itemCount: item.data!.length,
            );
          },
        ),
      ),
    );
  }
}

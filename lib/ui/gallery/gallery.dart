//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  List images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
          centerTitle: true,
        ),
        body: Container(
            child: SafeArea(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("show photos here"),
            Text('There are ${assets.length} assets')
          ],
        ))));
  }

  @override
  void initState() {
    super.initState();

    _fetchAssets();
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }
}

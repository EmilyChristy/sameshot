//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  List images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
      ),
      // body: Container(
      //     child: SafeArea(
      //         child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [Text("show photos here")],
      // ))),
      body: images != null
          ? new GridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 4,
              children: List.generate(100, (index) {
                return Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headline5,
                  ));
              
              },
              // staggeredTileBuilder: (i) =>
              //     new StaggeredTile.count(2, i.isEven ? 2 : 3),
              // mainAxisSpacing: 8.0,
              // crossAxisSpacing: 8.0,
            )
          : new Center(
              child: new CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    _getImages();
  }

  Future<void> _getImages() async {
    print('inside get images>>>>>>>>>>>>');
    List imgs;
    try {
      final List result = await platform.invokeMethod('getImages');
      imgs = result;
      for (String i in result) {
        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$i');
      }
    } on PlatformException catch (e) {
      print("Error");
    }

    setState(() {
      images = imgs;
    });
  }
}

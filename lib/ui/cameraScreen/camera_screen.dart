import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sameshot/theme/custom_theme.dart';
import 'package:sameshot/ui/custom_app_bar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key}) : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  //final Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Take new photo',
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 9, // 90%
            child: Container(
              color: Colors.grey[400],
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                        child: Text(
                          "{Camera screen here}",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.photo_camera_sharp),
      ),
    );
  }
}

import 'package:flutter/material.dart';
//import 'package:photo_manager/photo_manager.dart';

import 'package:sameshot/theme/config.dart';
import 'package:sameshot/theme/custom_theme.dart';
import 'package:sameshot/ui/camera_page.dart';
import 'package:sameshot/ui/custom_app_bar.dart';
import 'package:sameshot/ui/gallery/gallery.dart';
import 'package:sameshot/ui/xsettings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool _alertIsVisible = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    print("TApped ${_selectedIndex.toString()}");

    if (_selectedIndex == 1) {
      //ask for permission to access photos
      //final permitted = await PhotoManager.requestPermission();
      //if (!permitted) return;

      //go to gallery page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Gallery(),
        ),
      );
    }

    if (_selectedIndex == 2) {
      //go to settings page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("OLD HOME page");

    return Scaffold(
      // appBar: CustomAppBar(
      //   title: 'Home',
      // ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 9, // 90%
            child: Container(
              color: Colors.grey[400],
              child: Column(
                children: [
                  SizedBox(height: 50),
                  // new Container(
                  //     child: new Image.asset(
                  //   'images/sameshotlogo.png',
                  //   height: 60.0,
                  //   fit: BoxFit.cover,
                  // )),
                  // SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                        child: Text(
                          "Previous Sameshot images",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    color: Colors.amber[100],
                    width: 350,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("You have no previous images"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CameraPage();
            }),
          )
        },
        child: const Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Photos',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // void _showAlert(BuildContext context) {
  //   Widget okButton = FlatButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //         //this._alertIsVisible = false;
  //       },
  //       child: Text("Awesome"));
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("My Alert"),
  //           content: Text("My first popup"),
  //           actions: <Widget>[okButton],
  //           elevation: 5,
  //         );
  //       });
  // }
}

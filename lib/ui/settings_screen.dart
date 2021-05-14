import 'package:flutter/material.dart';
import 'package:sameshot/ui/custom_app_bar.dart';
import 'package:sameshot/theme/config.dart';
import 'package:sameshot/theme/custom_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  var textValue = "Theme: " + currentTheme.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sameshot',
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1, // 10%
            child: Container(color: Colors.green[30]),
          ),
          Expanded(
            flex: 8, // 80%
            child: Container(
              color: Colors.green[40],
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text("Settings"),
                  SizedBox(height: 50),
                  Switch(
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        currentTheme.toggleTheme();
                        print(isSwitched);
                      });
                    },
                    value: isSwitched,
                    activeColor: Colors.indigo[900],
                    activeTrackColor: Colors.lightBlue[100],
                    inactiveThumbColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.lightBlue.shade100,
                  ),
                  Text(textValue),
                  //SizedBox(height: 200),
                  //RaisedButton(child: const Text("OK Go"), onPressed: () => {})
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1, // 10%
            child: Container(color: Colors.green[30]),
          )
        ],
      ),
    );
  }
}

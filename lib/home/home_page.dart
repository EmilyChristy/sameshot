import 'package:flutter/material.dart';
import 'package:sameshot/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  Text("Hello"),
                  SizedBox(height: 200),
                  RaisedButton(child: const Text("OK Go"), onPressed: () => {})
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

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 32.0,
          ),
          Text(
            'Some text here',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 32.0,
          ),
          RaisedButton(
            child: const Text('CLick me'),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sameshot/ui/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _alertIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sameshot',
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
                  new Container(
                      child: new Image.asset(
                    'images/sameshot-logo.png',
                    height: 60.0,
                    fit: BoxFit.cover,
                  )),
                  SizedBox(height: 200),
                  RaisedButton(
                      child: Text("Click Me"),
                      onPressed: () {
                        this._alertIsVisible = true;
                        _showAlert(context);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context) {
    Widget okButton = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          this._alertIsVisible = false;
        },
        child: Text("Awesome"));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("My Alert"),
            content: Text("My first popup"),
            actions: <Widget>[okButton],
            elevation: 5,
          );
        });
  }
}

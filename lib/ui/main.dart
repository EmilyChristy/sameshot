import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../app_state.dart';
import '../ui/splash.dart';
import 'package:sameshot/theme/config.dart';
import 'package:sameshot/theme/custom_theme.dart';
import 'package:sameshot/router/router_delegate.dart';
import 'package:sameshot/router/shopping_parser.dart';
import 'package:sameshot/router/ui_pages.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final appState = AppState();
  ShoppingRouterDelegate delegate;
  final parser = ShoppingParser();

  // TODO Add Subscription

  _CameraAppState() {
    delegate = ShoppingRouterDelegate(appState);
    delegate.setNewRoutePath(SplashPageConfig);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    currentTheme.addListener(() {
      //2
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO Dispose of Subscription
    super.dispose();
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // TODO Attach a listener to the Uri links stream
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: MaterialApp.router(
        title: 'Sameshot',
        theme: CustomTheme.lightTheme, //3
        darkTheme: CustomTheme.darkTheme, //4
        themeMode: currentTheme.currentTheme,
        routerDelegate: delegate,
        routeInformationParser: parser,
        //home: Splash(),
      ),
    );
  }
}

void main() => runApp(CameraApp());

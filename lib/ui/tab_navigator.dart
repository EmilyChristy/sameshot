import 'dart:async';

import 'package:flutter/material.dart';
import '../color_detail_page.dart';
import '../colors_list_page.dart';
import 'tab_item.dart';
import 'settings_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String camera = '/camera';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.stacked});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final bool stacked;

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    print("SUB TAB PUSHED >>>> ${tabItem.toString()}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => ColorsListPage(
            color: activeTabColor[tabItem],
            title: tabName[tabItem],
            onPush: (materialIndex) =>
                _push(context, materialIndex: materialIndex),
          ),
      TabNavigatorRoutes.detail: (context) => ColorDetailPage(
            color: activeTabColor[tabItem],
            title: tabName[tabItem],
            materialIndex: materialIndex,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          if (stacked) {
            return MaterialPageRoute(
              builder: (context) {
                return routeBuilders[routeSettings.name](context);
              },
            );
          }

          return MaterialPageRoute(
            builder: (context) => SettingsPage(
              color: activeTabColor[tabItem],
              title: tabName[tabItem],
              materialIndex: 0,
            ),
          );
        });
  }
}

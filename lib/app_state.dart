import 'package:flutter/material.dart';
import 'package:sameshot/ui/tab_item.dart';
import 'package:sameshot/ui/tab_navigator.dart';

import 'ui/bottom_navigation.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  var _currentTab = TabItem.galleries;
  bool _splashFinished = false;
  bool get splashFinished => _splashFinished;

  final _navigatorKeys = {
    TabItem.settings: GlobalKey<NavigatorState>(),
    TabItem.galleries: GlobalKey<NavigatorState>(),
    TabItem.camera: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  void setSplashFinished() {
    _splashFinished = true;
    print("SPLASH FINISHED - - - - -- -");
    // _currentAction =
    //     PageAction(state: PageState.replaceAll, page: HomePageConfig);

    //notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.galleries) {
            // select 'main' tab
            _selectTab(TabItem.galleries);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.settings, false),
          _buildOffstageNavigator(TabItem.galleries, true),
          _buildOffstageNavigator(TabItem.camera, false),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem, bool isStacked) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
        stacked: isStacked,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sameshot/ui/home/home_page.dart';
import '../app_state.dart';
import '../ui/settings_screen.dart';
import '../ui/splash.dart';
import 'ui_pages.dart';

// 1
class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    // 2
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageConfiguration> {
  // 3
  final List<Page> _pages = [];

  // 4
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // 5
  final AppState appState;

  // 6
  ShoppingRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  // 7
  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

// 8
  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // 1
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // 2
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: Key(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {
    // 1
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;

    if (shouldAddPage) {
      // 2
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          // 3
          _addPageData(Splash(), SplashPageConfig);
          break;

        case Pages.Settings:
          _addPageData(SettingsPage(), SettingsPageConfig);
          break;

        case Pages.Home:
          _addPageData(HomePage(), HomePageConfig);
          break;
        // case Pages.Details:
        //   if (pageConfig.currentPageAction != null) {
        //     _addPageData(pageConfig.currentPageAction.widget, pageConfig);
        //   }
        //   break;
        default:
          break;
      }
    }
  }

  // 1
  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

// 2
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

// 3
  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

// 4
  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

// 5
  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

// 6
  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;

      case Pages.Settings:
        SettingsPageConfig.currentPageAction = action;
        break;
      case Pages.Home:
        HomePageConfig.currentPageAction = action;
        break;

      default:
        break;
    }
  }

  List<Page> buildPages() {
    // 1
    if (!appState.splashFinished) {
      replaceAll(SplashPageConfig);
    } else {
      // 2
      switch (appState.currentAction.state) {
        // 3
        case PageState.none:
          break;
        case PageState.addPage:
          // 4
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page);
          break;
        case PageState.pop:
          // 5
          pop();
          break;
        case PageState.replace:
          // 6
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page);
          break;
        case PageState.replaceAll:
          // 7
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page);
          break;
        case PageState.addWidget:
          // 8
          _setPageAction(appState.currentAction);
          pushWidget(
              appState.currentAction.widget, appState.currentAction.page);
          break;
        case PageState.addAll:
          // 9
          addAll(appState.currentAction.pages);
          break;
      }
    }
    // 10
    appState.resetCurrentAction();
    return List.of(_pages);
  }
}

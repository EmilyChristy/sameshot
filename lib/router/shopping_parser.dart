import 'package:flutter/material.dart';
import 'ui_pages.dart';

class ShoppingParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    // 1
    final uri = Uri.parse(routeInformation.location);
    // 2
    if (uri.pathSegments.isEmpty) {
      return SplashPageConfig;
    }

    // 3
    final path = uri.pathSegments[0];
    // 4
    switch (path) {
      case SplashPath:
        return SplashPageConfig;
      case HomePath:
        return HomePageConfig;
      case SettingsPath:
        return SettingsPageConfig;
      default:
        return SplashPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: SplashPath);
      case Pages.Settings:
        return const RouteInformation(location: SettingsPath);
      case Pages.Home:
        return const RouteInformation(location: HomePath);
      default:
        return const RouteInformation(location: SplashPath);
    }
  }
}

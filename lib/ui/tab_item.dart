import 'package:flutter/material.dart';

enum TabItem { settings, galleries, camera }

const Map<TabItem, String> tabName = {
  TabItem.settings: 'settings',
  TabItem.galleries: 'galleries',
  TabItem.camera: 'camera',
  //TabItem.orange: 'orange',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.settings: Colors.blueGrey,
  TabItem.galleries: Colors.deepOrange,
  TabItem.camera: Colors.blue,
};

const Map<TabItem, Icon> tabIcon = {
  TabItem.settings: Icon(Icons.settings, color: Colors.blueGrey),
  TabItem.galleries: Icon(Icons.snippet_folder_sharp, color: Colors.deepOrange),
  TabItem.camera: Icon(Icons.camera, color: Colors.blue),
};

// Color _colorTabMatching(TabItem item) {
//   return currentTab == item ? activeTabColor[item] : Colors.grey;
// }

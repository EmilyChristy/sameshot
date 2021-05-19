import 'package:flutter/material.dart';
import 'tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({@required this.currentTab, @required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.settings),
        _buildItem(TabItem.galleries),
        _buildItem(TabItem.camera),
      ],
      onTap: (index) => tabbtnPressed(index),
    );
  }

  //bottom menu button onpress
  void tabbtnPressed(int index) {
    //print("Bottom nav pressed ${index}:${currentTab} ------");
    return onSelectTab(
      TabItem.values[index],
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: tabIcon[
          tabItem], //Icon(Icons.layers, color: _colorTabMatching(tabItem)),
      label: tabName[tabItem],
    );
  }

  Color _colorTabMatching(TabItem item) {
    return currentTab == item ? activeTabColor[item] : Colors.grey;
  }
}

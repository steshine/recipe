// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


class _PageSelector extends StatelessWidget {
  const _PageSelector({ this.icons });

  final List<AssetImage> icons;

  void _handleArrowButtonPress(BuildContext context, int delta) {
    final TabController controller = DefaultTabController.of(context);
    if (!controller.indexIsChanging)
      controller.animateTo((controller.index + delta).clamp(0, icons.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    final Color color = Theme.of(context).accentColor;
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: color,
                  onPressed: () { _handleArrowButtonPress(context, -1); },
                  tooltip: 'Page back',
                ),
                TabPageSelector(controller: controller),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: color,
                  onPressed: () { _handleArrowButtonPress(context, 1); },
                  tooltip: 'Page forward',
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: 128.0,
                color: color,
              ),
              child: TabBarView(
                children: icons.map<Widget>((AssetImage icon) {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: Center(
                        child: DecoratedBox(decoration: BoxDecoration(
                          image: DecorationImage(image: icon)
                        ))
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CatSelectorState extends State<CatSelector>{
  static final List<AssetImage> icons = <AssetImage>[
    const AssetImage('image/week.jpg'),
    const AssetImage('image/dog.jpg'),
    const AssetImage('image/loulou.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('猫咪选择'),
      ),
      body: DefaultTabController(
        length: icons.length,
        child: _PageSelector(icons: icons),
      ),
    );
  }

}
class CatSelector extends StatefulWidget {
  static const String routeName = '/material/page-selector';
  @override
  CatSelectorState createState() => CatSelectorState();
}

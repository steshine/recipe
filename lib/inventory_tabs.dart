// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:recipe/recipe_list.dart';

import 'modes.dart';


enum TabsDemoStyle {
  iconsAndText,
  iconsOnly,
  textOnly
}


class ScrollableTabsDemo extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';

  @override
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
}

class ScrollableTabsDemoState extends State<ScrollableTabsDemo> with SingleTickerProviderStateMixin {
  TabController _controller;
  TabsDemoStyle _demoStyle = TabsDemoStyle.iconsAndText;
  bool _customIndicator = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: allSkuCategories.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeDemoStyle(TabsDemoStyle style) {
    setState(() {
      _demoStyle = style;
    });
  }

  Decoration getIndicator() {
    if (!_customIndicator)
      return const UnderlineTabIndicator();

    switch(_demoStyle) {
      case TabsDemoStyle.iconsAndText:
        return ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            side: BorderSide(
              color: Colors.white24,
              width: 2.0,
            ),
          ) + const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            side: BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
        );

      case TabsDemoStyle.iconsOnly:
        return ShapeDecoration(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white24,
              width: 4.0,
            ),
          ) + const CircleBorder(
            side: BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
        );

      case TabsDemoStyle.textOnly:
        return ShapeDecoration(
          shape: const StadiumBorder(
            side: BorderSide(
              color: Colors.white24,
              width: 2.0,
            ),
          ) + const StadiumBorder(
            side: BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('库存分类'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sentiment_very_satisfied),
            onPressed: () {
              setState(() {
                _customIndicator = !_customIndicator;
              });
            },
          ),
          PopupMenuButton<TabsDemoStyle>(
            onSelected: changeDemoStyle,
            itemBuilder: (BuildContext context) => <PopupMenuItem<TabsDemoStyle>>[
              const PopupMenuItem<TabsDemoStyle>(
                value: TabsDemoStyle.iconsAndText,
                child: Text('Icons and text'),
              ),
              const PopupMenuItem<TabsDemoStyle>(
                value: TabsDemoStyle.iconsOnly,
                child: Text('Icons only'),
              ),
              const PopupMenuItem<TabsDemoStyle>(
                value: TabsDemoStyle.textOnly,
                child: Text('Text only'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          indicator: getIndicator(),
          tabs: allSkuCategories.map<Tab>((SkuCategory category){
            return Tab(text: category.title,icon:Icon(category.icon));
          }).toList()
          /*tabs: _allPages.map<Tab>((_Page page) {
            assert(_demoStyle != null);
            switch (_demoStyle) {
              case TabsDemoStyle.iconsAndText:
                return Tab(text: page.text, icon: Icon(page.icon));
              case TabsDemoStyle.iconsOnly:
                return Tab(icon: Icon(page.icon));
              case TabsDemoStyle.textOnly:
                return Tab(text: page.text);
            }
            return null;
          }).toList(),*/
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: allSkuCategories.map<Widget>((SkuCategory category) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Container(
              key: ObjectKey(category.icon),
              padding: const EdgeInsets.all(2.0),
              child:  category.child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

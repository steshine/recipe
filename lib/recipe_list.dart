// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'detail_panels.dart';
import 'modes.dart';

enum _MaterialListType {
  /// A list tile that contains a single line of text.
  oneLine,

  /// A list tile that contains a [CircleAvatar] followed by a single line of text.
  oneLineWithAvatar,

  /// A list tile that contains two lines of text.
  twoLine,

  /// A list tile that contains three lines of text.
  threeLine,
}

class ListDemo extends StatefulWidget {
  const ListDemo({Key key}) : super(key: key);

  static const String routeName = '/material/list';

  @override
  _ListDemoState createState() => _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  PersistentBottomSheetController<void> _bottomSheet;
  _MaterialListType _itemType = _MaterialListType.threeLine;
  bool _dense = false;
  bool _showAvatars = true;
  bool _showIcons = true;
  bool _showDividers = false;
  bool _reverseSort = false;
  List<SkuItem> items = <SkuItem>[
   SkuItem(title: '牛肉',icon: Icons.title,desc: '大庄园 1kg',buildRoute:  (BuildContext context) =>  DetailPanel()),
   SkuItem(title: '羊肉',icon: Icons.title,desc: '大庄园 2kg',buildRoute:  (BuildContext context) =>  DetailPanel()),
   SkuItem(title: '猪肉',icon: Icons.title,desc: '大庄园 3kg',buildRoute:  (BuildContext context) =>  DetailPanel()),
  ];

  void changeItemType(_MaterialListType type) {
    setState(() {
      _itemType = type;
    });
    _bottomSheet?.setState(() {});
  }

  void _showConfigurationSheet() {
    final PersistentBottomSheetController<void> bottomSheet = scaffoldKey
        .currentState
        .showBottomSheet<void>((BuildContext bottomSheetContext) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black26)),
        ),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('One-line'),
                trailing: Radio<_MaterialListType>(
                  value: _showAvatars
                      ? _MaterialListType.oneLineWithAvatar
                      : _MaterialListType.oneLine,
                  groupValue: _itemType,
                  onChanged: changeItemType,
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Two-line'),
                trailing: Radio<_MaterialListType>(
                  value: _MaterialListType.twoLine,
                  groupValue: _itemType,
                  onChanged: changeItemType,
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Three-line'),
                trailing: Radio<_MaterialListType>(
                  value: _MaterialListType.threeLine,
                  groupValue: _itemType,
                  onChanged: changeItemType,
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Show avatar'),
                trailing: Checkbox(
                  value: _showAvatars,
                  onChanged: (bool value) {
                    setState(() {
                      _showAvatars = value;
                    });
                    _bottomSheet?.setState(() {});
                  },
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Show icon'),
                trailing: Checkbox(
                  value: _showIcons,
                  onChanged: (bool value) {
                    setState(() {
                      _showIcons = value;
                    });
                    _bottomSheet?.setState(() {});
                  },
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Show dividers'),
                trailing: Checkbox(
                  value: _showDividers,
                  onChanged: (bool value) {
                    setState(() {
                      _showDividers = value;
                    });
                    _bottomSheet?.setState(() {});
                  },
                ),
              ),
            ),
            MergeSemantics(
              child: ListTile(
                dense: true,
                title: const Text('Dense layout'),
                trailing: Checkbox(
                  value: _dense,
                  onChanged: (bool value) {
                    setState(() {
                      _dense = value;
                    });
                    _bottomSheet?.setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });

    setState(() {
      _bottomSheet = bottomSheet;
    });

    _bottomSheet.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          _bottomSheet = null;
        });
      }
    });
  }

  Widget buildListTile(BuildContext context, SkuItem item) {
    Widget secondary;
    if (_itemType == _MaterialListType.twoLine) {
      secondary = const Text('Additional item information.');
    } else if (_itemType == _MaterialListType.threeLine) {
      secondary = const Text(
        'Even more additional list item information appears on line three.',
      );
    }
    return MergeSemantics(
      child: ListTile(
        isThreeLine: _itemType == _MaterialListType.threeLine,
        dense: _dense,
        leading: _showAvatars
            ? ExcludeSemantics(child: CircleAvatar(child: Text(item.title.substring(0,1))))
            : null,
        title: Text(item.title),
        subtitle: Text(item.desc),
        trailing: _showIcons
            ? Icon(Icons.info, color: Theme.of(context).disabledColor)
            : null,
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPanel()));}
      ),
    );
  }
  void _launchDemo(BuildContext context) {
       Navigator.pushNamed(context, '/material/expansion_panels');
  }

  @override
  Widget build(BuildContext context) {
    final String layoutText = _dense ? ' \u2013 Dense' : '';
    String itemTypeText;
    switch (_itemType) {
      case _MaterialListType.oneLine:
      case _MaterialListType.oneLineWithAvatar:
        itemTypeText = 'Single-line';
        break;
      case _MaterialListType.twoLine:
        itemTypeText = 'Two-line';
        break;
      case _MaterialListType.threeLine:
        itemTypeText = 'Three-line';
        break;
    }

    Iterable<Widget> listTiles =
        items.map<Widget>((SkuItem item) => buildListTile(context, item));
    if (_showDividers)
      listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Scaffold(
      key: scaffoldKey,
      /*appBar: AppBar(
        title: Text('Scrolling list\n$itemTypeText$layoutText'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              setState(() {
                _reverseSort = !_reverseSort;
                items.sort((String a, String b) =>
                    _reverseSort ? b.compareTo(a) : a.compareTo(b));
              });
            },
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Icons.more_horiz
                  : Icons.more_vert,
            ),
            tooltip: 'Show menu',
            onPressed: _bottomSheet == null ? _showConfigurationSheet : null,
          ),
        ],
      ),*/
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: _dense ? 4.0 : 8.0),
          children: listTiles.toList(),
        ),
      ),
    );
  }
}

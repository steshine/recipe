import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MenuPage(),
  ));
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key key,this.menus}):super(key: key);
  final List<Menu> menus;

  @override
  State<StatefulWidget> createState() => _MenuPageState();

}
class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('星期の菜谱'),
      ),
      body: Row(
        children: <Widget>[
          MenuBox(),
          MenuBox(),
          MenuBox(),
        ]
      ),
    );
  }
}
class MenuBox extends StatelessWidget {
  final Menu menu = _fridge;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
      child: RaisedButton(
        child: Text(menu.name), onPressed: () {},
      ),
    );
  }
}

class Menu {
  const Menu._({
    @required this.name,
    @required this.icon,
  });

  final String name;
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (runtimeType != other.runtimeType)
      return false;
    final Menu typedOther = other;
    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}

const Menu _fridge = Menu._(
  name: '冰箱',
  icon: IconData(0xe91c, fontFamily: 'GalleryIcons'),
);

const Menu _recipe = Menu._(
  name: '菜谱',
  icon: IconData(0xe91e, fontFamily: 'GalleryIcons'),
);
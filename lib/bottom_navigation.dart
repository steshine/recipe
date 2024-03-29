import 'package:flutter/material.dart';

import 'cat_selector.dart';
import 'inventory_tabs.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: BottomNavigationDemo(),
  ));
}

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
    StatefulWidget routeName,
  })
      : _icon = icon,
        _color = color,
        _title = title,
        _routeName = routeName,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final StatefulWidget _routeName;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BottomNavigationBarType type,
      BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      decoration: BoxDecoration(
        border: Border.all(color: iconTheme.color, width: 2.0),
      ),
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        //activeIcon: CustomIcon(),
          icon: const Icon(Icons.ac_unit),
          title: '冰箱',
          color: Colors.deepOrange,
          vsync: this,
          routeName: ScrollableTabsDemo()
      ),
      NavigationIconView(
          icon: const Icon(Icons.access_alarm),
          title: '提醒',
          color: Colors.deepPurple,
          vsync: this,
          routeName: CatSelector()
      ),

      NavigationIconView(
          activeIcon: const Icon(Icons.favorite),
          icon: const Icon(Icons.favorite_border),
          title: '猫咪',
          color: Colors.indigo,
          vsync: this,
          routeName: CatSelector()
      ),
      NavigationIconView(
          icon: const Icon(Icons.event_available),
          title: '菜谱',
          color: Colors.pink,
          vsync: this,
          routeName: CatSelector()
      ),
    ];

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>((
          NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      //iconSize: 4.0,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      /*appBar: AppBar(
        title: const Text('星期の菜谱'),
        actions: <Widget>[
          //MaterialDemoDocumentationButton(BottomNavigationDemo.routeName),

          PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
                _type = value;
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: Text('Fixed'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: Text('Shifting'),
              ),
            ],
          ),
        ],
      ),*/
      body: Center(
        child: _navigationViews[_currentIndex]._routeName,
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}

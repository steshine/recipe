import 'package:flutter/material.dart';
import 'package:recipe/recipe_list.dart';

class SkuCategory {
  const SkuCategory({
    @required this.title,
    @required this.icon,
    @required this.routeName,
    @required this.child
  })
      : assert(title != null),
        assert(routeName != null),
        assert(child != null);
  final String title;
  final IconData icon;
  final String routeName;
  final  StatefulWidget child;
}

class SkuItem {
  const SkuItem({
    @required this.title,
    @required this.icon,
    @required this.desc,
    @required this.buildRoute
  })
      : assert(title != null),
        assert(desc != null),
        assert(buildRoute != null);
  final String title;
  final IconData icon;
  final String desc;
  final WidgetBuilder buildRoute;
}

final List<SkuCategory> allSkuCategories = _buildSkuCategory();
List<SkuCategory> _buildSkuCategory() {
  final List<SkuCategory> categoryList = <SkuCategory>[
    SkuCategory(
      title: '生骨肉',
      icon: Icons.grade,
      routeName: ListDemo.routeName,
      child: ListDemo(),
    ),
    SkuCategory(
      title: '食材',
      icon: Icons.access_time,
      routeName: ListDemo.routeName,
      child: ListDemo(),
    ),
    SkuCategory(
      title: '添加物',
      icon: Icons.accessible,
      routeName: ListDemo.routeName,
      child: ListDemo(),
    )
  ];
  return categoryList;
}
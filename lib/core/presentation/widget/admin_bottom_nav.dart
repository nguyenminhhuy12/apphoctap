import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routing/app_routes.dart';

class AdminBottomNav extends StatefulWidget {
  final int initialIndex;
  const AdminBottomNav({super.key, required this.initialIndex});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  late int currentIndex;

  final List<IconData> _icons = [
    Icons.home,
    Icons.book,
    Icons.task,
  ];

  final List<String> _labels = [
    'Home',
    'Course',
    'List task',
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() => currentIndex = index);
        _onItemTapped(context, index);
      },
      selectedItemColor: Colors.orangeAccent,
      items: List.generate(
        _icons.length,
        (index) => BottomNavigationBarItem(
          icon: Icon(_icons[index]),
          label: _labels[index],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homeadmin);
        break;
      case 1:
        context.go(AppRoutes.courseadmin);
        break;
      case 2:
        context.go(AppRoutes.listtaskadmin);
        break;
    }
  }
}

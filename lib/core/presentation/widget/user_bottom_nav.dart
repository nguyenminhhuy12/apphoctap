import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apphoctap/core/routing/app_routes.dart';

class UserBottomNav extends StatefulWidget {
  final int initialIndex;
  const UserBottomNav({super.key, required this.initialIndex});
  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
 late int currentIndex;

  final List<IconData> _icons = [
    Icons.home,
    Icons.book,
    Icons.task,
    Icons.score,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
              color: Colors.redAccent, 
              boxShadow: const [BoxShadow(
                    color: Colors.black45, 
                    blurRadius: 4)], 
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate( _icons.length, (index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                  _onItemTapped(context, index);
                },
                child: Icon(
                  _icons[index],
                  color: currentIndex == index ?Colors.blue : Colors.amber,
                  size: 28,
                  ),
                );
          }),
        ),
      );
  }


  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homeuser);
        break;
      case 1:
        context.go(AppRoutes.courseuser);
        break;
      case 2:
        context.go(AppRoutes.listtaskuser);
        break;   
      case 3:
        context.go(AppRoutes.score);
        break;
    }
  }
}
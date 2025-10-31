import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routing/app_routes.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("john.doe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=3',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => context.go(AppRoutes.homeuser),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Course'),
            onTap: () => context.push(AppRoutes.courseuser),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Task'),
            onTap: () => context.push(AppRoutes.listtaskuser),
          ),
          ListTile(
            leading: const Icon(Icons.score),
            title: const Text('Score'),
            onTap: () => context.push(AppRoutes.score),
          ),
        ],
      ),
    );
  }
}

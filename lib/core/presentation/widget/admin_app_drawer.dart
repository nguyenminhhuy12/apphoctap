import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routing/app_routes.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({super.key});

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
            onTap: () => context.go(AppRoutes.homeadmin),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Courses'),
            onTap: () => context.push(AppRoutes.courseadmin),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('List tasks'),
            onTap: () => context.push(AppRoutes.listtaskadmin),
          ),
        ],
      ),
    );
  }
}

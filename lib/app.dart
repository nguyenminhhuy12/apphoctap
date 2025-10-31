import 'package:flutter/material.dart';
import 'package:apphoctap/core/presentation/theme/app_theme.dart';
import 'package:apphoctap/core/routing/app_go_router.dart';
// import 'core/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clean Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.halloweenTheme,
      // theme: ThemeData(
      //     useMaterial3: true, 
      //     colorSchemeSeed: Colors.blue,
      //       // 👇 cấu hình chung cho BottomNavigationBar
      //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //       backgroundColor: Colors.black,
      //       selectedItemColor: Colors.amber,
      //       unselectedItemColor: Colors.white70,
      //       selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ),
      
      // initialRoute: '/',
      // onGenerateRoute: AppRouter.onGenerateRoute,
      routerConfig: AppGoRouter.router,
    );
  }
}

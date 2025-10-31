import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apphoctap/core/presentation/widget/user_drawer.dart';
import 'package:apphoctap/core/routing/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  late VideoPlayerController _videoController;

  void _increment() => setState(() => _counter++);

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // ✅ Hàm đăng xuất hoàn chỉnh
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role'); // Xóa vai trò khỏi local
    await FirebaseAuth.instance.signOut(); // Đăng xuất Firebase

    if (context.mounted) {
      context.go(AppRoutes.login); // Quay lại trang đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/testimg2.png',
                width: 250,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              // 🎥 Video player
              _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController.value.isPlaying
                            ? _videoController.pause()
                            : _videoController.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () {
                      _videoController.pause();
                      _videoController.seekTo(Duration.zero);
                      setState(() {});
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              
              

              // ❌ Nút đăng xuất (phụ)
              ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text("Đăng xuất"),
              ),
            ],
          ),
        ),
      ),
  
    );
  }
}

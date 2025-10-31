import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apphoctap/core/routing/app_routes.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;

  // ✅ Khởi tạo AuthRepository (sử dụng Firebase)
  final AuthRepository _authRepository = FirebaseAuthDataSource(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      error = null;
      _isLoading = true;
    });

    try {
      // Đăng nhập Firebase
      UserEntity? user = await _authRepository.signIn(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (user != null) {
        // Lấy role từ Firestore
        String? role = await _authRepository.getUserRole(user.uid);

        // Nếu chưa có role → tự gán role = "User" và cập nhật vào Firestore
        if (role == null || role.isEmpty) {
          role = "User";
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'role': 'User'}, SetOptions(merge: true));
          print("🆕 Người dùng mới, auto gán role: User");
        }

        print("🎯 Vai trò người dùng sau đăng nhập: $role");

        // Chuyển trang theo vai trò
        if (role == 'Admin') {
          if (mounted) context.go(AppRoutes.homeadmin);
        } else if (role == 'User') {
          if (mounted) context.go(AppRoutes.homeuser);
        } else {
          setState(() => error = "Không xác định được vai trò người dùng!");
        }
      } else {
        setState(() => error = "Đăng nhập thất bại!");
      }
    } catch (e) {
      setState(() {
        error = "Lỗi đăng nhập: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Đăng nhập"),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.signup),
              child: const Text("Chưa có tài khoản? Đăng ký ngay"),
            ),
          ],
        ),
      ),
    );
  }
}

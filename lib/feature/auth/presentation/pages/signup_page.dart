import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignupPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;

  Future<void> _register() async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    final uid = credential.user!.uid;

    // ✅ Tạo document mới trong Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': emailCtrl.text.trim(),
      'name': 'Người dùng mới', // hoặc để trống nếu bạn có form nhập tên riêng
      'role': 'User', // mặc định
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo tài khoản thành công!')),
      );
      //context.go('/login'); // hoặc Navigator.pushNamed(context, '/login');
    }
  } on FirebaseAuthException catch (e) {
    setState(() => error = e.message);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text("Create Account")),
          ],
        ),
      ),
    );
  }
}

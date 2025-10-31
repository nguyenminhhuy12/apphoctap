import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthDataSource implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._firebaseAuth, this._firestore);

  // ---------------- Đăng nhập ----------------
  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      // 🔥 Lấy role và lưu local
      final role = await getUserRole(user.uid);
      if (role != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', role);
        print("✅ Role '$role' đã được lưu vào SharedPreferences");
      }
    }

    return _userFromFirebase(user);
  }

  // ---------------- Đăng ký ----------------
  @override
  Future<UserEntity?> signUp(String email, String password) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(cred.user);
  }

  // ---------------- Đăng xuất ----------------
  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role'); // ❌ Xóa role khi đăng xuất
    await _firebaseAuth.signOut();
  }

  // ---------------- Stream người dùng ----------------
  @override
  Stream<UserEntity?> get user =>
      _firebaseAuth.authStateChanges().map(_userFromFirebase);

  // ---------------- Lấy vai trò người dùng ----------------
  @override
  Future<String?> getUserRole(String uid) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        print("❌ Không tìm thấy tài liệu người dùng cho UID: $uid");
        return null;
      }

      final data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('role')) {
        print("⚠️ Tài liệu không có trường 'role' cho UID: $uid");
        return null;
      }

      final role = data['role'];
      print("✅ Vai trò người dùng UID=$uid là: $role");
      return role;
    } catch (e) {
      print("🔥 Lỗi khi lấy role người dùng: ${e.toString()}");
      return null;
    }
  }

  // ---------------- Chuyển FirebaseUser → UserEntity ----------------
  UserEntity? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserEntity(uid: user.uid, email: user.email);
  }
}

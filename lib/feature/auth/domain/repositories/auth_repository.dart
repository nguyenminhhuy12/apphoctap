import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String email, String password);
  Future<void> signOut();
  Stream<UserEntity?> get user;
  Future<String?> getUserRole(String uid); // Thêm phương thức lấy vai trò người dùng
}

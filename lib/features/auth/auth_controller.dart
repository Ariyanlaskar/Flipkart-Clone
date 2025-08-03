import 'package:flipkart_clone/features/auth/data/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repo.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, User?>((
  ref,
) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo).._init();
});

class AuthController extends StateNotifier<User?> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(null);

  void _init() {
    _repo.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<User?> signUp(String email, String password, String fullName) async {
    final user = await _repo.signUp(email, password, fullName);
    state = user;
    return user;
  }

  Future<User?> login(String email, String password) async {
    final user = await _repo.login(email, password);
    state = user;
    return user;
  }

  Future<User?> signInWithGoogle() async {
    final user = await _repo.signInWithGoogle();
    state = user;
    return user;
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = null;
  }
}

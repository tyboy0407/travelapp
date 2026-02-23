class AuthController {
  Future<bool> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return email.isNotEmpty && password.length >= 6;
  }
}



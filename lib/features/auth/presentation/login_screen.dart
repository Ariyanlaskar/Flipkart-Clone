import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/features/auth/domain/auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  // void _login() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => _isLoading = true);

  //   final authController = ref.read(authControllerProvider);

  //   try {
  //     final user = await authController.login(
  //       _emailController.text.trim(),
  //       _passController.text.trim(),
  //     );
  //     if (user != null && mounted) {
  //       Navigator.pushReplacementNamed(context, '/noteslist_screen');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // if (mounted) {
  //     //   ScaffoldMessenger.of(
  //     //     context,
  //     //   ).showSnackBar(SnackBar(content: Text(e.toString())));
  //     // }
  //     Fluttertoast.showToast(msg: "${e.code.toString()}");
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    if (user != null) {
      // This triggers auto redirect (because main.dart watches this state)
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/homescreen');
      });
    }
    print("login page built");
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/flipkart_logo.png', height: 32),
            const SizedBox(width: 8),
            const Text(
              'Flipkart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide ? constraints.maxWidth * 0.25 : 24.0;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2874F0),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Enter your email";
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: "Password",
                        icon: Icons.lock_outline,
                        controller: _passController,
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "Enter password";
                          if (val.length < 6)
                            return "Minimum 6 characters required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, // Add forgot password logic here
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate())
                                    return;

                                  setState(() => _isLoading = true);

                                  final user = await ref
                                      .read(authControllerProvider.notifier)
                                      .login(
                                        _emailController.text.trim(),
                                        _passController.text.trim(),
                                      );

                                  setState(() => _isLoading = false);

                                  if (user == null) {
                                    Fluttertoast.showToast(
                                      msg: "Login failed!",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                  // ✅ No need for Navigator here, it's handled by authStateChanges!
                                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              253,
                              253,
                              253,
                            ),
                            backgroundColor: const Color(0xFF2874F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("OR"),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () async {
                          setState(() => _isLoading = true);

                          final user = await ref
                              .read(authControllerProvider.notifier)
                              .signInWithGoogle();

                          setState(() => _isLoading = false);

                          if (user == null) {
                            Fluttertoast.showToast(
                              msg: "Google sign-in failed!",
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        icon: Image.asset(
                          'assets/images/g_logo.png',
                          height: 20,
                        ),
                        label: const Text("Login with Google"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: Color(0xFF2874F0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF2874F0), width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }
}

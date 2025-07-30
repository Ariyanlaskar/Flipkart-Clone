import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/features/auth/domain/auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;

  // void _signup() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => _isLoading = true);

  //   final authController = ref.read(authControllerProvider);

  //   try {
  //     final user = await authController.signUp(
  //       _emailController.text.trim(),
  //       _passController.text.trim(),
  //     );
  //     if (user != null && mounted) {
  //       Fluttertoast.showToast(
  //         msg: "Login successful! 🎉",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //       await Future.delayed(Duration(milliseconds: 500));
  //       Navigator.pushReplacementNamed(context, '/homescreen');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: "${e.code}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //       ;
  //     }
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  // void _handleGoogleSignIn() async {
  //   setState(() => _isLoading = true);

  //   final authController = ref.read(authControllerProvider);

  //   try {
  //     final user = await authController.signInWithGoogle();
  //     if (user != null && mounted) {
  //       Navigator.pushReplacementNamed(context, '/noteslist_screen');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Google Sign-In failed: $e")));
  //     }
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    if (user != null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/homescreen');
      });
    }
    print("signup page built");
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/flipkart_logo.png', // Ensure this image exists
              height: 32,
            ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2874F0),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: "Full Name",
                        icon: Icons.person_outline,
                        controller: _usernameController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Enter your name"
                            : null,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 24),
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
                                      .signUp(
                                        _emailController.text.trim(),
                                        _passController.text.trim(),
                                        _usernameController.text.trim(),
                                      );

                                  setState(() => _isLoading = false);

                                  if (user == null) {
                                    Fluttertoast.showToast(
                                      msg: "Signup failed!",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                  // ✅ No need for Navigator, auto-redirect is handled above
                                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
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
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2874F0),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        "OR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            'assets/images/g_logo.png', // ✅ add this asset to your project
                            height: 24,
                          ),
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
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
                                  // ✅ No manual navigator needed
                                },
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await user?.updateDisplayName(_nameController.text.trim());
      await user?.reload(); // Refresh user data

      Fluttertoast.showToast(msg: "Profile updated");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final spacing = isTablet ? 24.0 : 16.0;
    final inputFontSize = isTablet ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: spacing * 2),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    style: TextStyle(fontSize: inputFontSize),
                  ),
                  SizedBox(height: spacing),
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email (read-only)",
                    ),
                    style: TextStyle(fontSize: inputFontSize),
                  ),
                  SizedBox(height: spacing * 2),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: spacing * 3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

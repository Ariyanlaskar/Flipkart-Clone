import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/routes/app_routes.dart';
import 'package:flipkart_clone/widget/moder_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ModernAlertDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        onConfirm: () async {
          Navigator.of(context).pop(); // Close dialog
          await FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: "Logged out");
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (_) => false,
          );

          // ✅ Navigate to login screen & clear stack
          // if (context.mounted) {
          //   Navigator.pushNamedAndRemoveUntil(
          //     context,
          //     AppRoutes.login, // your login route
          //     (route) => false,
          //   );
          // }
        },
      ),
    );
  }

  Widget _buildResponsiveTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double iconSize,
    required double fontSize,
    required double spacing,
  }) {
    return ListTile(
      leading: Icon(icon, size: iconSize),
      title: Text(title, style: TextStyle(fontSize: fontSize)),
      trailing: Icon(Icons.arrow_forward_ios, size: iconSize * 0.6),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: spacing * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    final avatarRadius = isTablet ? 40.0 : 30.0;
    final iconSize = isTablet ? 30.0 : 24.0;
    final fontSize = isTablet ? 18.0 : 16.0;
    final spacing = isTablet ? 20.0 : 12.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(spacing * 1.5),
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          Icons.person,
                          size: avatarRadius,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Guest User',
                              style: TextStyle(
                                fontSize: fontSize + 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: fontSize - 2,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.editProfile,
                          );
                          await _loadUser(); // Reload user after editing
                        },
                        child: const Text("Edit"),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _buildResponsiveTile(
                  icon: Icons.shopping_bag,
                  title: 'My Orders',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.orders);
                  },
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
                _buildResponsiveTile(
                  icon: Icons.favorite,
                  title: 'Wishlist',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.wishlist);
                  },
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
                _buildResponsiveTile(
                  icon: Icons.location_on,
                  title: 'Saved Addresses',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addresses);
                  },
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
                _buildResponsiveTile(
                  icon: Icons.support_agent,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.support);
                  },
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
                _buildResponsiveTile(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.about);
                  },
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
                _buildResponsiveTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _showLogoutDialog(context),
                  iconSize: iconSize,
                  fontSize: fontSize,
                  spacing: spacing,
                ),
              ],
            ),
    );
  }
}

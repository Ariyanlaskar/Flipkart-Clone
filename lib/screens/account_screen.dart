import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flipkart_clone/routes/app_routes.dart';

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
    await FirebaseAuth.instance.currentUser?.reload();
    if (mounted) {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final avatarCollapsed = isTablet ? 26.0 : 22.0;
    final tileIconSize = isTablet ? 26.0 : 22.0;
    final fontSize = isTablet ? 17.0 : 15.0;
    final spacing = isTablet ? 16.0 : 12.0;
    final expandedHeight = isTablet ? 160.0 : 128.0;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final photoUrl = user!.photoURL;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            expandedHeight: expandedHeight,
            backgroundColor: Colors.blue,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxHeight <= kToolbarHeight + 20;
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  titlePadding: EdgeInsetsDirectional.only(
                    start: collapsed ? (isTablet ? 64 : 56) : spacing,
                    bottom: collapsed ? 12 : spacing,
                    end: spacing,
                  ),
                  title: collapsed
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: avatarCollapsed,
                              backgroundColor: Colors.white,
                              backgroundImage: photoUrl != null
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: photoUrl == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: avatarCollapsed,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user!.displayName?.trim().isNotEmpty == true
                                    ? user!.displayName!
                                    : 'Account',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade500, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.all(spacing),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: isTablet ? 32 : 28,
                                backgroundColor: Colors.white,
                                backgroundImage: photoUrl != null
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl == null
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                        size: isTablet ? 32 : 28,
                                      )
                                    : null,
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user!.displayName?.trim().isNotEmpty ==
                                              true
                                          ? user!.displayName!
                                          : 'Guest User',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user!.email ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.tonal(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    AppRoutes.editProfile,
                                  );
                                  await _loadUser();
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(spacing, spacing, spacing, 6),
              child: Row(
                children: [
                  _QuickChip(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Orders',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
                  ),
                  const SizedBox(width: 8),
                  _QuickChip(
                    icon: Icons.favorite_border,
                    label: 'Wishlist',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.wishlist),
                  ),
                  const SizedBox(width: 8),
                  _QuickChip(
                    icon: Icons.location_on_outlined,
                    label: 'Addresses',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.addresses),
                  ),
                ],
              ),
            ),
          ),

          // Tiles
          SliverList.list(
            children: [
              _AccountTile(
                icon: Icons.shopping_bag,
                title: 'My Orders',
                onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
                iconSize: tileIconSize,
                fontSize: fontSize,
                spacing: spacing,
              ),
              _AccountTile(
                icon: Icons.favorite,
                title: 'Wishlist',
                onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                iconSize: tileIconSize,
                fontSize: fontSize,
                spacing: spacing,
              ),
              _AccountTile(
                icon: Icons.location_on,
                title: 'Saved Addresses',
                onTap: () => Navigator.pushNamed(context, AppRoutes.addresses),
                iconSize: tileIconSize,
                fontSize: fontSize,
                spacing: spacing,
              ),
              _AccountTile(
                icon: Icons.support_agent,
                title: 'Help & Support',
                onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                iconSize: tileIconSize,
                fontSize: fontSize,
                spacing: spacing,
              ),
              _AccountTile(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                iconSize: tileIconSize,
                fontSize: fontSize,
                spacing: spacing,
              ),
              Padding(
                padding: EdgeInsets.all(spacing * 1.5),
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
              SizedBox(height: spacing),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double spacing;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing * 1.2, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(icon, size: iconSize, color: Colors.blue),
            title: Text(
              title,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing,
              vertical: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 18),
      label: Text(label),
      shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
      backgroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }
}

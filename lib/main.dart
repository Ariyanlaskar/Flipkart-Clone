import 'package:firebase_core/firebase_core.dart';
import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/firebase_options.dart';
import 'package:flipkart_clone/screens/address_screen.dart';
import 'package:flipkart_clone/screens/about_screen.dart';
import 'package:flipkart_clone/screens/order_screen.dart';
import 'package:flipkart_clone/routes/app_routes.dart';
import 'package:flipkart_clone/screens/auth/login_screen.dart';
import 'package:flipkart_clone/screens/auth/signup_screen.dart';
import 'package:flipkart_clone/screens/edit_profile_screen.dart';
import 'package:flipkart_clone/screens/home/bottom_nav_screen.dart';
import 'package:flipkart_clone/screens/splash_screen.dart';
import 'package:flipkart_clone/screens/support_screen.dart';
import 'package:flipkart_clone/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 237, 237, 237),
      ),
      routes: {
        AppRoutes.signUp: (context) => const SignupScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.home: (context) => const BottomNavScreen(),
        AppRoutes.editProfile: (context) => const EditProfileScreen(),
        AppRoutes.orders: (context) => const OrdersScreen(),
        AppRoutes.wishlist: (context) => WishlistScreen(),
        AppRoutes.addresses: (context) => const AddressScreen(),
        AppRoutes.support: (context) => const HelpSupportScreen(),
        AppRoutes.about: (context) => const AboutUsScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text("Route not found"))),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splash = ref.watch(splashControllerProvider);

    return splash.when(
      loading: () => const SplashScreen(),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (_) {
        final auth = ref.watch(authStateProvider);

        return auth.when(
          data: (user) {
            if (user != null) {
              return const BottomNavScreen();
            } else {
              return const LoginScreen();
            }
          },
          loading: () => const SplashScreen(),
          error: (e, _) =>
              Scaffold(body: Center(child: Text('Auth error: $e'))),
        );
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flipkart_clone/controller/product_provider.dart';

import 'package:flipkart_clone/screens/bottom_nav_screen.dart';

import 'package:flipkart_clone/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 237, 237, 237),
      ),
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) =>
            user != null ? const BottomNavScreen() : const LoginScreen(),

        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}

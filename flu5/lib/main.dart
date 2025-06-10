import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'User Auth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder<bool>(
                future: _checkAuth(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(body: Center(child: CircularProgressIndicator()));
                  }
                  return snapshot.data! ? HomeScreen() : AuthScreen();
                },
              ),
          '/auth': (context) => AuthScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }

  Future<bool> _checkAuth(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    return await authService.getUser() != null;
  }
}
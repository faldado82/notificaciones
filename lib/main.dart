import 'package:flutter/material.dart';
import 'package:notificaciones/screens/screens.dart';
import 'package:notificaciones/services/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // Context
    PushNotificationService.messagesStream.listen((message) {
      print('My App: $message');
      // Navigator.pushNamed(context, 'message');
      navigationKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigationKey, // Navegar
      scaffoldMessengerKey: messengerKey, // Mostrar snacks
      routes: {
        'home': (_) => const HomeScreen(),
        'message': (_) => const MessageScreen(),
      },
    );
  }
}

// SHA-1: 91:2A:34:E2:2B:7A:EA:86:9D:3E:7F:51:CA:2D:4C:99:80:F4:EF:66

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStreamController =
      StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    print(message.data);
    // agregamos el evento al stream
    _messageStreamController.add(message.data['producto'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler ${message.messageId}');
    print(message.data);
    _messageStreamController.add(message.data['producto'] ?? 'No data');
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');
    print(message.data);
    _messageStreamController.add(message.data['producto'] ?? 'No data');
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('TOKEN: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    // hemos creado una suscripción al stream utilizando el método listen(), que imprimirá los eventos recibidos.
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);

    // Local Notifications
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

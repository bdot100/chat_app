import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';

class FirebaseMessenger {
  final String deviceToken;
  final String serviceAccountPath; // Path to JSON file
  late ServiceAccountCredentials credentials;

  FirebaseMessenger({
    required this.deviceToken,
    required this.serviceAccountPath,
  });

  Future<void> loadCredentials() async {
    final serviceAccountJson = await rootBundle.loadString(serviceAccountPath);
    credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
  }

  Future<String?> getAccessToken() async {
    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(credentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }

  Future<void> sendNotification(
      String title, String body, Map<String, String> customData) async {
    await loadCredentials();
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      log('Failed to get access token');
      return;
    }

    final projectId = 'chat-app-6c0b0';
    final url =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': title,
          'body': body,
          "android_channel_id": "chats",
        },
        'data': customData,
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      log('✅ FCM message sent: ${response.body}');
    } else {
      log('❌ Error sending FCM message: ${response.statusCode}, ${response.body}');
    }
  }
}

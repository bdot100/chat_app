import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // getter method to get the current user for us
  static User get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        isOnline: false,
        pushToken: "",
        createdAt: time,
        image: user.photoURL.toString(),
        email: user.email.toString(),
        about: "Hey I am using the chat app",
        lastActive: time,
        name: user.displayName.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}

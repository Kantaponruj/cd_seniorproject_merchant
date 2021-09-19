import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const GOOGLE_MAPS_API_KEY = "AIzaSyCZ7E5m7NK51FUloIHQo_3ay73cq0PcVCk";

// Firebase
final Future<FirebaseApp> initialization = Firebase.initializeApp();

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseMessaging fcm = FirebaseMessaging.instance;

bool isConfirmed = true;
bool isDelivery = false;


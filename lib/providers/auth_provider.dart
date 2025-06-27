import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _user;
  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isPremium => _user?.isPremium ?? false;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String healthGoal,
    required int age,
    required String gender,
    double weight = 70,
    double height = 170,
    String profileImageUrl = '',
  }) async {
    final UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final userData = AppUser(
      uid: uid,
      name: name,
      email: email,
      healthGoal: healthGoal,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      profileImageUrl: profileImageUrl,
    );
    await _firestore.collection('users').doc(uid).set(userData.toMap());
    _user = userData;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    _user = AppUser.fromMap(doc.data()!, uid);
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        _user = AppUser.fromMap(doc.data()!, currentUser.uid);
        notifyListeners();
      }
    }
  }

  Future<void> updateHealthMetrics({
    required double weight,
    required double height,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'weight': weight,
        'height': height,
      });
      _user = _user?.copyWith(weight: weight, height: height);
      notifyListeners();
    }
  }

  Future<void> updateUserInfo({
    required String name,
    required String email,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': name,
        'email': email,
      });
      _user = _user?.copyWith(name: name, email: email);
      notifyListeners();
    }
  }

  Future<void> updateHealthGoal(String healthGoal) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'healthGoal': healthGoal,
      });
      _user = _user?.copyWith(healthGoal: healthGoal);
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'profileImageUrl': imageUrl,
      });
      _user = _user?.copyWith(profileImageUrl: imageUrl);
      notifyListeners();
    }
  }

  Future<void> updateAge(int age) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'age': age,
      });
      _user = _user?.copyWith(age: age);
      notifyListeners();
    }
  }

  Future<void> upgradeToPremium() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'isPremium': true,
      });
      _user = _user?.copyWith(isPremium: true);
      notifyListeners();
    }
  }
}

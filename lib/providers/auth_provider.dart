import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/input_validator.dart';

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
    // Input validation
    if (!InputValidator.isValidName(name)) {
      throw Exception('Invalid name format');
    }
    if (!InputValidator.isValidEmail(email)) {
      throw Exception('Invalid email format');
    }
    if (!InputValidator.isValidPassword(password)) {
      throw Exception(
        'Password must be at least 6 characters with letters and numbers',
      );
    }
    if (!InputValidator.isValidAge(age)) {
      throw Exception('Invalid age');
    }

    // Sanitize inputs
    final sanitizedName = InputValidator.sanitizeString(name);
    final sanitizedEmail = InputValidator.sanitizeEmail(email);

    final UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: sanitizedEmail,
      password: password,
    );
    final user = cred.user;
    if (user == null) {
      throw Exception('User not found after registration');
    }
    final uid = user.uid;
    final userData = AppUser(
      uid: uid,
      name: sanitizedName,
      email: sanitizedEmail,
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
    // Input validation
    if (!InputValidator.isValidEmail(email)) {
      throw Exception('Invalid email format');
    }
    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    // Sanitize email
    final sanitizedEmail = InputValidator.sanitizeEmail(email);

    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: sanitizedEmail,
      password: password,
    );
    final user = cred.user;
    if (user == null) {
      throw Exception('User not found after login');
    }
    final uid = user.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) {
      throw Exception('User data not found in Firestore');
    }
    _user = AppUser.fromMap(data, uid);
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
        final data = doc.data();
        if (data != null) {
          _user = AppUser.fromMap(data, currentUser.uid);
          notifyListeners();
        }
      }
    }
  }

  Future<void> updateHealthMetrics({
    required double weight,
    required double height,
  }) async {
    // Input validation
    if (!InputValidator.isValidWeight(weight)) {
      throw Exception('Invalid weight value');
    }
    if (!InputValidator.isValidHeight(height)) {
      throw Exception('Invalid height value');
    }

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

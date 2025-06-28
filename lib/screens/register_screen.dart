import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_nav_screen.dart';
import '../utils/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String healthGoal = '';
  int age = 0;
  String gender = '';
  final List<String> healthGoals = [
    'Lose Weight',
    'Build Muscle',
    'Maintain Weight',
    'Eat Healthier',
    'Increase Energy',
  ];
  final List<String> genders = ['Male', 'Female', 'Other'];
  bool isLoading = false;
  String? error;

  void _register(BuildContext context) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate())
      return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        name: name,
        email: email,
        password: password,
        healthGoal: healthGoal,
        age: age,
        gender: gender,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
        (route) => false,
      );
    } catch (e, stack) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Register', style: TextStyle(color: colors.heading)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: colors.background,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                  style: TextStyle(color: colors.bodyText),
                  onChanged: (v) => name = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: colors.background,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                  style: TextStyle(color: colors.bodyText),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => email = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: colors.background,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                  style: TextStyle(color: colors.bodyText),
                  obscureText: true,
                  onChanged: (v) => password = v,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Health Goal'),
                  value: healthGoal.isNotEmpty ? healthGoal : null,
                  items: healthGoals
                      .map(
                        (goal) =>
                            DropdownMenuItem(value: goal, child: Text(goal)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => healthGoal = v ?? ''),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Select health goal' : null,
                  dropdownColor: colors.card,
                  style: TextStyle(color: colors.bodyText),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    fillColor: colors.background,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                  style: TextStyle(color: colors.bodyText),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => age = int.tryParse(v) ?? 0,
                  validator: (v) =>
                      v == null || int.tryParse(v) == null || int.parse(v) <= 0
                      ? 'Enter valid age'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Gender'),
                  value: gender.isNotEmpty ? gender : null,
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => gender = v ?? ''),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Select gender' : null,
                  dropdownColor: colors.card,
                  style: TextStyle(color: colors.bodyText),
                ),
                const SizedBox(height: 16),
                if (error != null) ...[
                  Text(error!, style: TextStyle(color: colors.error)),
                  const SizedBox(height: 8),
                ],
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Register'),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: colors.accent),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

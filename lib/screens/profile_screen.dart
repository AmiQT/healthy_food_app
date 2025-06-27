import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/app_colors.dart';
import '../widgets/shimmer_loader.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> healthGoals = [
    'Lose Weight',
    'Build Muscle',
    'Maintain Weight',
    'Eat Healthier',
    'Increase Energy',
  ];

  void _showEditHealthDialog(
    BuildContext context,
    double currentWeight,
    double currentHeight,
  ) {
    final colors = AppColors.of(context);
    final weightController = TextEditingController(
      text: currentWeight.toStringAsFixed(1),
    );
    final heightController = TextEditingController(
      text: currentHeight.toStringAsFixed(1),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Health Metrics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final weight =
                  double.tryParse(weightController.text) ?? currentWeight;
              final height =
                  double.tryParse(heightController.text) ?? currentHeight;
              Provider.of<AuthProvider>(
                context,
                listen: false,
              ).updateHealthMetrics(weight: weight, height: height);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(colors.accent),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: WidgetStateProperty.all<double>(2),
              shadowColor: WidgetStateProperty.all<Color?>(colors.buttonShadow),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)) {
                  return colors.buttonHover;
                }
                return null;
              }),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditUserInfoDialog(
    BuildContext context,
    String currentName,
    String currentEmail,
  ) {
    final colors = AppColors.of(context);
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              Provider.of<AuthProvider>(
                context,
                listen: false,
              ).updateUserInfo(name: name, email: email);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(colors.accent),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: WidgetStateProperty.all<double>(2),
              shadowColor: WidgetStateProperty.all<Color?>(colors.buttonShadow),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)) {
                  return colors.buttonHover;
                }
                return null;
              }),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAgeDialog(BuildContext context, int currentAge) {
    final colors = AppColors.of(context);
    final ageController = TextEditingController(text: currentAge.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Age'),
        content: TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Age'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final age = int.tryParse(ageController.text) ?? currentAge;
              Provider.of<AuthProvider>(context, listen: false).updateAge(age);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(colors.accent),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: WidgetStateProperty.all<double>(2),
              shadowColor: WidgetStateProperty.all<Color?>(colors.buttonShadow),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)) {
                  return colors.buttonHover;
                }
                return null;
              }),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditHealthGoalDialog(BuildContext context, String currentGoal) {
    final colors = AppColors.of(context);
    String selectedGoal = currentGoal;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Health Goal'),
        content: StatefulBuilder(
          builder: (context, setState) => DropdownButton<String>(
            value: selectedGoal.isNotEmpty ? selectedGoal : healthGoals[0],
            items: healthGoals
                .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                .toList(),
            onChanged: (v) =>
                setState(() => selectedGoal = v ?? healthGoals[0]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(
                context,
                listen: false,
              ).updateHealthGoal(selectedGoal);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(colors.accent),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: WidgetStateProperty.all<double>(2),
              shadowColor: WidgetStateProperty.all<Color?>(colors.buttonShadow),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)) {
                  return colors.buttonHover;
                }
                return null;
              }),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndSaveImageLocally(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
        ],
      ),
    );
    if (source == null) return;
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localImage = File('${directory.path}/$fileName');
      await localImage.writeAsBytes(await picked.readAsBytes());
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).updateProfileImage(localImage.path);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile picture updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final user = Provider.of<AuthProvider>(context).user;
    final authProvider = Provider.of<AuthProvider>(context);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user info.')));
    }
    double bmi = user.weight / ((user.height / 100) * (user.height / 100));
    int calories = 2000; // Placeholder

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Profile', style: TextStyle(color: colors.heading)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: user.profileImageUrl.isNotEmpty
                      ? FileImage(File(user.profileImageUrl))
                      : null,
                  child: user.profileImageUrl.isEmpty
                      ? Icon(Icons.person, size: 48)
                      : null,
                ),
                if (authProvider.isPremium)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => _pickAndSaveImageLocally(context),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                user.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditUserInfoDialog(context, user.name, user.email);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: const Text('Health Goals'),
              subtitle: Text(user.healthGoal),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditHealthGoalDialog(context, user.healthGoal);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: const Text('Personal Info'),
              subtitle: Text('Age: ${user.age}\nGender: ${user.gender}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditAgeDialog(context, user.age);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colors.card,
            elevation: 4,
            shadowColor: colors.cardShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart,
                        color: Colors.green,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Health Summary',
                        style: TextStyle(
                          color: colors.heading,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit, color: colors.heading),
                        onPressed: () {
                          _showEditHealthDialog(
                            context,
                            user.weight,
                            user.height,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.fitness_center, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Text(
                        'Weight: ${user.weight.toStringAsFixed(1)} kg',
                        style: TextStyle(color: colors.bodyText, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.height, color: Colors.deepPurple),
                      const SizedBox(width: 6),
                      Text(
                        'Height: ${user.height.toStringAsFixed(1)} cm',
                        style: TextStyle(color: colors.bodyText, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // BMI Health Progress Bar
                  Builder(
                    builder: (context) {
                      String bmiCategory;
                      Color barColor;
                      if (bmi < 18.5) {
                        bmiCategory = 'Underweight';
                        barColor = Colors.blue;
                      } else if (bmi < 25) {
                        bmiCategory = 'Normal';
                        barColor = Colors.green;
                      } else if (bmi < 30) {
                        bmiCategory = 'Overweight';
                        barColor = Colors.orange;
                      } else {
                        bmiCategory = 'Obese';
                        barColor = Colors.red;
                      }
                      // Normalize BMI for progress bar: 15 (0.0) to 40 (1.0)
                      double progress = ((bmi - 15) / (40 - 15)).clamp(
                        0.0,
                        1.0,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calculate, color: Colors.orange),
                              const SizedBox(width: 6),
                              Text(
                                'BMI: ${bmi.toStringAsFixed(1)} ($bmiCategory)',
                                style: TextStyle(
                                  color: barColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: Colors.grey[200],
                            color: barColor,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Calories: $calories kcal',
                        style: TextStyle(color: colors.bodyText, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!authProvider.isPremium)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.emoji_events),
                label: const Text('Upgrade to Premium Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId:
                            "Ae69mgVugxo27MW84Ch66CrNRK_42LF7-sv_TzkdGp7UvXUU65kBpV2ugtdOKMDdf-nsqXo2TnYNioqb",
                        secretKey:
                            "EG9oLYve7X4U6Wa6DZiQ4qSCcljc5v0iXbur_-K_k6s4iAIyIaHD0-5gG-QqBfMdmgre7gB15il1N7JE",
                        returnURL: "https://example.com/return",
                        cancelURL: "https://example.com/cancel",
                        transactions: [
                          {
                            "amount": {
                              "total": '9.99',
                              "currency": "USD",
                              "details": {
                                "subtotal": '9.99',
                                "shipping": '0',
                                "shipping_discount": 0,
                              },
                            },
                            "description": "Premium Account Upgrade",
                          },
                        ],
                        note: "Contact us for any questions on your upgrade.",
                        onSuccess: (Map params) async {
                          await authProvider.upgradeToPremium();
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Congratulations!'),
                                content: const Text(
                                  'You are now a Premium member!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                          Navigator.pop(context); // Close PayPal screen
                        },
                        onError: (error) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Payment Error'),
                              content: Text('An error occurred: \n$error'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        onCancel: (params) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Payment Cancelled'),
                              content: const Text('The payment was cancelled.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

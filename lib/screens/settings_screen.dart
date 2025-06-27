import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final colors = AppColors.of(context);
    bool notificationsEnabled = true; // Placeholder, can be made persistent
    bool isMetric = true; // Placeholder, can be made persistent
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Settings', style: TextStyle(color: colors.heading)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'General',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blueGrey),
            title: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.green),
            title: const Text('Health Goal', style: TextStyle(fontSize: 18)),
            subtitle: Text(authProvider.user?.healthGoal ?? '-'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: colors.accent,
            ),
            title: const Text('Dark Mode', style: TextStyle(fontSize: 18)),
            trailing: Switch.adaptive(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (val) {
                themeProvider.toggleTheme();
              },
              activeColor: colors.accent,
            ),
          ),
          const Divider(),
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.notifications_active,
              color: Colors.deepOrange,
            ),
            title: const Text('Notifications', style: TextStyle(fontSize: 18)),
            trailing: Switch.adaptive(
              value: notificationsEnabled,
              onChanged: (val) {}, // TODO: persist
              activeColor: colors.accent,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.straighten, color: Colors.purple),
            title: const Text('Units', style: TextStyle(fontSize: 18)),
            subtitle: Text(isMetric ? 'Metric (kg, cm)' : 'Imperial (lb, in)'),
            trailing: Switch.adaptive(
              value: isMetric,
              onChanged: (val) {}, // TODO: persist
              activeColor: colors.accent,
            ),
          ),
          const Divider(),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
            title: const Text('App Info', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Healthy Meal App v1.0.0'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              elevation: WidgetStateProperty.all<double>(4),
              shadowColor: WidgetStateProperty.all<Color?>(colors.buttonShadow),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)) {
                  return colors.buttonHover;
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

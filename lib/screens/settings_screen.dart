import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAccountSection(),
            const SizedBox(height: 16),
            _buildPreferencesSection(),
            const SizedBox(height: 16),
            _buildSupportSection(),
            const SizedBox(height: 16),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader('Account'),
          _buildMenuItem(
            icon: Icons.person,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.email,
            title: 'Email Preferences',
            subtitle: 'Manage email notifications',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader('Preferences'),
          _buildSwitchItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: true,
            onChanged: (value) {},
          ),
          _buildDivider(),
          _buildSwitchItem(
            icon: Icons.location_on,
            title: 'Location Services',
            subtitle: 'Allow location access',
            value: false,
            onChanged: (value) {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.currency_exchange,
            title: 'Currency',
            subtitle: 'USD (\$)',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader('Support'),
          _buildMenuItem(
            icon: Icons.help,
            title: 'Help Center',
            subtitle: 'Get help and find answers',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.support_agent,
            title: 'Contact Support',
            subtitle: 'Get in touch with our team',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts with us',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.rate_review,
            title: 'Rate App',
            subtitle: 'Rate us on the app store',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader('About'),
          _buildMenuItem(
            icon: Icons.info,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () {
              _showLogoutDialog();
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppTheme.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : AppTheme.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondaryColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondaryColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Perform logout logic here
              Get.snackbar(
                'Logged Out',
                'You have been successfully logged out',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.successColor,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 
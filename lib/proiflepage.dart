import 'dart:convert';

import 'package:beyondfantasy/api.dart';
import 'package:beyondfantasy/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found. Please login again.');
      }

      final response = await http.get(
        Uri.parse(ApiConstants.profileEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userData = data['user'] ?? data;
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        await prefs.remove('auth_token');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Session expired. Please login again.')),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Failed to load profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    if (confirmed == true && mounted) {
      _performLogout();
    }
  }

  Future<void> _performLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse(ApiConstants.logoutEndPoint), // ← your logout endpoint
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      await prefs.remove('auth_token');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFDB515)))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB515),
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color(0xFFFDB515).withOpacity(0.3),
                        child: Text(
                          _userData!['name']?[0].toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 50,
                            color: Color(0xFFFDB515),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // User Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A3D),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'ID', _userData!['id']?.toString() ?? 'N/A'),
                            const Divider(color: Colors.white24, height: 32),
                            _buildInfoRow('Name', _userData!['name'] ?? 'N/A'),
                            const Divider(color: Colors.white24, height: 32),
                            _buildInfoRow(
                                'Email', _userData!['email'] ?? 'N/A'),
                            const Divider(color: Colors.white24, height: 32),
                            _buildInfoRow(
                              'Email Verified',
                              _userData!['email_verified_at'] != null
                                  ? 'Yes'
                                  : 'No',
                              color: _userData!['email_verified_at'] != null
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Logout Button
                      //   SizedBox(
                      //     width: double.infinity,
                      //     height: 60,
                      //     child: ElevatedButton.icon(
                      //       onPressed: _confirmLogout,
                      //       icon: const Icon(Icons.logout, color: Colors.black87),
                      //       label: const Text(
                      //         'Logout',
                      //         style: TextStyle(
                      //             fontSize: 18, fontWeight: FontWeight.bold),
                      //       ),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: const Color(0xFFFDB515),
                      //         foregroundColor: Colors.black87,
                      //         padding: const EdgeInsets.symmetric(vertical: 16),
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(30)),
                      //         elevation: 4,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

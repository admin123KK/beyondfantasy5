import 'package:beyondfantasy/loginpage.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003262), // Dark blue background
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              // White rounded card at bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Register Now title
                      const Text(
                        "Register Now",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create new Account to Register",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email field
                      const TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "enter your email address",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Contract No (Contact number)
                      const TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Contract No",
                          hintText: "enter your contract number",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Address
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Address",
                          hintText: "address",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Password with visibility toggle
                      TextField(
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          hintText: "enter your password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "confirm your password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB515), // Yellow
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Not Register Yet? Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Not Register Yet? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text('Login',
                                style: TextStyle(
                                  color: Color(0xFFFDB515),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // OR separator
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

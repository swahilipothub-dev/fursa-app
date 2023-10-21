import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/features/auth/controller/auth_controller.dart';
import 'package:fursaapp/features/auth/screens/login_screen.dart';
import 'package:fursaapp/widgets/custom_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isTermsAccepted = false; // Track whether the terms are accepted or not

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70.0), // Empty space for logo

                // Logo widget
                const Image(
                  image: AssetImage('assets/fursa.png'),
                  height: 150,
                  width: 150,
                ),

                const SizedBox(height: 40.0),

                // First name input field
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'eg. John',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First name is required';
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // Last name input field
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'eg. Doe',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last name is required';
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // Phone input field
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'eg. 0712345678',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length < 10) {
                      return "Enter a valid phone number";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // Email input field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // Password input field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return "Must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),

                const SizedBox(height: 10.0),

                // Terms and Conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isTermsAccepted,
                      onChanged: (value) {
                        setState(() {
                          isTermsAccepted = value!;
                        });
                      },
                    ),
                    const Text('I accept the Terms and Conditions'),
                  ],
                ),

                const SizedBox(height: 10.0),

                // Signup button
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!isTermsAccepted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Terms and Conditions'),
                            content: const Text('Please accept the Terms and Conditions'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: SizedBox(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      );
                      ref.watch(authControllerProvider.notifier).registerUser(
                        context: context,
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        phone: phoneController.text.trim(),
                        password: passwordController.text.trim(),
                        email: emailController.text.trim(),
                      );
                    }
                  },
                  buttonText: "Sign Up",
                  width: MediaQuery.of(context).size.width,
                  radius: 29,
                ),

                const SizedBox(height: 10.0),

                // Already have an account? Login link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: AppColors.primaryColor, // Upwork app's text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:final_project/home.dart';
import 'package:flutter/material.dart';
import 'package:final_project/api-service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final ApiServices apiService = ApiServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 231, 253, 232),
                  Color.fromARGB(255, 94, 169, 92)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 94, 169, 92).withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: _buildLoginForm(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fastfood,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 80,
          ),
          const SizedBox(height: 12),
          const Text(
            "Selamat Datang",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              labelText: "Username",
              hintText: "Masukkan username",
              prefixIcon: const Icon(Icons.person_outline,
                  color: Color.fromARGB(255, 94, 169, 92)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _isPasswordVisible,
            builder: (context, visible, _) {
              return TextField(
                controller: passwordController,
                obscureText: !visible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  labelText: "Kata Sandi",
                  hintText: "Masukkan kata sandi",
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: Color.fromARGB(255, 94, 169, 92)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Color.fromARGB(255, 94, 169, 92),
                    ),
                    onPressed: () =>
                        _isPasswordVisible.value = !_isPasswordVisible.value,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, loading, _) {
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 94, 169, 92),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          _isLoading.value = true;

                          try {
                            final result = await apiService.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            final token = result["token"];
                            final user = result["user"];

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login Berhasil ✅")),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePage(
                                  token: token,
                                  userId: user["id_user"],
                                  nama:
                                      user["nama"], // kalau homepage butuh nama
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            _isLoading.value = false;
                          }
                        },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Masuk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Lupa kata sandi?",
              style: TextStyle(
                color: Color.fromARGB(255, 94, 169, 92),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

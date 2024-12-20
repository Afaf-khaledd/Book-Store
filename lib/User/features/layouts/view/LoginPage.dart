import 'package:book_store/Admin/features/layouts/view/Dashboard.dart';
import 'package:book_store/User/features/layouts/view/MainNavPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../constant.dart';
import '../../../../core/SharedPreference.dart';
import '../../../../core/Validators.dart';
import '../manger/AuthCubit/auth_cubit.dart';
import 'LoadingIndicator.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool isAdmin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Fluttertoast.showToast(msg: state.message,backgroundColor: Colors.green);
        } else if (state is AuthError) {
          Fluttertoast.showToast(msg: state.error,backgroundColor: Colors.redAccent);
        }
        else if (state is AuthResetPasswordSuccess) {
          Fluttertoast.showToast(msg: "Password reset email sent", backgroundColor: Colors.orangeAccent);
        } else if (state is AuthResetPasswordError) {
          Fluttertoast.showToast(msg: state.error,backgroundColor: Colors.redAccent);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: mainGreenColor),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text("Login",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
            toolbarHeight: 80,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: mainGreenColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        labelStyle: const TextStyle(color: mainGreenColor,fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: const BorderSide(color: mainGreenColor, width: 2.0),
                        ),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: mainGreenColor,
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        labelStyle: const TextStyle(color: mainGreenColor,fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: const BorderSide(color: mainGreenColor, width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: mainGreenColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                                _toggleRememberMe(value!);
                              },
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            _resetPassword();
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: mainGreenColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const Center(child: NewLoadingIndicator())
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreenColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if(_emailController.text.compareTo("admin@store.com")==0 && _passwordController.text.compareTo("admin1")==0){
                              _isAdmin(true);
                              Navigator.pushReplacement(context, MaterialPageRoute<void>(
                                builder: (BuildContext context) => const DashboardPage(),
                              ),
                              );
                            }else{
                              _isAdmin(false);
                            Navigator.pushReplacement(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) => const MainNavPage(),
                            ),
                            );
                          }
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?",style: TextStyle(color:mainGreenColor,fontSize: 17,fontWeight: FontWeight.w400),),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute<void>(
                                builder: (BuildContext context) => const SignUp(),
                              ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: mainGreenColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleRememberMe(bool value) async {
    setState(() {
      _rememberMe = value;
    });
    await SharedPreference.instance.setRememberMe(value);
  }
  void _isAdmin(bool value) async {
    setState(() {
      isAdmin = value;
    });
    await SharedPreference.instance.setIsAdmin(value);
  }

  void _resetPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }
    context.read<AuthCubit>().resetPassword(email);
  }
}
import 'dart:io';

import 'package:fitness_workout_app/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theme/color/colors.dart';
import '../../domain/usecase/register_usecase.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? _selectedImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImagePickerSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Image",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final params = RegisterUserParameter(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        // phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        image: _selectedImage,
      );

      context.read<AuthBloc>().add(RegisterUserEvent(params));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(
            color: AppColors.text(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.icon(context)),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterUserSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered Successfully!")),
            );
            Navigator.pop(context);
          } else if (state is RegisterUserErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    // onTap: _pickImage,
                    onTap: () => _showImagePickerSheet(context),

                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.text(context),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(
                              Icons.camera_alt_outlined,
                              // color: AppColors.te(context),
                              color: isDark ? Colors.black : Colors.white,
                              size: 35,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildTextField(
                    controller: _nameController,
                    label: "Full Name",
                    keyboardType: TextInputType.name,
                    validatorMsg: "Please enter your name",
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validatorMsg: "Please enter your email",
                  ),
                  // const SizedBox(height: 15),
                  // _buildTextField(
                  //   controller: _phoneController,
                  //   label: "Phone",
                  //   keyboardType: TextInputType.phone,
                  //
                  //   //validatorMsg: "Please enter your phone number",
                  // ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    obscureText: _obscurePassword,
                    validatorMsg: "Please enter your password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.icon(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    obscureText: _obscureConfirmPassword,
                    validatorMsg: "Passwords do not match",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.icon(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  state is RegisterUserLoadingState
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(context),
                              foregroundColor: AppColors.buttonText(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMsg,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: AppColors.text(context)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.subText(context)),
        filled: true,
        fillColor: AppColors.card(context),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border(context)),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: (val) => val == null || val.isEmpty ? validatorMsg : null,
    );
  }
}

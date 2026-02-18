import 'dart:io';

import 'package:fitness_workout_app/features/auth/domain/usecase/update_user_profile_usecase.dart';
import 'package:fitness_workout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_workout_app/presentation/tab/profile_tab/update_user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theme/color/colors.dart';
import '../../../core/utils/api.dart';
import '../../../local_database/local_storage.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;
  int? _userId;
  Map<String, dynamic>? _userData;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await LocalStorage.getUserData();
    if (userData != null) {
      debugPrint("printUserdata : $userData");
      setState(() {
        _userData = userData;
        _userId = userData['id'];
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
      });
    }
  }

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

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      if (_userId == null || _userData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not loaded yet")),
        );
        return;
      }

      final params = UpdateUserProfileParams(
        userId: _userId!,
        name: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : _userData!['name'] ?? '',
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : _userData!['email'] ?? '',
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : _userData!['phone'] ?? '',
        imageUrl: _selectedImage?.path,
      );

      context.read<AuthBloc>().add(UpdateUserProfileEvent(params));
    }
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return "${Api.base}$path";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    if (_userId == null || _userData == null) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is UpdateUserProfileSuccessState) {
          await LocalStorage.saveLoginData(
            userData: state.responseModel.data.toJson(),
            token: await LocalStorage.getToken() ?? '',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              duration: Duration(seconds: 1),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is UpdateUserProfileErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background(context),
          centerTitle: true,
          title: Text(
            "Update Profile",
            style: TextStyle(
              color: AppColors.text(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: AppColors.icon(context)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDetailsScreen(),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _showImagePickerSheet(context),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.text(context),
                    child: ClipOval(
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : (_userData!['image_url'] != null &&
                                  _userData!['image_url'].isNotEmpty)
                            ? Image.network(
                                getFullImageUrl(_userData!['image_url']),
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                color: isDark ? Colors.black : Colors.white,
                                size: 35,
                              ),
                      ),
                    ),
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
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone",
                  keyboardType: TextInputType.phone,
                  validatorMsg: "Please enter your phone number",
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      foregroundColor: AppColors.buttonText(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Update Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validatorMsg,
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

// import 'package:fitness_workout_app/presentation/onboarding_screen/onboarding_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fitness_workout_app/features/auth/presentation/pages/register_page.dart';
//
// import '../../../../local_database/local_storage.dart';
// import '../../../../theme/color/colors.dart';
// import '../../domain/usecase/login_usecase.dart';
// import '../bloc/auth_bloc.dart';
// import 'forgot_password.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _obscurePassword = true;
//
//   void _submit(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       final params = LoginUserParameter(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       context.read<AuthBloc>().add(LoginUserEvent(params));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = AppColors.isDark(context);
//
//     return Scaffold(
//       backgroundColor: AppColors.background(context),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) async {
//           if (state is LoginUserSuccessState) {
//             await LocalStorage.saveLoginData(
//               userData: {
//                 "id": state.responseModel.data.id,
//                 "name": state.responseModel.data.name,
//                 "email": state.responseModel.data.email,
//                 "phone": state.responseModel.data.phone,
//                 "image_url": state.responseModel.data.imageUrl,
//                 "is_admin": state.responseModel.data.isAdmin,
//                 "created_at": state.responseModel.data.createdAt,
//                 "updated_at": state.responseModel.data.updatedAt,
//               },
//               token: state.responseModel.token,
//             );
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text("Login Successful!")));
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => OnboardingFlow()),
//             );
//           } else if (state is LoginUserErrorState) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 50),
//                 Text(
//                   "Welcome Back",
//                   style: TextStyle(
//                     color: AppColors.text(context),
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Login to continue",
//                   style: TextStyle(
//                     color: AppColors.subText(context),
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Email
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           labelText: "Email",
//                           labelStyle: TextStyle(
//                             color: AppColors.subText(context),
//                           ),
//                           filled: true,
//                           fillColor: AppColors.card(context),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                               color: AppColors.border(context),
//                             ),
//                           ),
//                         ),
//                         style: TextStyle(color: AppColors.text(context)),
//                         validator: (val) =>
//                             val!.isEmpty ? "Please enter your email" : null,
//                       ),
//                       const SizedBox(height: 16),
//                       // Password with eye toggle
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: _obscurePassword,
//                         decoration: InputDecoration(
//                           labelText: "Password",
//                           labelStyle: TextStyle(
//                             color: AppColors.subText(context),
//                           ),
//                           filled: true,
//                           fillColor: AppColors.card(context),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                               color: AppColors.border(context),
//                             ),
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: AppColors.icon(context),
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                         ),
//                         style: TextStyle(color: AppColors.text(context)),
//                         validator: (val) =>
//                             val!.isEmpty ? "Please enter your password" : null,
//                       ),
//                       const SizedBox(height: 12),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ForgotPasswordScreen(),
//                               ),
//                             );
//                           },
//                           child: Text(
//                             "Forgot Password?",
//                             style: TextStyle(color: AppColors.primary(context)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       state is LoginUserLoadingState
//                           ? const CircularProgressIndicator()
//                           : SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: ElevatedButton(
//                                 onPressed: () => _submit(context),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.primary(context),
//                                   foregroundColor: AppColors.buttonText(
//                                     context,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Login",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               ),
//                             ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Don't have an account? ",
//                             style: TextStyle(color: AppColors.subText(context)),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const RegisterScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Register",
//                               style: TextStyle(
//                                 color: AppColors.primary(context),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:fitness_workout_app/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_workout_app/features/auth/presentation/pages/register_page.dart';

import '../../../../local_database/local_storage.dart';
import '../../../../local_database/onboarding_storage.dart';
import '../../../../presentation/bottom_navigation_bar/bottom_navigation.dart';
import '../../../../theme/color/colors.dart';
import '../../../user_details/presentations/bloc/user_details_bloc.dart';
import '../../domain/usecase/login_usecase.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final params = LoginUserParameter(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      context.read<AuthBloc>().add(LoginUserEvent(params));
    }
  }

  void _navigateBasedOnUserDetails(Map<String, dynamic> userDetails) {
    final data = userDetails['data'];
    final userDetail = data?['user_detail'];

    print('Parsed userDetail: $userDetail');

    final hasAllDetails =
        userDetail != null &&
        userDetail['gender'] != null &&
        userDetail['user_name'] != null &&
        userDetail['age'] != null &&
        userDetail['current_weight'] != null &&
        userDetail['current_weight_type'] != null &&
        userDetail['target_weight'] != null &&
        userDetail['target_weight_type'] != null &&
        userDetail['height'] != null &&
        userDetail['height_type'] != null;

    if (hasAllDetails) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FitnessProgramScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingFlow()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is LoginUserSuccessState) {
                await LocalStorage.saveLoginData(
                  userData: {
                    "id": state.responseModel.data.id,
                    "name": state.responseModel.data.name,
                    "email": state.responseModel.data.email,
                    "phone": state.responseModel.data.phone,
                    "image_url": state.responseModel.data.imageUrl,
                    "is_admin": state.responseModel.data.isAdmin,
                    "created_at": state.responseModel.data.createdAt,
                    "updated_at": state.responseModel.data.updatedAt,
                  },
                  token: state.responseModel.token,
                );

                // Call GetUserDetails API after login
                context.read<UserDetailsBloc>().add(GetUserDetailsEvent());
              } else if (state is LoginUserErrorState) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<UserDetailsBloc, UserDetailsState>(
            listener: (context, state) async {
              if (state is GetUserDetailsSuccessState) {
                final userDetail = state.userDetailResponse.data?.userDetail;

                print(
                  'User details JSON: ${state.userDetailResponse.toJson()}',
                );

                if (userDetail?.gender != null) {
                  await OnboardingStorage.saveString(
                    "gender",
                    userDetail!.gender!.toLowerCase(),
                  );
                  print(
                    "Saved gender to storage: ${userDetail!.gender!.toLowerCase()}",
                  );
                }
                _navigateBasedOnUserDetails(state.userDetailResponse.toJson());
              } else if (state is GetUserDetailsErrorState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingFlow()),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is LoginUserLoadingState;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to continue",
                    style: TextStyle(
                      color: AppColors.subText(context),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: AppColors.subText(context),
                            ),
                            filled: true,
                            fillColor: AppColors.card(context),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border(context),
                              ),
                            ),
                          ),
                          style: TextStyle(color: AppColors.text(context)),
                          validator: (val) =>
                              val!.isEmpty ? "Please enter your email" : null,
                        ),
                        const SizedBox(height: 16),
                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: AppColors.subText(context),
                            ),
                            filled: true,
                            fillColor: AppColors.card(context),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border(context),
                              ),
                            ),
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
                          style: TextStyle(color: AppColors.text(context)),
                          validator: (val) => val!.isEmpty
                              ? "Please enter your password"
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primary(context),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Button or Loading
                        isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => _submit(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary(context),
                                    foregroundColor: AppColors.buttonText(
                                      context,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.subText(context),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: AppColors.primary(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

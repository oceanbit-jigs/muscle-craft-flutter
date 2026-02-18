import 'dart:io';

import 'package:fitness_workout_app/presentation/tab/profile_tab/edit_profile_screen.dart';
import 'package:fitness_workout_app/presentation/tab/profile_tab/setting_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/api.dart';
import '../../../features/auth/domain/usecase/logout_usecase.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../local_database/local_storage.dart';
import '../../../theme/color/colors.dart';
import '../../../theme_provider/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  String userName = "User";
  String userEmail = "";
  String appVersion = "";
  bool workoutReminder = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAppVersion();
  }

  Future<void> _loadUserData() async {
    final userData = await LocalStorage.getUserData();
    if (userData != null) {
      debugPrint("printUserdata : $userData");
      setState(() {
        _userData = userData;
        userName = userData['name'] ?? "User";
        userEmail = userData['email'];
      });
    }
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return "${Api.base}$path";
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedRating = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.border(context), width: 1.5),
              ),
              backgroundColor: AppColors.card(context),

              title: Center(
                child: Text(
                  "Rate Us",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "How was your experience?",
                    style: TextStyle(color: AppColors.subText(context)),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final isSelected = index < selectedRating;

                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          size: 30,

                          color: isSelected
                              ? AppColors.warning(context)
                              : AppColors.border(context),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shadowColor: Colors.white,
                    side: BorderSide(
                      color: AppColors.subText(context),
                      //width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.subText(context)),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    _redirectToStore();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: AppColors.buttonText(context)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _redirectToStore() async {
    final Uri androidUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.usstatus.workout",
    );

    final Uri iosUrl = Uri.parse("https://apps.apple.com/app/idYOUR_APP_ID");

    if (Platform.isAndroid) {
      if (await canLaunchUrl(androidUrl)) {
        await launchUrl(androidUrl, mode: LaunchMode.externalApplication);
      }
    } else if (Platform.isIOS) {
      if (await canLaunchUrl(iosUrl)) {
        await launchUrl(iosUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    debugPrint("print the value : ${info.version}");
    setState(() {
      appVersion = "v${info.version}";
    });
  }

  Future<bool?> showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.border(context), width: 1.5),
          ),
          backgroundColor: AppColors.card(context),
          title: Text(
            "Logout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shadowColor: Colors.white,
                side: BorderSide(
                  color: AppColors.subText(context),
                  //width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.subText(context)),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout", style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearAppDataAndLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      final appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }

      // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("Error clearing app data: $e");
    }
  }

  Future<bool?> showDeleteAccountConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.border(context), width: 1.5),
          ),
          backgroundColor: AppColors.card(context),
          title: const Text(
            "Delete Account",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "This will permanently delete your account and all data. This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _shareApp() {
    const String appLinkAndroid =
        "https://play.google.com/store/apps/details?id=com.usstatus.videoeditor";
    const String appLinkIOS = "https://apps.apple.com/app/idYOUR_APP_ID";

    const String message =
        '''
🏋️‍♂️ Transform your fitness journey!

I’ve been using this amazing fitness app for workouts, exercises, and daily motivation 💪🔥

Download now and start your fitness journey today:
Android 👉 $appLinkAndroid
iOS 👉 $appLinkIOS
''';

    Share.share(message);
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     // "Hi User",
  //                     "Hi $userName",
  //                     style: TextStyle(
  //                       //color: Colors.white,
  //                       color: Theme.of(context).colorScheme.onSurface,
  //                       fontSize: 26,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => SettingsScreen(),
  //                         ),
  //                       );
  //                     },
  //                     child: SvgPicture.asset(
  //                       'assets/icons/settings.svg',
  //                       height: 24,
  //                       width: 24,
  //                       // color: Colors.white,
  //                       //color: Theme.of(context).colorScheme.onBackground,
  //                       colorFilter: ColorFilter.mode(
  //                         Theme.of(context).colorScheme.onSurface,
  //                         BlendMode.srcIn,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               Stack(
  //                 clipBehavior: Clip.none,
  //                 children: [
  //                   Center(
  //                     child: CircleAvatar(
  //                       radius: 100,
  //                       backgroundColor: Colors.grey.shade300,
  //                       child: ClipOval(
  //                         child:
  //                             _userData != null &&
  //                                 _userData!['image_url'] != null &&
  //                                 _userData!['image_url'].isNotEmpty
  //                             ? Image.network(
  //                                 getFullImageUrl(_userData!['image_url']),
  //                                 height: 230,
  //                                 width: 230,
  //                                 fit: BoxFit.cover,
  //                                 errorBuilder: (_, _, _) {
  //                                   return Image.asset(
  //                                     'assets/icons/user.png',
  //                                     height: 230,
  //                                     width: 230,
  //                                     fit: BoxFit.cover,
  //                                   );
  //                                 },
  //                               )
  //                             : Image.asset(
  //                                 'assets/icons/user.png',
  //                                 height: 230,
  //                                 width: 230,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                       ),
  //                     ),
  //                   ),
  //
  //                   Positioned(
  //                     bottom: -25,
  //                     left: 0,
  //                     right: 0,
  //                     child: _buildProfileButtons(context),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               _buildProfileMenu(context),
  //
  //               // Stack(
  //               //   clipBehavior: Clip.none,
  //               //   children: [
  //               //     Center(
  //               //       child: CircleAvatar(
  //               //         radius: 100,
  //               //         backgroundColor: Colors.grey.shade300,
  //               //         child: ClipOval(
  //               //           child:
  //               //               _userData != null &&
  //               //                   _userData!['image_url'] != null &&
  //               //                   _userData!['image_url'].isNotEmpty
  //               //               ? Image.network(
  //               //                   getFullImageUrl(_userData!['image_url']),
  //               //                   height: 230,
  //               //                   width: 230,
  //               //                   fit: BoxFit.cover,
  //               //                   errorBuilder: (_, _, _) {
  //               //                     return Image.asset(
  //               //                       'assets/icons/user.png',
  //               //                       height: 230,
  //               //                       width: 230,
  //               //                       fit: BoxFit.cover,
  //               //                     );
  //               //                   },
  //               //                 )
  //               //               : Image.asset(
  //               //                   'assets/icons/user.png',
  //               //                   height: 230,
  //               //                   width: 230,
  //               //                   fit: BoxFit.cover,
  //               //                 ),
  //               //         ),
  //               //       ),
  //               //     ),
  //               //
  //               //     Positioned(
  //               //       bottom: -25,
  //               //       left: 0,
  //               //       right: 0,
  //               //       child: _buildProfileButtons(context),
  //               //     ),
  //               //   ],
  //               // ),
  //               const SizedBox(height: 35),
  //               //
  //               // _buildBadgesGrid(context),
  //               const SizedBox(height: 10),
  //
  //               Container(
  //                 height: 170,
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.card(context),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(color: AppColors.border(context)),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/icons/star.png',
  //                               height: 20,
  //                               width: 20,
  //                               color: AppColors.icon(context),
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               "Reviews",
  //                               style: TextStyle(
  //                                 color: AppColors.text(context),
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //
  //                         Row(
  //                           children: List.generate(
  //                             5,
  //                             (index) => Padding(
  //                               padding: const EdgeInsets.only(left: 4),
  //                               child: SvgPicture.asset(
  //                                 'assets/icons/star1.svg',
  //                                 height: 20,
  //                                 width: 20,
  //                                 colorFilter: ColorFilter.mode(
  //                                   AppColors.icon(context),
  //                                   BlendMode.srcIn,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     const SizedBox(height: 14),
  //
  //                     Center(
  //                       child: Text(
  //                         "Enjoying the app?",
  //                         style: TextStyle(
  //                           color: AppColors.text(context),
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 6),
  //
  //                     Center(
  //                       child: Text(
  //                         "Leave us a quick review, it helps a ton!",
  //                         style: TextStyle(
  //                           color: AppColors.subText(context),
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 16),
  //
  //                     GestureDetector(
  //                       onTap: () {
  //                         _showReviewDialog(context);
  //                       },
  //                       child: Container(
  //                         width: double.infinity,
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                           color: AppColors.primary(context),
  //                           borderRadius: BorderRadius.circular(30),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               "Leave a review",
  //                               style: TextStyle(
  //                                 color: AppColors.buttonText(context),
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 15,
  //                               ),
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Icon(
  //                               Icons.thumb_up_alt_rounded,
  //                               color: AppColors.buttonText(context),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = Theme.of(context).colorScheme.onSurface;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.6);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (!mounted) return;

        if (state is LogoutUserSuccessState) {
          LocalStorage.clearLoginData();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.responseModel.message),
              duration: const Duration(seconds: 1),
            ),
          );

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (_) => LoginScreen()),
          //   (route) => false,
          // );

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
          );
        } else if (state is LogoutUserErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is DeleteAccountLoadedState) {
          await clearAppDataAndLogout(context);

          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text(state.data.status)));
        } else if (state is DeleteAccountErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                /// ─── HEADER ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // CircleAvatar(
                      //   radius: 70,
                      //   backgroundColor: Colors.white,
                      //   child: ClipOval(
                      //     child:
                      //         _userData != null &&
                      //             _userData!['image_url'] != null &&
                      //             _userData!['image_url'].isNotEmpty
                      //         ? Image.network(
                      //             getFullImageUrl(_userData!['image_url']),
                      //             height: 230,
                      //             width: 230,
                      //             fit: BoxFit.cover,
                      //             errorBuilder: (_, _, _) {
                      //               return Image.asset(
                      //                 'assets/icons/user.png',
                      //                 height: 230,
                      //                 width: 230,
                      //                 fit: BoxFit.cover,
                      //               );
                      //             },
                      //           )
                      //         : Image.asset(
                      //             'assets/icons/user.png',
                      //             height: 230,
                      //             width: 230,
                      //             fit: BoxFit.cover,
                      //           ),
                      //   ),
                      // ),
                      Stack(
                        children: [
                          /// ─── PROFILE IMAGE ───────────────────────────
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            child: ClipOval(
                              child:
                                  _userData != null &&
                                      _userData!['image_url'] != null &&
                                      _userData!['image_url'].isNotEmpty
                                  ? Image.network(
                                      getFullImageUrl(_userData!['image_url']),
                                      height: 230,
                                      width: 230,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Image.asset(
                                          'assets/icons/user.png',
                                          height: 230,
                                          width: 230,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/icons/user.png',
                                      height: 230,
                                      width: 230,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          /// ─── EDIT ICON ───────────────────────────────
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateProfileScreen(),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    _loadUserData();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                /// ─── SETTINGS CONTAINER ───────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.card(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      _buildSwitchTile(
                        icon: Icons.dark_mode,
                        title: "App Theme",
                        value: themeProvider.isDarkMode(context),
                        //onChanged: (_) => () {},
                        onChanged: (_) => themeProvider.toggleTheme(context),
                      ),

                      _buildSwitchTile(
                        icon: Icons.notifications,
                        title: "Workout Reminder",
                        value: workoutReminder,
                        onChanged: (v) => setState(() => workoutReminder = v),
                      ),

                      _buildTile(
                        Icons.cleaning_services,
                        "Clear Cache",
                        onTap: () async => clearAppDataAndLogout(context),
                      ),
                      _buildTile(Icons.share, "Share", onTap: _shareApp),
                      _buildTile(Icons.info_outline, "About App"),

                      _buildTile(
                        Icons.support_agent,
                        "Contact Support",
                        onTap: () => _openUrl(
                          "https://musclecraft-bodyworkout.oceanbitsolutions.com/terms-and-conditions",
                        ),
                      ),

                      _buildTile(
                        Icons.privacy_tip,
                        "Privacy Policy",
                        onTap: () => _openUrl(
                          "https://musclecraft-bodyworkout.oceanbitsolutions.com/privacy-policy",
                        ),
                      ),

                      _buildTile(Icons.description, "Term Of Use"),

                      _buildTile(
                        Icons.delete,
                        "Delete Account",
                        onTap: () async {
                          final confirm = await showDeleteAccountConfirmation(
                            context,
                          );
                          if (confirm == true) {
                            context.read<AuthBloc>().add(
                              FetchDeleteAccountEvent(context: context),
                            );
                          }
                        },
                      ),

                      _buildTile(
                        Icons.logout,
                        "Log Out",
                        onTap: () async {
                          final confirm = await showLogoutConfirmation(context);
                          if (confirm == true) {
                            final token = await LocalStorage.getToken();
                            if (token != null) {
                              context.read<AuthBloc>().add(
                                LogoutUserEvent(
                                  LogoutUserParameter(token: token),
                                ),
                              );
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            appVersion.isNotEmpty ? appVersion : "v--",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title, {
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final color = isDanger
            ? Colors.red
            : Theme.of(context).colorScheme.onSurface;

        return ListTile(
          onTap: onTap,
          leading: Icon(icon, color: color, size: 20),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Builder(
      builder: (context) {
        final color = Theme.of(context).colorScheme.onSurface;

        return SwitchListTile(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange,
          title: Text(title, style: TextStyle(color: color)),
          secondary: Icon(icon, color: color),
        );
      },
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        children: [
          _menuSwitchTile(
            context,
            icon: Icons.dark_mode,
            title: "App Theme",
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (val) {},
          ),

          _menuSwitchTile(
            context,
            icon: Icons.notifications,
            title: "Workout Reminder",
            value: true,
            onChanged: (val) {},
          ),

          _divider(context),

          _menuTile(
            context,
            icon: Icons.cleaning_services,
            title: "Clear Cache",
            onTap: () {},
          ),

          _menuTile(context, icon: Icons.share, title: "Share", onTap: () {}),

          _menuTile(
            context,
            icon: Icons.info_outline,
            title: "About App",
            onTap: () {},
          ),

          _menuTile(
            context,
            icon: Icons.support_agent,
            title: "Contact Support",
            onTap: () {},
          ),

          _menuTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () {},
          ),

          _menuTile(
            context,
            icon: Icons.description_outlined,
            title: "Term Of Use",
            onTap: () {},
          ),

          _menuTile(
            context,
            icon: Icons.delete_outline,
            title: "Delete Account",
            textColor: Colors.redAccent,
            onTap: () {},
          ),

          _menuTile(
            context,
            icon: Icons.logout,
            title: "Log Out",
            textColor: Colors.redAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.icon(context)),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.text(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _menuSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.icon(context)),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.text(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: AppColors.primary(context),
        onChanged: onChanged,
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(height: 1, color: AppColors.divider(context));
  }

  Widget _buildProfileButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadUserData();
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/pencil.png',
                      height: 18,
                      width: 18,
                      color: AppColors.icon(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Edit\n  Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Divider
          Container(width: 1, height: 45, color: AppColors.divider(context)),

          // ---------------- BUTTON 2 ----------------
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/user1.png',
                      height: 18,
                      width: 18,
                      color: AppColors.icon(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Free User",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

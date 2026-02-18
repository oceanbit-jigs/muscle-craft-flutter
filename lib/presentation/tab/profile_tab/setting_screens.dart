import 'package:fitness_workout_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/domain/usecase/logout_usecase.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../local_database/local_storage.dart';
import '../../../theme/color/colors.dart';
import '../../../theme_provider/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool workoutReminder = false;

  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              // color: Colors.white,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildSettingsContainer(
                title: 'GENERAL',
                children: [
                  _settingItem(
                    icon: 'assets/settings/theme.png',
                    title: 'App Theme',
                    trailing: Transform.scale(
                      scale: 0.8,
                      child:
                          // Switch(
                          //   value: themeProvider.currentTheme == ThemeMode.dark,
                          //   onChanged: (value) {
                          //     themeProvider.toggleTheme();
                          //   },
                          //   activeColor: Colors.orange,
                          //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          // ),
                          Switch(
                            value: themeProvider.isDarkMode(context),
                            onChanged: (_) {
                              themeProvider.toggleTheme(context);
                            },
                            activeColor: Colors.orange,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                    ),
                    context: context,
                  ),

                  _divider(context),

                  _settingItem(
                    icon: 'assets/settings/notification.svg',
                    title: 'Workout Reminder',
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: workoutReminder,
                        onChanged: (value) =>
                            setState(() => workoutReminder = value),
                        activeColor: Colors.orange,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    context: context,
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/park.svg',
                    title: 'Clear Cache',
                    context: context,
                    onTap: () async {
                      await clearAppDataAndLogout(context);
                    },
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/upload.svg',
                    title: 'Share',
                    context: context,
                    onTap: _shareApp,
                  ),
                  // _divider(context),
                  // _settingItem(
                  //   icon: 'assets/settings/rate.png',
                  //   title: 'Rate App',
                  //   context: context,
                  // ),
                ],
                context: context,
              ),
              const SizedBox(height: 10),
              _buildSettingsContainer(
                context: context,
                title: 'SUPPORT',
                children: [
                  _settingItem(
                    icon: 'assets/settings/share.svg',
                    title: 'Contact Support',
                    context: context,
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/privacy.svg',
                    title: 'Privacy Policy',
                    context: context,
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/file.svg',
                    title: 'Terms of Use',
                    context: context,
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/logout.png',
                    title: 'Logout',
                    context: context,
                    trailing: null,
                    onTap: () async {
                      final confirm = await showLogoutConfirmation(context);

                      if (confirm == true) {
                        final token = await LocalStorage.getToken();

                        if (token != null) {
                          context.read<AuthBloc>().add(
                            LogoutUserEvent(LogoutUserParameter(token: token)),
                          );
                        } else {
                          debugPrint("Token not found, cannot logout");
                        }
                      }
                    },
                  ),
                  _divider(context),
                  _settingItem(
                    icon: 'assets/settings/logout.png',
                    title: 'Delete Account',
                    context: context,
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
                ],
              ),

              Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    appVersion.isNotEmpty ? appVersion : "v--",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
        ), // Theme-aware border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.subText(context),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _settingItem({
    required BuildContext context,
    required String icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    bool isSvg = icon.toLowerCase().endsWith(".svg");

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            isSvg
                ? SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.icon(context),
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(
                    icon,
                    width: 20,
                    height: 20,
                    color: AppColors.icon(context),
                  ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(height: 1, color: AppColors.divider(context));
  }
}

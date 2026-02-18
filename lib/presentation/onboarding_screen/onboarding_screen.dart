import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/user_details/domain/usecase/user_details_usecase.dart';
import '../../features/user_details/presentations/bloc/user_details_bloc.dart';
import '../../local_database/onboarding_storage.dart';
import '../../theme/color/colors.dart';
import '../bottom_navigation_bar/bottom_navigation.dart';
import '../loading_screen/loading_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int currentStep = 0;
  final List<GlobalKey> stepKeys = List.generate(9, (_) => GlobalKey());

  late final List<Widget> steps;

  @override
  void initState() {
    super.initState();

    steps = [
      const GenderStep(key: ValueKey(0)),
      UsernameStep(key: stepKeys[1]),
      AgeStep(key: stepKeys[2]),
      WeightStep(key: stepKeys[3]),
      TargetWeightStep(key: stepKeys[4]),
      HeightStep(key: stepKeys[5]),
      GoalStep(key: ValueKey(6)),
      FocusAreaStep(key: ValueKey(7)),
      const NotificationStep(key: ValueKey(8)),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentStep == 0) {
        FocusScope.of(context).unfocus();
      } else {
        _focusCurrentStep();
      }
    });
  }

  bool _validateCurrentStep() {
    final state = stepKeys[currentStep].currentState;

    if (state is UsernameStepState) {
      return state.validate();
    } else if (state is AgeStepState) {
      return state.validate();
    } else if (state is _WeightStepState) {
      return state.validate();
    } else if (state is _TargetWeightStepState) {
      return state.validate();
    } else if (state is _HeightStepState) {
      return state.validate();
    }

    return true;
  }

  void _focusCurrentStep() {
    if (currentStep == 0) return;

    final state = stepKeys[currentStep].currentState;
    if (state is UsernameStepState) {
      state.focus();
    } else if (state is AgeStepState) {
      state.focus();
    } else if (state is _WeightStepState) {
      state.focus();
    } else if (state is _TargetWeightStepState) {
      state.focus();
    }
  }

  Future<void> _saveCurrentStepData() async {
    final state = stepKeys[currentStep].currentState;

    if (state is UsernameStepState) {
      await OnboardingStorage.saveString(
        "username",
        state.controller.text.trim(),
      );
    } else if (state is AgeStepState) {
      await OnboardingStorage.saveInt(
        "age",
        int.tryParse(state.controller.text.trim()) ?? 0,
      );
    } else if (state is _WeightStepState) {
      await OnboardingStorage.saveInt(
        "weight",
        int.tryParse(state.controller.text.trim()) ?? 0,
      );
      await OnboardingStorage.saveString("weight_unit", state.unit);
    } else if (state is _TargetWeightStepState) {
      await OnboardingStorage.saveInt(
        "target_weight",
        int.tryParse(state.controller.text.trim()) ?? 0,
      );
      await OnboardingStorage.saveString("target_weight_unit", state.unit);
    } else if (state is _HeightStepState) {
      await OnboardingStorage.saveInt("height_cm", state.heightCm.round());
      await OnboardingStorage.saveString("height_unit", state.unit);
    }
  }

  String mapWeightUnit(String? unit) {
    switch ((unit ?? "").toLowerCase()) {
      case "kg":
        return "Kg";
      case "lbs":
        return "Lbs";
      default:
        return "Kg";
    }
  }

  String mapHeightUnit(String? unit) {
    switch ((unit ?? "").toLowerCase()) {
      case "cm":
        return "Cm";
      case "ft":
        return "Ft";
      default:
        return "Cm";
    }
  }

  Future<SaveUserDetailsParams> _prepareParams({
    required List<Map<String, dynamic>> allGoals,
    required List<Map<String, dynamic>> allFocusAreas,
  }) async {
    final username = await OnboardingStorage.getString("username");
    final age = await OnboardingStorage.getInt("age");
    final weight = await OnboardingStorage.getInt("weight");
    final weightUnit = await OnboardingStorage.getString("weight_unit");
    final targetWeight = await OnboardingStorage.getInt("target_weight");
    final targetWeightUnit = await OnboardingStorage.getString(
      "target_weight_unit",
    );
    final heightCm = await OnboardingStorage.getInt("height_cm");
    final heightUnit = await OnboardingStorage.getString("height_unit");
    final gender = await OnboardingStorage.getString("gender");
    final notificationsEnabled =
        await OnboardingStorage.getInt("notifications_enabled") ?? 1;

    final selectedGoalNames = await OnboardingStorage.getList("goals") ?? [];
    final selectedFocusAreaNames =
        await OnboardingStorage.getList("focus_areas") ?? [];

    final goalIds = allGoals
        .where((g) => selectedGoalNames.contains(g['display_name']))
        .map((g) => g['id'] as int)
        .toList();

    final focusAreaIds = allFocusAreas
        .where((f) => selectedFocusAreaNames.contains(f['display_name']))
        .map((f) => f['id'] as int)
        .toList();

    return SaveUserDetailsParams(
      userName: username ?? "",
      age: age ?? 0,
      currentWeight: weight?.toDouble() ?? 0.0,
      currentWeightUnit: mapWeightUnit(weightUnit),
      targetWeightUnit: mapWeightUnit(targetWeightUnit),
      heightUnit: mapHeightUnit(heightUnit),
      targetWeight: targetWeight?.toDouble() ?? 0.0,
      height: heightCm?.toDouble() ?? 0.0,
      gender: gender ?? "Male",
      goalIds: goalIds,
      focusAreaIds: focusAreaIds,
      isNotificationEnabled: notificationsEnabled == 1,
    );
  }

  void nextStep() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) return;

    await _saveCurrentStepData();

    final bool isLastStep = currentStep == steps.length - 1;

    if (!isLastStep) {
      setState(() => currentStep++);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusCurrentStep();
      });
      return;
    }

    final status = await Permission.notification.request();
    if (status.isGranted) {
      await OnboardingStorage.saveInt("notifications_enabled", 1);
      debugPrint("Notifications Allowed");
    } else {
      await OnboardingStorage.saveInt("notifications_enabled", 0);
      debugPrint("Notifications Denied");
    }

    final bloc = context.read<UserDetailsBloc>();

    List<Map<String, dynamic>> allGoals =
        bloc.masterGoalCache?.data
            .map((g) => {'id': g.id, 'display_name': g.displayName})
            .toList() ??
        [];

    List<Map<String, dynamic>> allFocusAreas =
        bloc.focusAreaCache?.data
            .map((f) => {'id': f.id, 'display_name': f.displayName})
            .toList() ??
        [];

    final params = await _prepareParams(
      allGoals: allGoals,
      allFocusAreas: allFocusAreas,
    );

    context.read<UserDetailsBloc>().add(SaveUserDetailsEvent(params));

    debugPrint("Selected Goal IDs: ${params.goalIds}");
    debugPrint("Selected Focus Area IDs: ${params.focusAreaIds}");

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const LoadingScreen()),
    // );
  }

  void previousStep() {
    FocusScope.of(context).unfocus();
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showBack = currentStep > 0;
    final bool isLastStep = currentStep == steps.length - 1;

    return BlocListener<UserDetailsBloc, UserDetailsState>(
      listener: (context, state) {
        if (state is SaveUserDetailsLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is SaveUserDetailsSuccessState) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoadingScreen()),
          );
        } else if (state is SaveUserDetailsErrorState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProgressBar(),
              Expanded(
                child: IndexedStack(index: currentStep, children: steps),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBack)
                      InkWell(
                        onTap: previousStep,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.card(context),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.icon(context),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    if (showBack) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
                          foregroundColor: AppColors.buttonText(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        onPressed: nextStep,
                        child: Text(
                          isLastStep ? "Allow" : "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonText(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildKeyboardFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),

      // Scaffold(
      //   resizeToAvoidBottomInset: true,
      //   backgroundColor: AppColors.background(context),
      //   body: SafeArea(
      //     child: Column(
      //       children: [
      //         const SizedBox(height: 20),
      //         _buildProgressBar(),
      //         Expanded(
      //           child: IndexedStack(index: currentStep, children: steps),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 20,
      //             vertical: 40,
      //           ),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               if (showBack)
      //                 InkWell(
      //                   onTap: previousStep,
      //                   borderRadius: BorderRadius.circular(30),
      //                   child: Container(
      //                     width: 56,
      //                     height: 56,
      //                     decoration: BoxDecoration(
      //                       color: AppColors.card(context),
      //                       shape: BoxShape.circle,
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.only(left: 10),
      //                       child: Icon(
      //                         Icons.arrow_back_ios,
      //                         color: AppColors.icon(context),
      //                         size: 30,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               if (showBack) const SizedBox(width: 12),
      //               Expanded(
      //                 child: ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: AppColors.primary(context),
      //                     foregroundColor: AppColors.buttonText(context),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(40),
      //                     ),
      //                     minimumSize: const Size(double.infinity, 56),
      //                   ),
      //                   onPressed: nextStep,
      //                   child: Text(
      //                     isLastStep ? "Allow" : "Continue",
      //                     style: TextStyle(
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.bold,
      //                       color: AppColors.buttonText(context),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildProgressBar() {
    const int questionsPerDot = 1;
    const int totalDots = 9;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final lineWidth = constraints.maxWidth;

          final bool isLight = !AppColors.isDark(context);

          // Light theme colors
          final backgroundLineColor = isLight
              ? Colors.black
              : Colors.grey.shade800;
          final progressLineColor = isLight
              ? Colors.yellowAccent
              : Colors.yellowAccent;
          final dotCompletedColor = isLight
              ? Colors.yellowAccent
              : Colors.yellowAccent;
          final dotPendingColor = isLight ? Colors.white : Colors.grey.shade700;
          final iconColor = isLight ? Colors.black : Colors.black;

          return SizedBox(
            height: 30,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background line
                Container(height: 3, color: backgroundLineColor),

                // Progress line
                FractionallySizedBox(
                  widthFactor: (currentStep + 1) / steps.length,
                  child: Container(height: 3, color: progressLineColor),
                ),

                // Dots
                ...List.generate(totalDots, (dotIndex) {
                  double positionFraction =
                      ((dotIndex + 1) * questionsPerDot) / steps.length;

                  bool isCompleted =
                      currentStep >= (dotIndex + 1) * questionsPerDot;

                  return Positioned(
                    left: (lineWidth * positionFraction) - 15,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? dotCompletedColor
                            : dotPendingColor,
                        border: Border.all(
                          color: backgroundLineColor,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, size: 10, color: iconColor)
                          : null,
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget? _buildKeyboardFAB(BuildContext context) {
    if (!Platform.isIOS) return null;

    // Show only for Age, Weight, TargetWeight
    if (!(currentStep == 2 || currentStep == 3 || currentStep == 4)) {
      return null;
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardHeight == 0) return null;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: FloatingActionButton(
        backgroundColor: AppColors.primary(context),
        onPressed: () {
          FocusScope.of(context).unfocus();
        },
        child: const Icon(Icons.keyboard_hide),
      ),
    );
  }
}

class GenderStep extends StatefulWidget {
  const GenderStep({super.key});

  @override
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return OnboardingStep(
      title: "Choose your gender",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _genderCard(context, "Female", "assets/icons/female.png"),
          _genderCard(context, "Male", "assets/icons/male.png"),
        ],
      ),
    );
  }

  Widget _genderCard(BuildContext context, String title, String image) {
    final isSelected = selectedGender == title;
    final isDark = AppColors.isDark(context);

    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final borderColor = isSelected
        ? AppColors.primary(context)
        : (isDark ? Colors.grey[600]! : Colors.grey[400]!);
    final textColor = isSelected
        ? AppColors.primary(context)
        : (isDark ? Colors.grey[300]! : Colors.black87);
    final imageColor = isDark
        ? Colors.white
        : null; // Keep original image colors for light theme

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = title;
        });
        OnboardingStorage.saveString("gender", title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(image, height: 120, color: imageColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsernameStep extends StatefulWidget {
  const UsernameStep({super.key});

  @override
  UsernameStepState createState() => UsernameStepState();
}

class UsernameStepState extends State<UsernameStep> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool validate() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter username",
            style: TextStyle(color: AppColors.text(context)),
          ),
          backgroundColor: AppColors.card(context),
        ),
      );
      return false;
    }
    return true;
  }

  void focus() {
    focusNode.requestFocus();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => focusNode.requestFocus(),
  //   );
  // }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final glowColor = isDark ? Colors.white : Colors.black;

    return OnboardingStep(
      title: "Pick a username",
      content: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        autocorrect: false,
        enableSuggestions: false,
        cursorColor: glowColor,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          color: glowColor,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: 10.0,
              offset: const Offset(0, 0),
            ),
            Shadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: 15.0,
              offset: const Offset(0, 0),
            ),
            Shadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: 30.0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

class AgeStep extends StatefulWidget {
  const AgeStep({super.key});

  @override
  AgeStepState createState() => AgeStepState();
}

class AgeStepState extends State<AgeStep> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void focus() {
    focusNode.requestFocus();
  }

  bool validate() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your age")));
      return false;
    }
    return true;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     focusNode.requestFocus();
  //   });
  // }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = AppColors.text(context);
    final unitColor = AppColors.subText(context);

    return OnboardingStep(
      title: "Your age",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: TextField(
              cursorColor: glowColor,
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              // onChanged: (value) {
              //   if (value.length == 2) {
              //     focusNode.unfocus();
              //   }
              // },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              style: TextStyle(
                color: glowColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: glowColor.withValues(alpha: 0.5),
                    blurRadius: 10.0,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: glowColor.withValues(alpha: 0.5),
                    blurRadius: 15.0,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: glowColor.withValues(alpha: 0.5),
                    blurRadius: 30.0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          Text(" years", style: TextStyle(color: unitColor, fontSize: 22)),
        ],
      ),
    );
  }
}

class WeightStep extends StatefulWidget {
  const WeightStep({super.key});

  @override
  State<WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends State<WeightStep> {
  String unit = "kg";
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool showUnit = false;

  void focus() {
    focusNode.requestFocus();
  }

  bool validate() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your current weight")),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   focusNode.requestFocus();
    // });

    controller.addListener(() {
      if (controller.text.isNotEmpty && !showUnit) {
        setState(() => showUnit = true);
      } else if (controller.text.isEmpty && showUnit) {
        setState(() => showUnit = false);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final glowColor = AppColors.text(context);
    final unitColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);

    return OnboardingStep(
      title: "Current weight",

      // ---------- TOGGLE ----------
      toggleWidget: ToggleButtons(
        isSelected: [unit == "kg", unit == "lbs"],
        onPressed: (index) {
          setState(() {
            unit = index == 0 ? "kg" : "lbs";
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: glowColor,
        fillColor: Colors.transparent,
        color: glowColor,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
        renderBorder: false,
        children: List.generate(2, (index) {
          bool selected = unit == (index == 0 ? "kg" : "lbs");

          return Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: selected
                ? BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.black, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Colors.black, Colors.grey, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor),
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              index == 0 ? "KG" : "LBS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: glowColor,
              ),
            ),
          );
        }),
      ),

      content: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  focusNode: focusNode,
                  cursorColor: glowColor,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  // onChanged: (value) {
                  //   if (value.length == 2) {
                  //     focusNode.unfocus();
                  //   }
                  // },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: TextStyle(
                    color: glowColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 10.0,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 15.0,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 30.0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: showUnit
                    ? Text(
                        " $unit",
                        key: ValueKey(unit),
                        style: TextStyle(color: unitColor, fontSize: 22),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TargetWeightStep extends StatefulWidget {
  const TargetWeightStep({super.key});

  @override
  State<TargetWeightStep> createState() => _TargetWeightStepState();
}

class _TargetWeightStepState extends State<TargetWeightStep> {
  String unit = "kg";
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool showUnit = false;

  void focus() {
    focusNode.requestFocus();
  }

  bool validate() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your target weight")),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   focusNode.requestFocus();
    // });

    controller.addListener(() {
      if (controller.text.isNotEmpty && !showUnit) {
        setState(() => showUnit = true);
      } else if (controller.text.isEmpty && showUnit) {
        setState(() => showUnit = false);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final glowColor = AppColors.text(context);
    final unitColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);

    return OnboardingStep(
      title: "Target weight",

      // ---------- TOGGLE ----------
      toggleWidget: ToggleButtons(
        isSelected: [unit == "kg", unit == "lbs"],
        onPressed: (index) {
          setState(() {
            unit = index == 0 ? "kg" : "lbs";
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: glowColor,
        fillColor: Colors.transparent,
        color: glowColor,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
        renderBorder: false,
        children: List.generate(2, (index) {
          bool selected = unit == (index == 0 ? "kg" : "lbs");

          return Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: selected
                ? BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.black, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Colors.black, Colors.grey, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor),
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              index == 0 ? "KG" : "LBS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: glowColor,
              ),
            ),
          );
        }),
      ),

      content: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  focusNode: focusNode,
                  autofocus: false,
                  cursorColor: glowColor,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  // onChanged: (value) {
                  //   if (value.length == 2) {
                  //     focusNode.unfocus();
                  //   }
                  // },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: TextStyle(
                    color: glowColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 10.0,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 15.0,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: glowColor.withValues(alpha: 0.5),
                        blurRadius: 30.0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              // ---------- UNIT ANIMATION ----------
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: showUnit
                    ? Text(
                        " $unit",
                        key: ValueKey(unit),
                        style: TextStyle(color: unitColor, fontSize: 22),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeightStep extends StatefulWidget {
  const HeightStep({super.key});

  @override
  State<HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends State<HeightStep> {
  String unit = "cm";
  double heightCm = 0;

  final TextEditingController _controller = TextEditingController();
  late ScrollController _scrollController;

  bool showUnit = true;

  bool validate() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your height")));
      return false;
    }

    double? height = double.tryParse(_controller.text);
    if (height == null || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid height")),
      );
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = heightCm.round().toString();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(heightCm * 10);
    });

    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !showUnit) {
        setState(() => showUnit = true);
      } else if (_controller.text.isEmpty && showUnit) {
        setState(() => showUnit = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _feetToCm(double feet) => feet * 30.48;
  double _cmToFeet(double cm) => cm / 30.48;

  String _formatFeetInches(double cm) {
    final totalInches = (cm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet ft $inches in";
  }

  String _formatFeet(double cm) {
    final totalInches = (cm / 2.54).round();
    final feet = totalInches ~/ 12;
    return "$feet ft ";
  }

  String _formatInches(double cm) {
    final totalInches = (cm / 2.54).round();
    final inches = totalInches % 12;
    return "$inches in";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final glowColor = AppColors.text(context);
    final subTextColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);
    final tickWhite = isDark ? Colors.white : Colors.black;
    final tickGrey = isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    return OnboardingStep(
      title: "Your height",

      // ---------- TOGGLE ----------
      toggleWidget: ToggleButtons(
        isSelected: [unit == "cm", unit == "ft"],
        onPressed: (index) {
          setState(() {
            unit = index == 0 ? "cm" : "ft";
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: glowColor,
        fillColor: Colors.transparent,
        color: glowColor,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
        renderBorder: false,
        children: List.generate(2, (index) {
          bool selected = unit == (index == 0 ? "cm" : "ft");

          return Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: selected
                ? BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.black, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Colors.black, Colors.grey, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor),
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              index == 0 ? "CM" : "FT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: glowColor,
              ),
            ),
          );
        }),
      ),

      // ---------- CONTENT ----------
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeightDisplay(glowColor, subTextColor),
            const SizedBox(height: 60),

            SizedBox(
              height: 100,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // RED center indicator (unchanged)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Container(width: 3, color: Colors.redAccent),
                  ),

                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Container(height: 2, color: tickWhite),
                  ),

                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      double newHeight = (scrollInfo.metrics.pixels / 10).clamp(
                        0,
                        200,
                      );
                      setState(() {
                        heightCm = newHeight;
                        _controller.text = heightCm.round().toString();
                      });
                      return true;
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 201,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 2,
                      ),
                      itemBuilder: (context, index) {
                        bool isMajor = index % 10 == 0;
                        bool isMedium = index % 5 == 0 && !isMajor;

                        double tickHeight = isMajor
                            ? 100
                            : isMedium
                            ? 28
                            : 16;

                        Color tickColor = isMajor ? tickWhite : tickGrey;

                        return SizedBox(
                          width: 10,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 2,
                                height: tickHeight,
                                color: tickColor,
                              ),
                              if (isMajor)
                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    "$index",
                                    style: TextStyle(
                                      color: glowColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightDisplay(Color valueColor, Color unitColor) {
    return RichText(
      text: TextSpan(
        children: unit == "cm"
            ? [
                TextSpan(
                  text: "${heightCm.round()} ",
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "cm",
                  style: TextStyle(color: unitColor, fontSize: 32),
                ),
              ]
            : [
                TextSpan(
                  text: _formatFeet(heightCm),
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: _formatInches(heightCm),
                  style: TextStyle(color: unitColor, fontSize: 32),
                ),
              ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class GoalStep extends StatefulWidget {
  const GoalStep({super.key});

  @override
  State<GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends State<GoalStep> {
  final List<String> selectedGoals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDetailsBloc>().add(GetMasterGoalEvent());
    });
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
    OnboardingStorage.saveList("goals", selectedGoals);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.cardColor;
    final selectedBorderColor = theme.colorScheme.primary;
    final unSelectedBorderColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade400;

    final selectedTextColor = theme.colorScheme.onSurface;
    final unSelectedTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        final bloc = context.read<UserDetailsBloc>();

        if (state is MasterGoalLoadingState && bloc.masterGoalCache == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MasterGoalErrorState && bloc.masterGoalCache == null) {
          return Center(child: Text(state.message));
        }

        final goals = bloc.masterGoalCache?.data ?? [];

        if (goals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return OnboardingStep(
          title: "Your Goal",
          topSpacing: 20,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: goals.map((goal) {
                  final goalName = goal.displayName;
                  final isSelected = selectedGoals.contains(goalName);

                  return GestureDetector(
                    onTap: () => _toggleGoal(goalName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? selectedBorderColor
                              : unSelectedBorderColor,
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          goalName,
                          style: TextStyle(
                            color: isSelected
                                ? selectedTextColor
                                : unSelectedTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FocusAreaStep extends StatefulWidget {
  const FocusAreaStep({super.key});

  @override
  State<FocusAreaStep> createState() => _FocusAreaStepState();
}

class _FocusAreaStepState extends State<FocusAreaStep> {
  final List<String> selectedFocusAreas = [];
  List<String> focusAreas = [];

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsBloc>().add(GetFocusAreaEvent());
  }

  void _toggleFocusArea(String area) {
    setState(() {
      if (area == "Full Body") {
        if (selectedFocusAreas.contains("Full Body")) {
          selectedFocusAreas.clear();
        } else {
          selectedFocusAreas
            ..clear()
            ..addAll(focusAreas);
        }
      } else {
        if (selectedFocusAreas.contains(area)) {
          selectedFocusAreas.remove(area);
          selectedFocusAreas.remove("Full Body");
        } else {
          selectedFocusAreas.add(area);
          if (selectedFocusAreas.length == focusAreas.length - 1 &&
              !selectedFocusAreas.contains("Full Body")) {
            selectedFocusAreas.add("Full Body");
          }
        }
      }
      OnboardingStorage.saveList("focus_areas", selectedFocusAreas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.cardColor;
    final selectedBorderColor = theme.colorScheme.primary;
    final unSelectedBorderColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade400;
    final selectedTextColor = theme.colorScheme.onSurface;
    final unSelectedTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return BlocConsumer<UserDetailsBloc, UserDetailsState>(
      listener: (context, state) {
        if (state is FocusAreaLoadedState) {
          setState(() {
            // Update list once when API data comes
            focusAreas = state.focusAreaResponse.data
                .map((e) => e.displayName)
                .toList();
          });
        }
      },
      builder: (context, state) {
        if (state is FocusAreaLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FocusAreaErrorState) {
          return Center(child: Text(state.message));
        }

        if (focusAreas.isEmpty) {
          return const SizedBox.shrink();
        }

        return OnboardingStep(
          title: "Focus Area",
          topSpacing: 20,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: focusAreas.map((area) {
                  final isSelected = selectedFocusAreas.contains(area);

                  return GestureDetector(
                    onTap: () => _toggleFocusArea(area),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? selectedBorderColor
                              : unSelectedBorderColor,
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          area,
                          style: TextStyle(
                            color: isSelected
                                ? selectedTextColor
                                : unSelectedTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotificationStep extends StatefulWidget {
  const NotificationStep({super.key});

  @override
  State<NotificationStep> createState() => _NotificationStepState();
}

class _NotificationStepState extends State<NotificationStep> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return OnboardingStep(
      title: "Enable Notifications",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Text(
          "Enable notifications so we can remind you about your goals, track your progress, and keep you motivated every day.",
          style: TextStyle(color: Colors.grey, fontSize: 20, height: 1.4),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class OnboardingStep extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? toggleWidget;
  final double topSpacing;

  const OnboardingStep({
    super.key,
    required this.title,
    required this.content,
    this.toggleWidget,
    this.topSpacing = 150,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.text(context);

    return Column(
      children: [
        const SizedBox(height: 50),

        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (toggleWidget != null) ...[
          const SizedBox(height: 20),
          toggleWidget!,
        ],

        // const SizedBox(height: 150),
        // SingleChildScrollView(child: Center(child: content)),
        //const SizedBox(height: 150),
        SizedBox(height: topSpacing),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: content,
          ),
        ),
      ],
    );
  }
}

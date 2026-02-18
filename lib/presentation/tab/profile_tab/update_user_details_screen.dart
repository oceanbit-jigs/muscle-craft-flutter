import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/user_details/domain/usecase/update_user_details_usecase.dart';
import '../../../features/user_details/presentations/bloc/user_details_bloc.dart';
import '../../../theme/color/colors.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key});

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController currentWeightController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();

  String gender = "Male";
  String heightUnit = "Cm";
  String currentWeightUnit = "Kg";
  String targetWeightUnit = "Kg";

  List<int> selectedGoals = [];
  List<int> selectedFocusAreas = [];
  int userDetailId = 0;

  @override
  void initState() {
    super.initState();

    context.read<UserDetailsBloc>().add(GetMasterGoalEvent());
    context.read<UserDetailsBloc>().add(GetFocusAreaEvent());
    context.read<UserDetailsBloc>().add(GetUserDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(title: const Text("Update User Details")),
      body: BlocListener<UserDetailsBloc, UserDetailsState>(
        listener: (context, state) {
          if (state is GetUserDetailsLoadingState) {
            showDialog(
              context: context,
              builder: (_) => Center(child: CircularProgressIndicator()),
            );
          }

          if (state is GetUserDetailsSuccessState) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            final user = state.userDetailResponse.data.userDetail;

            userDetailId = user.id;
            nameController.text = user.userName;
            gender = user.gender == 1
                ? "Male"
                : user.gender == 2
                ? "Female"
                : "Other";
            ageController.text = user.age.toString();

            heightController.text = user.height.toString();
            currentWeightController.text = user.currentWeight.toString();
            targetWeightController.text = user.targetWeight.toString();

            gender = user.gender;
            heightUnit = user.heightType;
            currentWeightUnit = user.currentWeightType;
            targetWeightUnit = user.targetWeightType;

            selectedGoals = state.userDetailResponse.data.goals
                .map((e) => e.id)
                .toList();
            selectedFocusAreas = state.userDetailResponse.data.focusAreas
                .map((e) => e.id)
                .toList();

            setState(() {});
          }

          if (state is UpdateUserDetailsSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User Details Updated Successfully"),
                duration: Duration(seconds: 1),
              ),
            );

            Navigator.pop(context);
            Navigator.pop(context);
          }

          if (state is UpdateUserDetailsErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(5),
              children: [
                _input(nameController, "User Name"),
                _genderDropdown(),
                _input(ageController, "Age", isNumber: true),
                _unitInputRow(
                  controller: heightController,
                  label: "Height",
                  unitValue: heightUnit,
                  units: const ["Cm", "Ft"],
                  onChanged: (val) => setState(() => heightUnit = val),
                ),
                _unitInputRow(
                  controller: currentWeightController,
                  label: "Current Weight",
                  unitValue: currentWeightUnit,
                  units: const ["Kg", "Lbs"],
                  onChanged: (val) => setState(() => currentWeightUnit = val),
                ),
                _unitInputRow(
                  controller: targetWeightController,
                  label: "Target Weight",
                  unitValue: targetWeightUnit,
                  units: const ["Kg", "Lbs"],
                  onChanged: (val) => setState(() => targetWeightUnit = val),
                ),
                const SizedBox(height: 20),
                Text(
                  "Select Goals",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 10),
                _buildGoals(),
                const SizedBox(height: 20),
                Text(
                  "Select Focus Areas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 10),
                _buildFocusAreas(),
                const SizedBox(height: 30),
                BlocBuilder<UserDetailsBloc, UserDetailsState>(
                  builder: (context, state) {
                    if (state is UpdateUserDetailsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(context),
                        foregroundColor: AppColors.buttonText(context),
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: _submitUpdate,
                      child: const Text("Update Details"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: gender,
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.card(context),
        ),
        items: const [
          DropdownMenuItem(value: "Male", child: Text("Male")),
          DropdownMenuItem(value: "Female", child: Text("Female")),
          DropdownMenuItem(value: "Other", child: Text("Other")),
        ],
        onChanged: (val) => setState(() => gender = val!),
      ),
    );
  }

  Widget _unitInputRow({
    required TextEditingController controller,
    required String label,
    required String unitValue,
    required List<String> units,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Required" : null,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColors.card(context),
              ),
              style: TextStyle(color: AppColors.text(context)),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: unitValue,
            items: units
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(color: AppColors.text(context)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoals() {
    final bloc = context.read<UserDetailsBloc>();
    final data = bloc.masterGoalCache;

    if (data == null) return const SizedBox();

    return Wrap(
      spacing: 10,
      children: data.data.map((goal) {
        final isSelected = selectedGoals.contains(goal.id);
        return ChoiceChip(
          label: Text(
            goal.name.toString(),
            style: TextStyle(color: AppColors.text(context)),
          ),
          selected: isSelected,
          backgroundColor: AppColors.card(context),
          selectedColor: AppColors.secondary(context),
          onSelected: (val) {
            setState(() {
              val ? selectedGoals.add(goal.id) : selectedGoals.remove(goal.id);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFocusAreas() {
    final bloc = context.read<UserDetailsBloc>();
    final data = bloc.focusAreaCache;

    if (data == null) return const SizedBox();

    return Wrap(
      spacing: 10,
      children: data.data.map((focus) {
        final isSelected = selectedFocusAreas.contains(focus.id);
        return FilterChip(
          label: Text(
            focus.name.toString(),
            style: TextStyle(color: AppColors.text(context)),
          ),
          selected: isSelected,
          backgroundColor: AppColors.card(context),
          selectedColor: AppColors.secondary(context),
          onSelected: (val) {
            setState(() {
              val
                  ? selectedFocusAreas.add(focus.id)
                  : selectedFocusAreas.remove(focus.id);
            });
          },
        );
      }).toList(),
    );
  }

  void _submitUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final params = UpdateUserDetailsParams(
      userDetailId: userDetailId,
      userName: nameController.text,
      gender: gender,
      age: int.parse(ageController.text),
      height: double.parse(heightController.text),
      heightUnit: heightUnit,
      currentWeight: double.parse(currentWeightController.text),
      currentWeightUnit: currentWeightUnit,
      targetWeight: double.parse(targetWeightController.text),
      targetWeightUnit: targetWeightUnit,
      goalIds: selectedGoals,
      focusAreaIds: selectedFocusAreas,
    );

    context.read<UserDetailsBloc>().add(UpdateUserDetailsEvent(params));
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        style: TextStyle(color: AppColors.text(context)),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card(context),
        ),
      ),
    );
  }
}

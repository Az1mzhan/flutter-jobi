import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/utils/validators.dart';
import 'package:jobi/core/widgets/app_text_field.dart';
import 'package:jobi/core/widgets/primary_button.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';
import 'package:jobi/features/profile/presentation/cubit/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _aboutController = TextEditingController();
  final _allProfessions = const [
    'Маляр',
    'Отделочник',
    'Электрик',
    'Сантехник',
    'Грузчик',
    'Бригадир',
  ];
  final _selectedProfessions = <String>{};
  bool _seeded = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _seed(UserProfile profile) {
    if (_seeded) return;
    _fullNameController.text = profile.fullName;
    _cityController.text = profile.city;
    _regionController.text = profile.region;
    _aboutController.text = profile.about;
    _selectedProfessions
      ..clear()
      ..addAll(profile.professions);
    _seeded = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.message != current.message,
      listener: (context, state) {
        if (state.status == ProfileStatus.loaded && _seeded) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(content: Text(l10n.text('profileUpdated'))),
            );
          context.pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        _seed(profile);

        return Scaffold(
          appBar: AppBar(title: Text(l10n.text('editProfile'))),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    AppTextField(
                      controller: _fullNameController,
                      label: l10n.text('fullName'),
                      validator: (value) =>
                          Validators.required(value, fieldName: l10n.text('fullName')),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _cityController,
                      label: l10n.text('city'),
                      validator: (value) =>
                          Validators.required(value, fieldName: l10n.text('city')),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _regionController,
                      label: l10n.text('region'),
                      validator: (value) =>
                          Validators.required(value, fieldName: l10n.text('region')),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _aboutController,
                      label: l10n.text('about'),
                      maxLines: 4,
                      validator: (value) =>
                          Validators.required(value, fieldName: l10n.text('about')),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.text('professions'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _allProfessions
                          .map(
                            (profession) => FilterChip(
                              label: Text(profession),
                              selected: _selectedProfessions.contains(profession),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedProfessions.add(profession);
                                  } else {
                                    _selectedProfessions.remove(profession);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: l10n.text('saveChanges'),
                      isLoading: state.status == ProfileStatus.saving,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileCubit>().saveProfile(
                                profile.copyWith(
                                  fullName: _fullNameController.text.trim(),
                                  city: _cityController.text.trim(),
                                  region: _regionController.text.trim(),
                                  about: _aboutController.text.trim(),
                                  professions: _selectedProfessions.toList(),
                                ),
                              );
                        }
                      },
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
}

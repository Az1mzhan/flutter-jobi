import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/utils/validators.dart';
import 'package:jobi/core/widgets/app_text_field.dart';
import 'package:jobi/core/widgets/primary_button.dart';
import 'package:jobi/features/brigades/presentation/cubit/brigades_cubit.dart';

class CreateBrigadePage extends StatefulWidget {
  const CreateBrigadePage({super.key});

  @override
  State<CreateBrigadePage> createState() => _CreateBrigadePageState();
}

class _CreateBrigadePageState extends State<CreateBrigadePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _leaderController = TextEditingController(text: 'Айдана К.');

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _leaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BrigadesCubit, BrigadesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.message != current.message,
      listener: (context, state) {
        if (state.status == BrigadesStatus.error && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.text('createBrigadeTitle'))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: l10n.text('brigadeName'),
                    validator: (value) => Validators.required(
                      value,
                      fieldName: l10n.text('brigadeName'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _leaderController,
                    label: l10n.text('leaderName'),
                    validator: (value) => Validators.required(
                      value,
                      fieldName: l10n.text('leaderName'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descriptionController,
                    label: l10n.text('description'),
                    maxLines: 4,
                    validator: (value) => Validators.required(
                      value,
                      fieldName: l10n.text('description'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<BrigadesCubit, BrigadesState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        label: l10n.text('createBrigade'),
                        isLoading: state.status == BrigadesStatus.saving,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final brigade = await context.read<BrigadesCubit>().createBrigade(
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                leaderName: _leaderController.text.trim(),
                              );
                          if (brigade != null && context.mounted) {
                            context.go('/brigades/${brigade.id}');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

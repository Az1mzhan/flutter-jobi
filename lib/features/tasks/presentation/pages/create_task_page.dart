import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/utils/validators.dart';
import 'package:jobi/core/widgets/app_text_field.dart';
import 'package:jobi/core/widgets/primary_button.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/presentation/cubit/tasks_cubit.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController(text: 'Almaty');
  final _regionController = TextEditingController(text: 'Almaty Region');
  final _locationController = TextEditingController(text: 'Abay Avenue 25');
  final _priceController = TextEditingController(text: '70000');
  final _durationController = TextEditingController(text: '8');
  final _startTimeController = TextEditingController();
  final _professions = const ['Painter', 'Loader', 'Electrician', 'Plumber'];
  String _selectedProfession = 'Painter';
  bool _urgent = false;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 6));

  @override
  void initState() {
    super.initState();
    _syncStartTimeLabel();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }

  void _syncStartTimeLabel() {
    _startTimeController.text = DateFormat('d MMM yyyy · HH:mm').format(_startTime);
  }

  Future<void> _pickStartTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (pickedTime == null) return;

    setState(() {
      _startTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _syncStartTimeLabel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.message != current.message,
      listener: (context, state) {
        if (state.status == TasksStatus.error && state.message != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create task')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedProfession,
                    items: _professions
                        .map(
                          (profession) => DropdownMenuItem(
                            value: profession,
                            child: Text(profession),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedProfession = value);
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Profession'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 4,
                    validator: (value) =>
                        Validators.required(value, fieldName: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _locationController,
                    label: 'Location address',
                    validator: (value) =>
                        Validators.required(value, fieldName: 'Location'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _cityController,
                    label: 'City',
                    validator: (value) =>
                        Validators.required(value, fieldName: 'City'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _regionController,
                    label: 'Region',
                    validator: (value) =>
                        Validators.required(value, fieldName: 'Region'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _priceController,
                    label: 'Price (KZT)',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.required(value, fieldName: 'Price'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _durationController,
                    label: 'Duration (hours)',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.required(value, fieldName: 'Duration'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _startTimeController,
                    label: 'Start time',
                    readOnly: true,
                    onTap: _pickStartTime,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    value: _urgent,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) => setState(() => _urgent = value),
                    title: const Text('Urgent'),
                    subtitle: const Text('Highlight the task for faster matching'),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<TasksCubit, TasksState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        label: 'Publish task',
                        isLoading: state.status == TasksStatus.saving,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final task = TaskEntity(
                            id: '',
                            professionId: _selectedProfession.toLowerCase(),
                            professionName: _selectedProfession,
                            description: _descriptionController.text.trim(),
                            locationName: _locationController.text.trim(),
                            latitude: 43.238949,
                            longitude: 76.889709,
                            cityId: _cityController.text.trim().toLowerCase(),
                            regionId: _regionController.text.trim().toLowerCase(),
                            cityName: _cityController.text.trim(),
                            regionName: _regionController.text.trim(),
                            price: double.tryParse(_priceController.text.trim()) ?? 0,
                            startTime: _startTime,
                            durationHours:
                                int.tryParse(_durationController.text.trim()) ?? 1,
                            urgent: _urgent,
                            status: TaskStatus.open,
                            employerName: 'Current employer',
                            workerName: null,
                            createdAt: DateTime.now(),
                          );

                          final created = await context.read<TasksCubit>().createTask(task);
                          if (created != null && context.mounted) {
                            context.go('/tasks/${created.id}');
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

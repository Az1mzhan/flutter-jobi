import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/brigades/presentation/cubit/brigades_cubit.dart';

class BrigadeDetailPage extends StatefulWidget {
  const BrigadeDetailPage({super.key, required this.brigadeId});

  final String brigadeId;

  @override
  State<BrigadeDetailPage> createState() => _BrigadeDetailPageState();
}

class _BrigadeDetailPageState extends State<BrigadeDetailPage> {
  final _memberController = TextEditingController();
  final _roleController = TextEditingController(text: 'Specialist');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrigadesCubit>().openBrigade(widget.brigadeId);
    });
  }

  @override
  void dispose() {
    _memberController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrigadesCubit, BrigadesState>(
      builder: (context, state) {
        final brigade = state.selectedBrigade;
        if (state.status == BrigadesStatus.loading && brigade == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == BrigadesStatus.error && brigade == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Brigade')),
            body: ErrorStateView(
              message: state.message ?? 'Unable to load brigade',
              onRetry: () => context.read<BrigadesCubit>().openBrigade(widget.brigadeId),
            ),
          );
        }

        if (brigade == null) {
          return const Scaffold(
            body: EmptyStateView(
              title: 'Brigade not found',
              message: 'This brigade is missing from the current demo state.',
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(brigade.name)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brigade.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _BrigadeMetric(
                              label: 'Leader',
                              value: brigade.leaderName,
                            ),
                            _BrigadeMetric(
                              label: 'Rating',
                              value: brigade.rating.toStringAsFixed(1),
                            ),
                            _BrigadeMetric(
                              label: 'Active tasks',
                              value: '${brigade.activeTasks}',
                            ),
                            _BrigadeMetric(
                              label: 'Completed',
                              value: '${brigade.completedTasks}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Members',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...brigade.members.map(
                          (member) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(member.fullName),
                            subtitle: Text(member.role),
                            trailing: IconButton(
                              onPressed: () => context.read<BrigadesCubit>().removeMember(
                                    brigadeId: brigade.id,
                                    memberId: member.id,
                                  ),
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add member',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _memberController,
                          decoration: const InputDecoration(labelText: 'Full name'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _roleController,
                          decoration: const InputDecoration(labelText: 'Role'),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_memberController.text.trim().isEmpty) return;
                              context.read<BrigadesCubit>().addMember(
                                    brigadeId: brigade.id,
                                    fullName: _memberController.text.trim(),
                                    role: _roleController.text.trim().isEmpty
                                        ? 'Specialist'
                                        : _roleController.text.trim(),
                                  );
                              _memberController.clear();
                            },
                            child: const Text('Add member'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brigade tasks',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'This area is reserved for brigade-scoped task assignment and statistics once the backend brigade task contract is connected.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrigadeMetric extends StatelessWidget {
  const _BrigadeMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/brigades/presentation/cubit/brigades_cubit.dart';

class BrigadesPage extends StatefulWidget {
  const BrigadesPage({super.key});

  @override
  State<BrigadesPage> createState() => _BrigadesPageState();
}

class _BrigadesPageState extends State<BrigadesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<BrigadesCubit>().state.status == BrigadesStatus.initial) {
        context.read<BrigadesCubit>().loadBrigades();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrigadesCubit, BrigadesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Brigades'),
            actions: [
              IconButton(
                onPressed: () => context.push('/brigades/create'),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status == BrigadesStatus.loading && state.brigades.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == BrigadesStatus.error && state.brigades.isEmpty) {
                  return ErrorStateView(
                    message: state.message ?? 'Unable to load brigades',
                    onRetry: () => context.read<BrigadesCubit>().loadBrigades(),
                  );
                }

                if (state.brigades.isEmpty) {
                  return EmptyStateView(
                    title: 'No brigades yet',
                    message: 'Create a brigade to coordinate a team and share tasks.',
                    actionLabel: 'Create brigade',
                    onAction: () => context.push('/brigades/create'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<BrigadesCubit>().loadBrigades(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.brigades.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final brigade = state.brigades[index];
                      return Card(
                        child: ListTile(
                          onTap: () => context.push('/brigades/${brigade.id}'),
                          title: Text(brigade.name),
                          subtitle: Text(
                            '${brigade.memberCount} members · ${brigade.completedTasks} completed jobs',
                          ),
                          trailing: Chip(label: Text('${brigade.rating.toStringAsFixed(1)} ★')),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

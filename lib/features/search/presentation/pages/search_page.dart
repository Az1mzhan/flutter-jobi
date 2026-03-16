import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/search/presentation/cubit/search_cubit.dart';
import 'package:jobi/features/tasks/presentation/widgets/task_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<SearchCubit>().state.status == SearchStatus.initial) {
        context.read<SearchCubit>().load();
      }
    });
  }

  Future<void> _openFilters(BuildContext context, SearchState state) async {
    final cityController = TextEditingController(text: state.filters.city);
    final regionController = TextEditingController(text: state.filters.region);
    final districtController = TextEditingController(text: state.filters.district);
    final professionController = TextEditingController(text: state.filters.profession);
    var radiusKm = state.filters.radiusKm;
    var availableOnly = state.filters.availableOnly;
    var nationwide = state.filters.nationwide;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text('Radius: ${radiusKm.toStringAsFixed(0)} km'),
                    Slider(
                      min: 0.5,
                      max: 100,
                      divisions: 40,
                      value: radiusKm,
                      onChanged: nationwide
                          ? null
                          : (value) => setModalState(() => radiusKm = value),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: regionController,
                      decoration: const InputDecoration(labelText: 'Region'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: districtController,
                      decoration: const InputDecoration(labelText: 'District'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: professionController,
                      decoration: const InputDecoration(labelText: 'Profession'),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      value: availableOnly,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) =>
                          setModalState(() => availableOnly = value),
                      title: const Text('Available only'),
                    ),
                    SwitchListTile.adaptive(
                      value: nationwide,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) => setModalState(() => nationwide = value),
                      title: const Text('Search across Kazakhstan'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SearchCubit>().applyFilters(
                                state.filters.copyWith(
                                  radiusKm: radiusKm,
                                  city: cityController.text.trim(),
                                  region: regionController.text.trim(),
                                  district: districtController.text.trim(),
                                  profession: professionController.text.trim(),
                                  availableOnly: availableOnly,
                                  nationwide: nationwide,
                                ),
                              );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Apply filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final itemsAreEmpty = state.mode == SearchMode.workers
            ? state.workers.isEmpty
            : state.tasks.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
            actions: [
              IconButton(
                onPressed: () => _openFilters(context, state),
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SegmentedButton<SearchMode>(
                    segments: const [
                      ButtonSegment(
                        value: SearchMode.workers,
                        label: Text('Workers'),
                        icon: Icon(Icons.people_alt_outlined),
                      ),
                      ButtonSegment(
                        value: SearchMode.tasks,
                        label: Text('Tasks'),
                        icon: Icon(Icons.assignment_outlined),
                      ),
                    ],
                    selected: {state.mode},
                    onSelectionChanged: (selection) {
                      context.read<SearchCubit>().switchMode(selection.first);
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _MiniFilter(label: '${state.filters.radiusKm.toStringAsFixed(0)} km'),
                      if (state.filters.city.isNotEmpty)
                        _MiniFilter(label: state.filters.city),
                      if (state.filters.profession.isNotEmpty)
                        _MiniFilter(label: state.filters.profession),
                      if (state.filters.availableOnly)
                        const _MiniFilter(label: 'Available now'),
                      if (state.filters.nationwide)
                        const _MiniFilter(label: 'Kazakhstan'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    padding: const EdgeInsets.all(18),
                    child: const Row(
                      children: [
                        Icon(Icons.map_outlined, size: 34),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Map-ready architecture placeholder for future geo view.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == SearchStatus.loading && itemsAreEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == SearchStatus.error && itemsAreEmpty) {
                        return ErrorStateView(
                          message: state.message ?? 'Search failed',
                          onRetry: () => context.read<SearchCubit>().load(),
                        );
                      }

                      if (itemsAreEmpty) {
                        return EmptyStateView(
                          title: 'No results yet',
                          message:
                              'Try widening the radius, changing city filters, or switching search mode.',
                          actionLabel: 'Adjust filters',
                          onAction: () => _openFilters(context, state),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => context.read<SearchCubit>().load(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: (state.mode == SearchMode.workers
                                  ? state.workers.length
                                  : state.tasks.length) +
                              1,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final items =
                                state.mode == SearchMode.workers ? state.workers : state.tasks;
                            if (index == items.length) {
                              if (!state.hasMore) return const SizedBox(height: 24);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: OutlinedButton(
                                  onPressed: () => context.read<SearchCubit>().loadMore(),
                                  child: const Text('Load more'),
                                ),
                              );
                            }

                            if (state.mode == SearchMode.workers) {
                              final worker = state.workers[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              worker.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Chip(label: Text('${worker.rating} ★')),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(worker.profession),
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _MiniFilter(label: worker.city),
                                          _MiniFilter(
                                            label: '${worker.distanceKm.toStringAsFixed(1)} km',
                                          ),
                                          if (worker.availableNow)
                                            const _MiniFilter(label: 'Available'),
                                          if (worker.readyToTravel)
                                            const _MiniFilter(label: 'Travel ready'),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '${worker.completedTasks} completed jobs',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return TaskCard(
                              task: state.tasks[index],
                              onTap: () => context.push('/tasks/${state.tasks[index].id}'),
                            );
                          },
                        ),
                      );
                    },
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

class _MiniFilter extends StatelessWidget {
  const _MiniFilter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(label)),
    );
  }
}

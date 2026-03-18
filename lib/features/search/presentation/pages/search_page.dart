import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
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
    final l10n = context.l10n;
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
                      l10n.text('searchFilters'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.format(
                        'radiusKm',
                        {'value': radiusKm.toStringAsFixed(0)},
                      ),
                    ),
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
                      decoration: InputDecoration(labelText: l10n.text('city')),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: regionController,
                      decoration: InputDecoration(labelText: l10n.text('region')),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: districtController,
                      decoration: InputDecoration(labelText: l10n.text('district')),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: professionController,
                      decoration: InputDecoration(labelText: l10n.text('profession')),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      value: availableOnly,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) =>
                          setModalState(() => availableOnly = value),
                      title: Text(l10n.text('availableOnly')),
                    ),
                    SwitchListTile.adaptive(
                      value: nationwide,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) => setModalState(() => nationwide = value),
                      title: Text(l10n.text('searchAcrossKazakhstan')),
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
                        child: Text(l10n.text('applyFilters')),
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
    final l10n = context.l10n;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final itemsAreEmpty = state.mode == SearchMode.workers
            ? state.workers.isEmpty
            : state.tasks.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.text('searchTitle')),
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
                    segments: [
                      ButtonSegment(
                        value: SearchMode.workers,
                        label: Text(l10n.text('workers')),
                        icon: const Icon(Icons.people_alt_outlined),
                      ),
                      ButtonSegment(
                        value: SearchMode.tasks,
                        label: Text(l10n.text('tasks')),
                        icon: const Icon(Icons.assignment_outlined),
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
                      _MiniFilter(
                        label: l10n.format(
                          'radiusKm',
                          {'value': state.filters.radiusKm.toStringAsFixed(0)},
                        ),
                      ),
                      if (state.filters.city.isNotEmpty)
                        _MiniFilter(label: state.filters.city),
                      if (state.filters.profession.isNotEmpty)
                        _MiniFilter(label: state.filters.profession),
                      if (state.filters.availableOnly)
                        _MiniFilter(label: l10n.text('availableNow')),
                      if (state.filters.nationwide)
                        _MiniFilter(label: l10n.text('kazakhstan')),
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
                    child: Row(
                      children: [
                        const Icon(Icons.map_outlined, size: 34),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(l10n.text('mapReadyPlaceholder')),
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
                          message: state.message ?? l10n.text('searchFailed'),
                          onRetry: () => context.read<SearchCubit>().load(),
                        );
                      }

                      if (itemsAreEmpty) {
                        return EmptyStateView(
                          title: l10n.text('noResultsYet'),
                          message: l10n.text('searchEmptyHint'),
                          actionLabel: l10n.text('adjustFilters'),
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
                                  child: Text(l10n.text('loadMore')),
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
                                          Chip(
                                            label: Text('${worker.rating.toStringAsFixed(1)} ★'),
                                          ),
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
                                            label:
                                                '${worker.distanceKm.toStringAsFixed(1)} км',
                                          ),
                                          if (worker.availableNow)
                                            _MiniFilter(label: l10n.text('available')),
                                          if (worker.readyToTravel)
                                            _MiniFilter(label: l10n.text('travelReady')),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.format(
                                          'completedJobs',
                                          {'count': '${worker.completedTasks}'},
                                        ),
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

import 'package:flutter/material.dart';
import '../data/project_data.dart';
import '../services/favorites_service.dart';
import '../widgets/section_header.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  final ValueChanged<int> onProjectTap;

  const ProjectsScreen({super.key, required this.onProjectTap});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  final FavoritesService _favoritesService = FavoritesService.instance;

  @override
  void initState() {
    super.initState();
    _favoritesService.onChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    _favoritesService.onChanged = null;
    super.dispose();
  }

  List<int> get _filteredIndices {
    var indices = List.generate(ProjectData.allProjects.length, (i) => i);

    // Filter by favorites
    if (_showFavoritesOnly) {
      indices = indices.where((i) => _favoritesService.isFavorite(i)).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      indices = indices.where((i) {
        final p = ProjectData.allProjects[i];
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.tags.any((t) => t.toLowerCase().contains(query)) ||
            p.longDescription.toLowerCase().contains(query);
      }).toList();
    }

    return indices;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredIndices = _filteredIndices;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primaryContainer.withValues(alpha: 0.2),
                  colorScheme.surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Projects'),
                const SizedBox(height: 8),
                Text(
                  'A selection of projects I\'ve built — from web apps to mobile and automation tools.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),

                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search projects, tags, or keywords...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter chips row
                Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: !_showFavoritesOnly,
                      onSelected: (_) =>
                          setState(() => _showFavoritesOnly = false),
                      selectedColor: colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite, size: 14),
                          const SizedBox(width: 4),
                          Text('Favorites (${_favoritesService.favorites.length})'),
                        ],
                      ),
                      selected: _showFavoritesOnly,
                      onSelected: (_) =>
                          setState(() => _showFavoritesOnly = true),
                      selectedColor: colorScheme.primaryContainer,
                    ),
                    const Spacer(),
                    Text(
                      '${filteredIndices.length} project${filteredIndices.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Project Cards
        if (filteredIndices.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    _showFavoritesOnly ? Icons.favorite_border : Icons.search_off,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showFavoritesOnly
                        ? 'No favorites yet.\nTap the heart icon on projects to save them.'
                        : 'No projects match your search.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: filteredIndices.map((index) {
                  final p = ProjectData.allProjects[index];
                  return _AnimatedProjectCard(
                    name: p.name,
                    description: p.description,
                    tags: p.tags,
                    url: p.url,
                    isFavorite: _favoritesService.isFavorite(index),
                    onFavoriteToggle: () {
                      _favoritesService.toggleFavorite(index);
                    },
                    onTap: () => widget.onProjectTap(index),
                  );
                }).toList(),
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _AnimatedProjectCard extends StatelessWidget {
  final String name;
  final String description;
  final List<String> tags;
  final String url;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _AnimatedProjectCard({
    required this.name,
    required this.description,
    required this.tags,
    required this.url,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: child,
            ),
          ),
        );
      },
      child: ProjectCard(
        name: name,
        description: description,
        tags: tags,
        url: url,
        isFavorite: isFavorite,
        onFavoriteToggle: onFavoriteToggle,
        onTap: onTap,
      ),
    );
  }
}

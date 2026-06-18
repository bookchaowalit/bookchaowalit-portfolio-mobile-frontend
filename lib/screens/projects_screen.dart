import 'package:flutter/material.dart';
import '../data/project_data.dart';
import '../widgets/section_header.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  final ValueChanged<int> onProjectTap;

  const ProjectsScreen({super.key, required this.onProjectTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
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
              ],
            ),
          ),
        ),

        // Project Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              children: List.generate(ProjectData.allProjects.length, (index) {
                final p = ProjectData.allProjects[index];
                return _AnimatedProjectCard(
                  name: p.name,
                  description: p.description,
                  tags: p.tags,
                  url: p.url,
                  onTap: () => onProjectTap(index),
                );
              }),
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
  final VoidCallback onTap;

  const _AnimatedProjectCard({
    required this.name,
    required this.description,
    required this.tags,
    required this.url,
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
        onTap: onTap,
      ),
    );
  }
}

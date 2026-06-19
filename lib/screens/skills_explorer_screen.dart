import 'package:flutter/material.dart';
import '../widgets/section_header.dart';

/// Data model for a skill with category and proficiency.
class _SkillEntry {
  final String name;
  final String category;
  final double proficiency; // 0.0 - 1.0
  final IconData icon;
  final String detail;

  const _SkillEntry({
    required this.name,
    required this.category,
    required this.proficiency,
    required this.icon,
    required this.detail,
  });
}

/// Interactive skills explorer with animated proficiency bars and category filtering.
class SkillsExplorerScreen extends StatefulWidget {
  const SkillsExplorerScreen({super.key});

  @override
  State<SkillsExplorerScreen> createState() => _SkillsExplorerScreenState();
}

class _SkillsExplorerScreenState extends State<SkillsExplorerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String _selectedCategory = 'All';
  int? _expandedIndex;

  static const List<_SkillEntry> _skills = [
    // Frontend
    _SkillEntry(name: 'Flutter', category: 'Frontend', proficiency: 0.85, icon: Icons.phone_android, detail: 'Material Design 3, state management, animations, platform channels'),
    _SkillEntry(name: 'Dart', category: 'Frontend', proficiency: 0.85, icon: Icons.code, detail: 'Async programming, generics, mixins, null safety'),
    _SkillEntry(name: 'React', category: 'Frontend', proficiency: 0.80, icon: Icons.web, detail: 'Hooks, context, server components, performance optimization'),
    _SkillEntry(name: 'Next.js', category: 'Frontend', proficiency: 0.85, icon: Icons.language, detail: 'App Router, SSR/SSG, API routes, middleware, i18n'),
    _SkillEntry(name: 'TypeScript', category: 'Frontend', proficiency: 0.80, icon: Icons.data_object, detail: 'Type system, generics, utility types, declaration files'),
    _SkillEntry(name: 'HTML/CSS', category: 'Frontend', proficiency: 0.90, icon: Icons.style, detail: 'Semantic HTML, CSS Grid, Flexbox, responsive design'),
    // Backend
    _SkillEntry(name: 'Python', category: 'Backend', proficiency: 0.80, icon: Icons.terminal, detail: 'FastAPI, Django, data processing, automation scripts'),
    _SkillEntry(name: 'Node.js', category: 'Backend', proficiency: 0.75, icon: Icons.dns, detail: 'Express, middleware, REST APIs, real-time with WebSockets'),
    _SkillEntry(name: 'FastAPI', category: 'Backend', proficiency: 0.80, icon: Icons.bolt, detail: 'Async endpoints, Pydantic models, dependency injection'),
    _SkillEntry(name: 'PostgreSQL', category: 'Backend', proficiency: 0.75, icon: Icons.storage, detail: 'Query optimization, indexing, migrations, relations'),
    _SkillEntry(name: 'SQLite', category: 'Backend', proficiency: 0.70, icon: Icons.storage, detail: 'Lightweight storage, concurrent access, full-text search'),
    // DevOps & Tools
    _SkillEntry(name: 'Docker', category: 'DevOps', proficiency: 0.75, icon: Icons.layers, detail: 'Multi-stage builds, compose, networking, volumes'),
    _SkillEntry(name: 'AWS', category: 'DevOps', proficiency: 0.70, icon: Icons.cloud, detail: 'EC2, S3, Lambda, RDS, CloudFront'),
    _SkillEntry(name: 'Cloudflare', category: 'DevOps', proficiency: 0.80, icon: Icons.shield, detail: 'Workers, Pages, DNS, CDN, tunnel'),
    _SkillEntry(name: 'Vercel', category: 'DevOps', proficiency: 0.85, icon: Icons.rocket_launch, detail: 'Edge functions, preview deployments, analytics'),
    _SkillEntry(name: 'CI/CD', category: 'DevOps', proficiency: 0.80, icon: Icons.sync_alt, detail: 'GitHub Actions, automated testing, deployment pipelines'),
    _SkillEntry(name: 'Git', category: 'DevOps', proficiency: 0.85, icon: Icons.account_tree, detail: 'Branching strategies, rebasing, hooks, monorepos'),
  ];

  static List<String> get _categories {
    final cats = _skills.map((s) => s.category).toSet().toList();
    return ['All', ...cats];
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<_SkillEntry> get _filteredSkills {
    if (_selectedCategory == 'All') return _skills;
    return _skills.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filteredSkills;

    return Scaffold(
      body: CustomScrollView(
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
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      const SectionHeader(title: 'Skills Explorer'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap a skill to learn more. Proficiency levels reflect self-assessed confidence.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Category filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat;
                                _expandedIndex = null;
                              });
                            },
                            selectedColor: colorScheme.primaryContainer,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  _StatBadge(
                    label: 'Skills',
                    value: '${filtered.length}',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 12),
                  _StatBadge(
                    label: 'Avg Proficiency',
                    value: '${(filtered.map((s) => s.proficiency).reduce((a, b) => a + b) / filtered.length * 100).round()}%',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 12),
                  _StatBadge(
                    label: 'Categories',
                    value: '${_categories.length - 1}',
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),

          // Skills list
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                children: List.generate(filtered.length, (i) {
                  final skill = filtered[i];
                  final isExpanded = _expandedIndex == i;
                  return _SkillTile(
                    skill: skill,
                    isExpanded: isExpanded,
                    animation: _animController,
                    colorScheme: colorScheme,
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : i;
                      });
                    },
                  );
                }),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  final _SkillEntry skill;
  final bool isExpanded;
  final AnimationController animation;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _SkillTile({
    required this.skill,
    required this.isExpanded,
    required this.animation,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedCrossFade(
        firstChild: _buildCollapsed(context),
        secondChild: _buildExpanded(context),
        crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(skill.icon, size: 20, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        skill.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(skill.proficiency * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Animated proficiency bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: skill.proficiency * animation.value,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorScheme.primary,
                    minHeight: 6,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(skill.icon, size: 20, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        skill.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(skill.proficiency * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.proficiency,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Expertise',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              skill.detail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

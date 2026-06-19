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
    // AI & Data
    _SkillEntry(name: 'Machine Learning', category: 'AI & Data', proficiency: 0.65, icon: Icons.psychology, detail: 'Scikit-learn, model training, feature engineering, evaluation metrics'),
    _SkillEntry(name: 'TensorFlow', category: 'AI & Data', proficiency: 0.60, icon: Icons.memory, detail: 'Neural networks, TFLite for mobile, transfer learning, model optimization'),
    _SkillEntry(name: 'Data Analysis', category: 'AI & Data', proficiency: 0.75, icon: Icons.analytics, detail: 'Pandas, NumPy, data visualization, statistical analysis, ETL pipelines'),
    _SkillEntry(name: 'NLP', category: 'AI & Data', proficiency: 0.60, icon: Icons.chat, detail: 'Text processing, sentiment analysis, transformers, LLM integration'),
    // Blockchain
    _SkillEntry(name: 'Solidity', category: 'Blockchain', proficiency: 0.55, icon: Icons.link, detail: 'Smart contracts, ERC-20/721 tokens, DeFi protocols, gas optimization'),
    _SkillEntry(name: 'Web3.js', category: 'Blockchain', proficiency: 0.55, icon: Icons.currency_exchange, detail: 'Ethereum integration, wallet connections, contract interaction, dApp frontends'),
    _SkillEntry(name: 'Smart Contracts', category: 'Blockchain', proficiency: 0.50, icon: Icons.gavel, detail: 'Contract auditing, upgradeable patterns, Hardhat testing, deployment'),
    // IoT
    _SkillEntry(name: 'Embedded Systems', category: 'IoT', proficiency: 0.60, icon: Icons.memory, detail: 'Microcontrollers, GPIO, sensor integration, real-time processing'),
    _SkillEntry(name: 'MQTT', category: 'IoT', proficiency: 0.65, icon: Icons.wifi, detail: 'Pub/sub messaging, broker setup, QoS levels, IoT communication protocols'),
    _SkillEntry(name: 'Raspberry Pi', category: 'IoT', proficiency: 0.70, icon: Icons.developer_board, detail: 'Linux configuration, Python scripts, hardware interfacing, edge computing'),
    _SkillEntry(name: 'Arduino', category: 'IoT', proficiency: 0.65, icon: Icons.settings_input_component, detail: 'C/C++ programming, sensor libraries, motor control, prototyping'),
    // Game Dev
    _SkillEntry(name: 'Unity', category: 'Game Dev', proficiency: 0.60, icon: Icons.sports_esports, detail: 'C# scripting, physics engine, UI systems, asset management, builds'),
    _SkillEntry(name: 'Game Mechanics', category: 'Game Dev', proficiency: 0.65, icon: Icons.videogame_asset, detail: 'Player controllers, inventory systems, AI behavior, level design'),
    _SkillEntry(name: '2D/3D Graphics', category: 'Game Dev', proficiency: 0.55, icon: Icons.view_in_ar, detail: 'Sprite animation, shaders, lighting, particle systems, optimization'),
    // Deep Tech
    _SkillEntry(name: 'Computer Vision', category: 'Deep Tech', proficiency: 0.60, icon: Icons.visibility, detail: 'OpenCV, image processing, object detection, real-time video analysis'),
    _SkillEntry(name: 'Robotics', category: 'Deep Tech', proficiency: 0.50, icon: Icons.smart_toy, detail: 'ROS basics, sensor fusion, path planning, autonomous navigation'),
    _SkillEntry(name: 'Edge AI', category: 'Deep Tech', proficiency: 0.55, icon: Icons.speed, detail: 'Model quantization, TFLite Mobile, ONNX runtime, hardware acceleration'),
    // XR & VR
    _SkillEntry(name: 'AR Development', category: 'XR & VR', proficiency: 0.55, icon: Icons.view_in_ar, detail: 'ARKit, ARCore, marker tracking, spatial anchors, 3D overlays'),
    _SkillEntry(name: 'VR Development', category: 'XR & VR', proficiency: 0.50, icon: Icons.vrpano, detail: 'Unity XR, Oculus SDK, hand tracking, immersive environments'),
    _SkillEntry(name: '3D Modeling', category: 'XR & VR', proficiency: 0.45, icon: Icons.interests, detail: 'Blender basics, mesh optimization, texture mapping, export pipelines'),
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

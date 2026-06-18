import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section_header.dart';
import '../widgets/skill_chip.dart';
import '../widgets/project_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Hero Section with animation
          SliverToBoxAdapter(
            child: _HeroSection(colorScheme: colorScheme),
          ),

          // About snippet
          SliverToBoxAdapter(
            child: _AnimatedSection(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'About'),
                    const SizedBox(height: 16),
                    Text(
                      'Tech Generalist & Solopreneur building full-stack products, integrating AI systems, and growing digital presence — from idea to deployment.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(icon: Icons.location_on, label: 'Bangkok, Thailand'),
                        _InfoChip(icon: Icons.work, label: '3+ Years'),
                        _InfoChip(icon: Icons.code, label: 'Full-Stack'),
                        _InfoChip(icon: Icons.auto_awesome, label: 'AI'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Featured Skills
          SliverToBoxAdapter(
            child: _AnimatedSection(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Tech Stack'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        SkillChip(label: 'Flutter'),
                        SkillChip(label: 'Dart'),
                        SkillChip(label: 'Next.js'),
                        SkillChip(label: 'React'),
                        SkillChip(label: 'TypeScript'),
                        SkillChip(label: 'Python'),
                        SkillChip(label: 'FastAPI'),
                        SkillChip(label: 'PostgreSQL'),
                        SkillChip(label: 'Docker'),
                        SkillChip(label: 'AWS'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Featured Projects (top 3)
          SliverToBoxAdapter(
            child: _AnimatedSection(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionHeader(title: 'Featured Projects'),
                        TextButton(
                          onPressed: () {
                            // Navigate to projects tab handled by parent
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._featuredProjects.map((p) => ProjectCard(
                          name: p['name'] as String,
                          description: p['description'] as String,
                          tags: (p['tags'] as List).cast<String>(),
                          url: p['url'] as String,
                        )),
                  ],
                ),
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  static const _featuredProjects = [
    {
      'name': 'Portfolio Web',
      'description': '100+ micro-frontends deployed on Vercel',
      'tags': ['Next.js', 'TypeScript'],
      'url': 'https://bookchaowalit.com',
    },
    {
      'name': 'Base64 Encoder',
      'description': 'Encode and decode Base64 strings in real time',
      'tags': ['Next.js'],
      'url': 'https://base64.bookchaowalit.com',
    },
    {
      'name': 'Regex Tester',
      'description': 'Real-time regex testing with visual feedback',
      'tags': ['Next.js', 'React'],
      'url': 'https://regex.bookchaowalit.com',
    },
  ];
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
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
          CircleAvatar(
            radius: 48,
            backgroundColor: colorScheme.primary,
            child: Text(
              'C',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chaowalit Greepoke',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tech Generalist & Solopreneur',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Building full-stack products, integrating AI systems, and growing digital presence — from idea to deployment.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _launchUrl('mailto:bookchaowalit@gmail.com'),
                icon: const Icon(Icons.email, size: 18),
                label: const Text('Hire Me'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _launchUrl('https://bookchaowalit.com'),
                icon: const Icon(Icons.language, size: 18),
                label: const Text('Website'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

/// Fade + slide in animation for sections
class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

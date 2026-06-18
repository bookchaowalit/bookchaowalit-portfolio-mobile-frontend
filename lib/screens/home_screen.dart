import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section_header.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: _HeroSection(colorScheme: colorScheme),
          ),

          // About Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'About Me'),
                  const SizedBox(height: 16),
                  Text(
                    'Tech Generalist & Solopreneur who enjoys solving problems and building things end-to-end. Creating practical and scalable solutions from Bangkok, Thailand.',
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
                      _InfoChip(icon: Icons.work, label: '3+ Years Experience'),
                      _InfoChip(icon: Icons.code, label: 'Full-Stack Dev'),
                      _InfoChip(icon: Icons.auto_awesome, label: 'AI Integration'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Skills Section
          SliverToBoxAdapter(
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
                    children: [
                      const SkillChip(label: 'Flutter'),
                      const SkillChip(label: 'Dart'),
                      const SkillChip(label: 'Next.js'),
                      const SkillChip(label: 'React'),
                      const SkillChip(label: 'TypeScript'),
                      const SkillChip(label: 'Python'),
                      const SkillChip(label: 'FastAPI'),
                      const SkillChip(label: 'PostgreSQL'),
                      const SkillChip(label: 'Docker'),
                      const SkillChip(label: 'AWS'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Projects Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Featured Projects'),
                  const SizedBox(height: 16),
                  ..._buildProjectCards(context),
                ],
              ),
            ),
          ),

          // Contact Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Get In Touch'),
                  const SizedBox(height: 16),
                  _ContactCard(
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProjectCards(BuildContext context) {
    final projects = [
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

    return projects.map((p) {
      final tags = (p['tags']! as List).cast<String>();
      return ProjectCard(
        name: p['name']! as String,
        description: p['description']! as String,
        tags: tags,
        url: p['url']! as String,
      );
    }).toList();
  }
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
              'B',
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
        ],
      ),
    );
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.colorScheme});
  final ColorScheme colorScheme;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s work together!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Available for freelance projects and full-time opportunities.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => _launchUrl('mailto:bookchaowalit@gmail.com'),
                icon: const Icon(Icons.email, size: 18),
                label: const Text('Email'),
              ),
              OutlinedButton.icon(
                onPressed: () => _launchUrl('https://bookchaowalit.com'),
                icon: const Icon(Icons.language, size: 18),
                label: const Text('Portfolio'),
              ),
              OutlinedButton.icon(
                onPressed: () => _launchUrl('https://github.com/bookchaowalit'),
                icon: const Icon(Icons.code, size: 18),
                label: const Text('GitHub'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

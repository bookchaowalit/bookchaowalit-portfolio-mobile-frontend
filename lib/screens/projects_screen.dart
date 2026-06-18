import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

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
              children: _allProjects.map((p) {
                return _AnimatedProjectCard(
                  name: p['name'] as String,
                  description: p['description'] as String,
                  tags: (p['tags'] as List).cast<String>(),
                  url: p['url'] as String,
                );
              }).toList(),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  static const _allProjects = [
    {
      'name': 'Portfolio Web Platform',
      'description': '100+ micro-frontends with i18n, dynamic routing, and dark mode deployed on Vercel.',
      'tags': ['Next.js', 'TypeScript', 'Vercel'],
      'url': 'https://bookchaowalit.com',
    },
    {
      'name': 'Portfolio Mobile App',
      'description': 'Cross-platform mobile app built with Flutter for iOS and Android.',
      'tags': ['Flutter', 'Dart', 'Mobile'],
      'url': 'https://github.com/bookchaowalit',
    },
    {
      'name': 'Base64 Encoder',
      'description': 'Encode and decode Base64 strings in real time with file support.',
      'tags': ['Next.js', 'React'],
      'url': 'https://base64.bookchaowalit.com',
    },
    {
      'name': 'Regex Tester',
      'description': 'Real-time regex testing with visual feedback and pattern library.',
      'tags': ['Next.js', 'React'],
      'url': 'https://regex.bookchaowalit.com',
    },
    {
      'name': 'Automation Platform',
      'description': 'Cloudflare Workers-based automation system with scheduled tasks and API integrations.',
      'tags': ['Python', 'Cloudflare', 'Workers'],
      'url': 'https://github.com/bookchaowalit',
    },
    {
      'name': 'Scraper Dashboard',
      'description': 'Multi-source web scraping pipeline with deduplication and CSV export.',
      'tags': ['Python', 'FastAPI', 'SQLite'],
      'url': 'https://github.com/bookchaowalit',
    },
    {
      'name': 'JSON Formatter',
      'description': 'Format, validate, and minify JSON with syntax highlighting.',
      'tags': ['Next.js', 'TypeScript'],
      'url': 'https://json.bookchaowalit.com',
    },
    {
      'name': 'Color Converter',
      'description': 'Convert between HEX, RGB, HSL, and HSV color formats.',
      'tags': ['Next.js', 'React'],
      'url': 'https://color.bookchaowalit.com',
    },
  ];
}

class _AnimatedProjectCard extends StatelessWidget {
  final String name;
  final String description;
  final List<String> tags;
  final String url;

  const _AnimatedProjectCard({
    required this.name,
    required this.description,
    required this.tags,
    required this.url,
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
      child: ProjectCard(name: name, description: description, tags: tags, url: url),
    );
  }
}

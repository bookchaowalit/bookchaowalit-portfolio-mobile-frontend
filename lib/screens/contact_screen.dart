import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section_header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _formSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _sharePortfolio(BuildContext context) {
    final url = 'https://bookchaowalit.com';
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Portfolio link copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitContactForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final subject = _subjectController.text.trim();
      final message = _messageController.text.trim();

      // Build mailto URL with pre-filled content
      final mailtoUrl = Uri(
        scheme: 'mailto',
        path: 'bookchaowalit@gmail.com',
        queryParameters: {
          'subject': '$subject (from $name via Portfolio App)',
          'body': message,
        },
      );

      _launchUrl(mailtoUrl.toString());
      setState(() => _formSubmitted = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Opening your email app to send the message...'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _saveVCard(BuildContext context) {
    // Generate vCard 3.0 format
    final vcard = '''BEGIN:VCARD
VERSION:3.0
N:Greepoke;Chaowalit;;;
FN:Chaowalit Greepoke
ORG:Chaowalit Greepoke Portfolio
TITLE:Tech Generalist & Solopreneur
TEL;TYPE=CELL:
EMAIL:bookchaowalit@gmail.com
URL:https://bookchaowalit.com
ADR;TYPE=WORK:;;;;Bangkok;;Thailand
NOTE:Full-Stack Developer | Flutter | Next.js | Python | AI Systems
END:VCARD''';

    Clipboard.setData(ClipboardData(text: vcard));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contact card copied! Paste into Contacts app to save.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Open Contacts',
          onPressed: () {
            // Try to open contacts app on iOS
            _launchUrl('content://com.android.contacts');
          },
        ),
      ),
    );
  }

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
                const SectionHeader(title: 'Get In Touch'),
                const SizedBox(height: 8),
                Text(
                  'Available for freelance projects and full-time opportunities.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Contact Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                _ContactItem(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'bookchaowalit@gmail.com',
                  onTap: () => _launchUrl('mailto:bookchaowalit@gmail.com'),
                ),
                const SizedBox(height: 12),
                _ContactItem(
                  icon: Icons.language,
                  title: 'Website',
                  subtitle: 'bookchaowalit.com',
                  onTap: () => _launchUrl('https://bookchaowalit.com'),
                ),
                const SizedBox(height: 12),
                _ContactItem(
                  icon: Icons.code,
                  title: 'GitHub',
                  subtitle: 'github.com/bookchaowalit',
                  onTap: () => _launchUrl('https://github.com/bookchaowalit'),
                ),
                const SizedBox(height: 12),
                _ContactItem(
                  icon: Icons.share,
                  title: 'Share Portfolio',
                  subtitle: 'Copy link to clipboard',
                  onTap: () => _sharePortfolio(context),
                ),
                const SizedBox(height: 12),
                _ContactItem(
                  icon: Icons.contact_page,
                  title: 'Save Contact Card',
                  subtitle: 'Copy vCard to your clipboard',
                  onTap: () => _saveVCard(context),
                ),
              ],
            ),
          ),
        ),

        // Contact Form Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Send a Message'),
                const SizedBox(height: 8),
                Text(
                  'Fill out the form below. It will open your email app with the message pre-filled.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                _ContactForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  subjectController: _subjectController,
                  messageController: _messageController,
                  formSubmitted: _formSubmitted,
                  onSubmit: _submitContactForm,
                  onReset: () {
                    _nameController.clear();
                    _subjectController.clear();
                    _messageController.clear();
                    setState(() => _formSubmitted = false);
                  },
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),

        // CTA Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Let's work together!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'I\'m always open to discussing new projects, creative ideas, or opportunities.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => _launchUrl('mailto:bookchaowalit@gmail.com'),
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('Send Email'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final bool formSubmitted;
  final VoidCallback onSubmit;
  final VoidCallback onReset;
  final ColorScheme colorScheme;

  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.subjectController,
    required this.messageController,
    required this.formSubmitted,
    required this.onSubmit,
    required this.onReset,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Subject field
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'What is this about?',
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message field
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Tell me about your project or idea...',
                prefixIcon: const Icon(Icons.message_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Submit / Reset buttons
            if (!formSubmitted)
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Compose & Send'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReset,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Write Another'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text('Resend'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

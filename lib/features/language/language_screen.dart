import 'package:flutter/material.dart';
import '../../core/services/locale_provider.dart';
import 'package:career_guidance_app/app/router.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  Future<void> _changeLanguage(BuildContext context, String code) async {
    await LocaleProvider.instance.changeLocale(Locale(code));

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.main,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFFEDEBFF),
                child: Icon(
                  Icons.language_rounded,
                  size: 46,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the language you want to use',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 42),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LanguageItem(
                    flag: '🇰🇿',
                    title: 'Қазақша',
                    onTap: () => _changeLanguage(context, 'kk'),
                  ),
                  const SizedBox(width: 18),
                  _LanguageItem(
                    flag: '🇷🇺',
                    title: 'Русский',
                    onTap: () => _changeLanguage(context, 'ru'),
                  ),
                  const SizedBox(width: 18),
                  _LanguageItem(
                    flag: '🇺🇸',
                    title: 'English',
                    onTap: () => _changeLanguage(context, 'en'),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String flag;
  final String title;
  final VoidCallback onTap;

  const _LanguageItem({
    required this.flag,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 42),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'Career Guidance App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          ListTile(
            title: const Text('Авторизация'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRouter.auth),
          ),
          ListTile(
            title: const Text('Тестирование'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRouter.testing),
          ),
          ListTile(
            title: const Text('Рекомендации'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRouter.recommendations),
          ),
          ListTile(
            title: const Text('AI Помощник'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRouter.ai),
          ),
          ListTile(
            title: const Text('Профиль'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRouter.profile),
          ),
        ],
      ),
    );
  }
}
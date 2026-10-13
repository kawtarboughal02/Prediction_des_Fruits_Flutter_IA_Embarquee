import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'voice_translation_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? 'Boughal Kawtar';
    String userEmail = user?.email ?? 'boughalkawtar5@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Accueil', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/girl.jpg'),
                  ),
                  SizedBox(height: 8),
                  Text('Kawtar Boughal', style: TextStyle(color: Colors.white)),
                  Text('boughalkawtar5@gmail.com',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blueAccent),
              title: const Text('Page Accueil',
                  style: TextStyle(color: Colors.blueAccent)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.food_bank, color: Colors.blueAccent),
              title: const Text('Prédiction des fruits',
                  style: TextStyle(color: Colors.blueAccent)),
              onTap: () => Navigator.pushNamed(context, '/fruit_prediction'),
            ),
            ListTile(
              leading: const Icon(Icons.mic, color: Colors.blueAccent),
              title: const Text('Traduction vocale',
                  style: TextStyle(color: Colors.blueAccent)),
              onTap: () => Navigator.pushNamed(context, '/voice_translation'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Déconnexion',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue dans l\'application de classification des fruits!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cette application vous permet de classer des fruits en utilisant l\'IA. Vous pouvez aussi utiliser la fonction de traduction vocale pour faciliter la communication dans différentes langues.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              const SizedBox(height: 30),
              const Text(
                'Que pouvez-vous faire avec cette application ?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Classifier des fruits avec des modèles d\'intelligence artificielle.\n'
                '• Utiliser la traduction vocale pour traduire vos paroles dans une autre langue.\n'
                '• Recevoir des notifications pour des mises à jour importantes.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureCard(
                    icon: Icons.food_bank,
                    title: 'Prédiction des Fruits',
                    description: 'Classifiez les fruits avec précision.',
                    onTap: () =>
                        Navigator.pushNamed(context, '/fruit_prediction'),
                  ),
                  _buildFeatureCard(
                    icon: Icons.mic,
                    title: 'Traduction Vocale',
                    description: 'Traduisez vos paroles en temps réel.',
                    onTap: () =>
                        Navigator.pushNamed(context, '/voice_translation'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Fonctionnalités supplémentaires:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Prédiction de type de fruit basé sur l\'image.\n'
                '• Accès facile à l\'historique des fruits classifiés.\n'
                '• Interface utilisateur moderne et facile à utiliser.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

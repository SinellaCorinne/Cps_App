import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/screens/survey_screen.dart';
import 'package:app_cps/utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryGreen,
              AppTheme.secondaryBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo et En-tête
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.diversity_3,
                        size: 50,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'RÉPUBLIQUE DU BÉNIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Social-Link Bénin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Centres de Promotion Sociale',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Carte principale
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Digitalisation des Enquêtes Sociales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Outil terrain pour les agents sociaux',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.lightText,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Bouton Nouvelle Enquête
                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<SurveyProvider>(context, listen: false).resetSurvey();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 28),
                      label: const Text('Nouvelle Enquête'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bouton Demo avec données de test
                    OutlinedButton.icon(
                      onPressed: () {
                        Provider.of<SurveyProvider>(context, listen: false).loadSampleData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.science, size: 24),
                      label: const Text('Démo (Données de test)'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Statistiques rapides
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatCard(
                          icon: Icons.folder_open,
                          label: 'Enquêtes',
                          value: '12',
                          color: AppTheme.secondaryBlue,
                        ),
                        _StatCard(
                          icon: Icons.cloud_off,
                          label: 'Non sync.',
                          value: '3',
                          color: AppTheme.warningYellow,
                        ),
                        _StatCard(
                          icon: Icons.check_circle,
                          label: 'Validées',
                          value: '9',
                          color: AppTheme.successGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'v1.0.0 - MVP • Mode Offline-First',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.lightText,
          ),
        ),
      ],
    );
  }
}

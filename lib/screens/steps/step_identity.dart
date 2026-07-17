import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/utils/app_theme.dart';

class StepIdentity extends StatefulWidget {
  const StepIdentity({super.key});

  @override
  State<StepIdentity> createState() => _StepIdentityState();
}

class _StepIdentityState extends State<StepIdentity> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _ageController;
  late TextEditingController _telephoneController;
  late TextEditingController _communeController;
  late TextEditingController _arrondissementController;
  
  String _selectedGenre = 'Féminin';
  
  @override
  void initState() {
    super.initState();
    final survey = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _nomController = TextEditingController(text: survey.nom);
    _prenomController = TextEditingController(text: survey.prenom);
    _ageController = TextEditingController(text: survey.age?.toString() ?? '');
    _telephoneController = TextEditingController(text: survey.telephone ?? '');
    _communeController = TextEditingController(text: survey.commune ?? '');
    _arrondissementController = TextEditingController(text: survey.arrondissement ?? '');
    _selectedGenre = survey.genre;
  }
  
  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _ageController.dispose();
    _telephoneController.dispose();
    _communeController.dispose();
    _arrondissementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // En-tête de section
          const _SectionHeader(
            icon: Icons.person,
            title: 'Identité & Situation de l\'Usager',
            subtitle: 'Informations personnelles et localisation',
          ),
          
          const SizedBox(height: 24),
          
          // Photo de profil
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGreen,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('📸 Fonctionnalité caméra disponible en production'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Nom
          TextFormField(
            controller: _nomController,
            decoration: const InputDecoration(
              labelText: 'Nom *',
              prefixIcon: Icon(Icons.badge),
            ),
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le nom est obligatoire';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Prénom
          TextFormField(
            controller: _prenomController,
            decoration: const InputDecoration(
              labelText: 'Prénom *',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le prénom est obligatoire';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Genre
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.wc, color: AppTheme.primaryGreen),
                    SizedBox(width: 12),
                    Text(
                      'Genre *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _GenderOption(
                        label: 'Féminin',
                        icon: Icons.woman,
                        isSelected: _selectedGenre == 'Féminin',
                        onTap: () {
                          setState(() {
                            _selectedGenre = 'Féminin';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GenderOption(
                        label: 'Masculin',
                        icon: Icons.man,
                        isSelected: _selectedGenre == 'Masculin',
                        onTap: () {
                          setState(() {
                            _selectedGenre = 'Masculin';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Âge
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Âge',
              prefixIcon: Icon(Icons.cake),
              suffixText: 'ans',
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),
          
          // Téléphone
          TextFormField(
            controller: _telephoneController,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: Icon(Icons.phone),
              hintText: '+229 XX XX XX XX',
            ),
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 24),
          
          // Sous-section Localisation
          const Divider(height: 32),
          const Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.secondaryBlue),
              SizedBox(width: 8),
              Text(
                'Localisation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Commune
          TextFormField(
            controller: _communeController,
            decoration: const InputDecoration(
              labelText: 'Commune',
              prefixIcon: Icon(Icons.location_city),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Arrondissement
          TextFormField(
            controller: _arrondissementController,
            decoration: const InputDecoration(
              labelText: 'Arrondissement / Quartier',
              prefixIcon: Icon(Icons.place),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bouton GPS
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📍 Coordonnées GPS enregistrées'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Capturer Position GPS'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Boutons de navigation
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Sauvegarder les données
                      Provider.of<SurveyProvider>(context, listen: false).updateIdentity(
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        genre: _selectedGenre,
                        age: int.tryParse(_ageController.text),
                        telephone: _telephoneController.text,
                        commune: _communeController.text,
                        arrondissement: _arrondissementController.text,
                      );
                      
                      // Passer à l'étape suivante
                      Provider.of<SurveyProvider>(context, listen: false).nextStep();
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.1),
            AppTheme.secondaryBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryGreen.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppTheme.primaryGreen : AppTheme.lightText,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryGreen : AppTheme.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

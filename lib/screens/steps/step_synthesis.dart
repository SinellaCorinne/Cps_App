import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/utils/app_theme.dart';
import 'package:app_cps/utils/pdf_generator.dart';

class StepSynthesis extends StatefulWidget {
  const StepSynthesis({super.key});

  @override
  State<StepSynthesis> createState() => _StepSynthesisState();
}

class _StepSynthesisState extends State<StepSynthesis> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _observationsController;
  late TextEditingController _recommandationsController;
  late TextEditingController _typeAideController;
  
  bool _isGeneratingPDF = false;
  
  @override
  void initState() {
    super.initState();
    final survey = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _observationsController = TextEditingController(text: survey.observationsGenerales ?? '');
    _recommandationsController = TextEditingController(text: survey.recommandations ?? '');
    _typeAideController = TextEditingController(text: survey.typeAide ?? '');
  }
  
  @override
  void dispose() {
    _observationsController.dispose();
    _recommandationsController.dispose();
    _typeAideController.dispose();
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
          _SectionHeader(
            icon: Icons.summarize,
            title: 'Synthèse & Recommandations',
            subtitle: 'Observations et préconisations d\'accompagnement',
          ),
          
          const SizedBox(height: 24),
          
          // Observations générales avec dictée vocale
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.description, color: AppTheme.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Observations Générales *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _observationsController,
                decoration: const InputDecoration(
                  hintText: 'Décrivez la situation générale de l\'usager, ses conditions de vie, son contexte familial...',
                  contentPadding: EdgeInsets.all(20),
                ),
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Les observations sont obligatoires';
                  }
                  return null;
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recommandations
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppTheme.secondaryBlue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Recommandations & Plan d\'Action *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _recommandationsController,
                decoration: const InputDecoration(
                  hintText: 'Actions préconisées, orientations vers des services, suivi à mettre en place...',
                  contentPadding: EdgeInsets.all(20),
                ),
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Les recommandations sont obligatoires';
                  }
                  return null;
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Type d'aide
          TextFormField(
            controller: _typeAideController,
            decoration: const InputDecoration(
              labelText: 'Type d\'Aide Préconisée',
              prefixIcon: Icon(Icons.volunteer_activism),
              hintText: 'Ex: Aide alimentaire, AGR, Parrainage scolaire...',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          
          const SizedBox(height: 32),
          
          // Carte récapitulative
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successGreen.withOpacity(0.1),
                  AppTheme.primaryGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.successGreen.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Consumer<SurveyProvider>(
              builder: (context, provider, child) {
                final survey = provider.currentSurvey;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.successGreen, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Récapitulatif de l\'Enquête',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _RecapRow(
                      icon: Icons.person,
                      label: 'Usager',
                      value: '${survey.nom} ${survey.prenom}',
                    ),
                    _RecapRow(
                      icon: Icons.location_on,
                      label: 'Localisation',
                      value: '${survey.commune ?? 'Non renseigné'} - ${survey.arrondissement ?? ''}',
                    ),
                    _RecapRow(
                      icon: Icons.family_restroom,
                      label: 'Personnes au foyer',
                      value: '${survey.nombrePersonnesFoyer ?? 'Non renseigné'}',
                    ),
                    _RecapRow(
                      icon: Icons.warning_amber,
                      label: 'Vulnérabilités',
                      value: survey.vulnerabilites.isEmpty 
                          ? 'Aucune' 
                          : '${survey.vulnerabilites.length} identifiée(s)',
                    ),
                  ],
                );
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Bouton principal : Générer le PDF
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentOrange,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  size: 48,
                  color: AppTheme.accentOrange,
                ),
                const SizedBox(height: 12),
                const Text(
                  '📄 LE WAOO EFFECT !',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Générez instantanément le rapport officiel au format PDF prêt à être imprimé et transmis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isGeneratingPDF ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isGeneratingPDF = true;
                      });
                      
                      // Sauvegarder les données
                      final provider = Provider.of<SurveyProvider>(context, listen: false);
                      provider.updateSynthesis(
                        observationsGenerales: _observationsController.text,
                        recommandations: _recommandationsController.text,
                        typeAide: _typeAideController.text,
                      );
                      
                      // Générer le PDF
                      await Future.delayed(const Duration(milliseconds: 500));
                      
                      try {
                        await PDFGenerator.generateAndPreview(
                          context,
                          provider.currentSurvey,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erreur: $e'),
                            backgroundColor: AppTheme.dangerRed,
                          ),
                        );
                      }
                      
                      setState(() {
                        _isGeneratingPDF = false;
                      });
                    }
                  },
                  icon: _isGeneratingPDF
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf, size: 28),
                  label: Text(
                    _isGeneratingPDF 
                        ? 'Génération en cours...' 
                        : 'Générer le Rapport PDF Officiel',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Boutons de navigation
          OutlinedButton.icon(
            onPressed: () {
              Provider.of<SurveyProvider>(context, listen: false).previousStep();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
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

class _RecapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RecapRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.lightText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

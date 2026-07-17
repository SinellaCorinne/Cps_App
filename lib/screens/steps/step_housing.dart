import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/utils/app_theme.dart';

class StepHousing extends StatefulWidget {
  const StepHousing({super.key});

  @override
  State<StepHousing> createState() => _StepHousingState();
}

class _StepHousingState extends State<StepHousing> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _typeLogementController;
  late TextEditingController _nombrePersonnesController;
  late TextEditingController _revenuController;
  late TextEditingController _situationEmploiController;
  
  int _etatLogement = 3;
  int _acceauEau = 3;
  int _acceauElectricite = 3;
  bool _possedeTelev = false;
  bool _possedeFrigo = false;
  bool _possedeVehicule = false;
  
  final List<String> _vulnerabilitesDisponibles = [
    'Famille nombreuse',
    'Logement précaire',
    'Revenus faibles et irréguliers',
    'Enfants non scolarisés',
    'Problèmes de santé',
    'Personnes âgées à charge',
    'Personnes handicapées',
    'Femme seule avec enfants',
    'Orphelin(s)',
    'Violence domestique',
    'Insécurité alimentaire',
    'Accès limité aux soins',
  ];
  
  Set<String> _vulnerabilitesSelectionnees = {};
  
  @override
  void initState() {
    super.initState();
    final survey = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _typeLogementController = TextEditingController(text: survey.typeLogement ?? '');
    _nombrePersonnesController = TextEditingController(text: survey.nombrePersonnesFoyer?.toString() ?? '');
    _revenuController = TextEditingController(text: survey.revenuEstime?.toString() ?? '');
    _situationEmploiController = TextEditingController(text: survey.situationEmploi ?? '');
    
    _etatLogement = survey.etatLogement ?? 3;
    _acceauEau = survey.acceauEau ?? 3;
    _acceauElectricite = survey.acceauElectricite ?? 3;
    _possedeTelev = survey.possedeTelev ?? false;
    _possedeFrigo = survey.possedeFrigo ?? false;
    _possedeVehicule = survey.possedeVehicule ?? false;
    _vulnerabilitesSelectionnees = Set.from(survey.vulnerabilites);
  }
  
  @override
  void dispose() {
    _typeLogementController.dispose();
    _nombrePersonnesController.dispose();
    _revenuController.dispose();
    _situationEmploiController.dispose();
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
            icon: Icons.home,
            title: 'Évaluation Logement & Vulnérabilité',
            subtitle: 'Conditions de vie et facteurs de risque',
          ),
          
          const SizedBox(height: 24),
          
          // Type de logement
          TextFormField(
            controller: _typeLogementController,
            decoration: const InputDecoration(
              labelText: 'Type de Logement',
              prefixIcon: Icon(Icons.house),
              hintText: 'Ex: Maison en terre battue, villa, location...',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          
          const SizedBox(height: 24),
          
          // État du logement (échelle 1-5)
          _RatingScale(
            label: 'État du Logement',
            icon: Icons.home_repair_service,
            value: _etatLogement,
            minLabel: 'Très mauvais',
            maxLabel: 'Excellent',
            onChanged: (value) {
              setState(() {
                _etatLogement = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Accès à l'eau
          _RatingScale(
            label: 'Accès à l\'Eau Potable',
            icon: Icons.water_drop,
            value: _acceauEau,
            minLabel: 'Aucun',
            maxLabel: 'Excellent',
            onChanged: (value) {
              setState(() {
                _acceauEau = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Accès à l'électricité
          _RatingScale(
            label: 'Accès à l\'Électricité',
            icon: Icons.electric_bolt,
            value: _acceauElectricite,
            minLabel: 'Aucun',
            maxLabel: 'Excellent',
            onChanged: (value) {
              setState(() {
                _acceauElectricite = value;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Biens possédés
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
                    Icon(Icons.inventory_2, color: AppTheme.primaryGreen),
                    SizedBox(width: 12),
                    Text(
                      'Biens Possédés',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Télévision'),
                  value: _possedeTelev,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: (value) {
                    setState(() {
                      _possedeTelev = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Réfrigérateur'),
                  value: _possedeFrigo,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: (value) {
                    setState(() {
                      _possedeFrigo = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Véhicule (moto, voiture)'),
                  value: _possedeVehicule,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: (value) {
                    setState(() {
                      _possedeVehicule = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Nombre de personnes au foyer
          TextFormField(
            controller: _nombrePersonnesController,
            decoration: const InputDecoration(
              labelText: 'Nombre de Personnes au Foyer',
              prefixIcon: Icon(Icons.family_restroom),
              suffixText: 'personnes',
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),
          
          // Situation d'emploi
          TextFormField(
            controller: _situationEmploiController,
            decoration: const InputDecoration(
              labelText: 'Situation d\'Emploi',
              prefixIcon: Icon(Icons.work),
              hintText: 'Ex: Commerçante, Maçon, Sans emploi...',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          
          const SizedBox(height: 16),
          
          // Revenu estimé
          TextFormField(
            controller: _revenuController,
            decoration: const InputDecoration(
              labelText: 'Revenu Mensuel Estimé',
              prefixIcon: Icon(Icons.attach_money),
              suffixText: 'FCFA',
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 24),
          
          // Vulnérabilités
          const Divider(height: 32),
          const Row(
            children: [
              Icon(Icons.warning_amber, color: AppTheme.warningYellow),
              SizedBox(width: 8),
              Text(
                'Facteurs de Vulnérabilité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Cochez tous les facteurs qui s\'appliquent',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.lightText,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _vulnerabilitesDisponibles.map((vuln) {
              final isSelected = _vulnerabilitesSelectionnees.contains(vuln);
              return FilterChip(
                label: Text(vuln),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _vulnerabilitesSelectionnees.add(vuln);
                    } else {
                      _vulnerabilitesSelectionnees.remove(vuln);
                    }
                  });
                },
                selectedColor: AppTheme.warningYellow.withOpacity(0.3),
                checkmarkColor: AppTheme.darkText,
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.darkText : AppTheme.lightText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.warningYellow : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Boutons de navigation
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Provider.of<SurveyProvider>(context, listen: false).previousStep();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Retour'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Sauvegarder les données
                    final provider = Provider.of<SurveyProvider>(context, listen: false);
                    
                    provider.updateHousing(
                      typeLogement: _typeLogementController.text,
                      etatLogement: _etatLogement,
                      acceauEau: _acceauEau,
                      acceauElectricite: _acceauElectricite,
                      possedeTelev: _possedeTelev,
                      possedeFrigo: _possedeFrigo,
                      possedeVehicule: _possedeVehicule,
                      nombrePersonnesFoyer: int.tryParse(_nombrePersonnesController.text),
                      revenuEstime: double.tryParse(_revenuController.text),
                      situationEmploi: _situationEmploiController.text,
                    );
                    
                    // Mettre à jour les vulnérabilités
                    provider.currentSurvey.vulnerabilites = _vulnerabilitesSelectionnees.toList();
                    
                    // Passer à l'étape suivante
                    provider.nextStep();
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

class _RatingScale extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final String minLabel;
  final String maxLabel;
  final ValueChanged<int> onChanged;

  const _RatingScale({
    required this.label,
    required this.icon,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = rating == value;
              return InkWell(
                onTap: () => onChanged(rating),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryGreen 
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.primaryGreen 
                          : Colors.grey.shade300,
                      width: isSelected ? 2.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$rating',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppTheme.lightText,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightText,
                ),
              ),
              Text(
                maxLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

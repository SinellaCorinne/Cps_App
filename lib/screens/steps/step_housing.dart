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

  int _etatLogement       = 3;
  int _acceauEau          = 3;
  int _acceauElectricite  = 3;
  bool _possedeTelev      = false;
  bool _possedeFrigo      = false;
  bool _possedeVehicule   = false;
  Set<String> _vulnerabilitesSelectionnees = {};

  static const _vulnerabilitesDisponibles = [
    ('Famille nombreuse',             Icons.family_restroom_rounded,       AppTheme.secondaryBlue),
    ('Logement précaire',             Icons.home_work_rounded,             AppTheme.dangerRed),
    ('Revenus faibles et irréguliers',Icons.money_off_rounded,             AppTheme.warningYellow),
    ('Enfants non scolarisés',        Icons.school_rounded,                AppTheme.accentOrange),
    ('Problèmes de santé',            Icons.medical_services_rounded,      AppTheme.dangerRed),
    ('Personnes âgées à charge',      Icons.elderly_rounded,               AppTheme.primaryGreen),
    ('Personnes handicapées',         Icons.accessible_rounded,            AppTheme.infoBlue),
    ('Femme seule avec enfants',      Icons.woman_rounded,                 AppTheme.accentOrange),
    ('Orphelin(s)',                   Icons.child_care_rounded,            AppTheme.warningYellow),
    ('Violence domestique',           Icons.gpp_bad_rounded,               AppTheme.dangerRed),
    ('Insécurité alimentaire',        Icons.no_food_rounded,               AppTheme.dangerRed),
    ('Accès limité aux soins',        Icons.local_hospital_rounded,        AppTheme.accentOrange),
  ];

  @override
  void initState() {
    super.initState();
    final s = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _typeLogementController       = TextEditingController(text: s.typeLogement ?? '');
    _nombrePersonnesController    = TextEditingController(text: s.nombrePersonnesFoyer?.toString() ?? '');
    _revenuController             = TextEditingController(text: s.revenuEstime?.toString() ?? '');
    _situationEmploiController    = TextEditingController(text: s.situationEmploi ?? '');
    _etatLogement                 = s.etatLogement ?? 3;
    _acceauEau                    = s.acceauEau ?? 3;
    _acceauElectricite            = s.acceauElectricite ?? 3;
    _possedeTelev                 = s.possedeTelev ?? false;
    _possedeFrigo                 = s.possedeFrigo ?? false;
    _possedeVehicule              = s.possedeVehicule ?? false;
    _vulnerabilitesSelectionnees  = Set.from(s.vulnerabilites);
  }

  @override
  void dispose() {
    _typeLogementController.dispose();
    _nombrePersonnesController.dispose();
    _revenuController.dispose();
    _situationEmploiController.dispose();
    super.dispose();
  }

  // Score global de vulnérabilité (0-100)
  int get _vulnerabilityScore {
    int score = 0;
    // Échelles inversées (1=mauvais → contribue)
    score += (5 - _etatLogement) * 6;       // max 24
    score += (5 - _acceauEau) * 5;          // max 20
    score += (5 - _acceauElectricite) * 4;  // max 16
    score += _vulnerabilitesSelectionnees.length * 3; // max 36
    return score.clamp(0, 100);
  }

  Color get _scoreColor {
    final s = _vulnerabilityScore;
    if (s < 25) return AppTheme.successGreen;
    if (s < 50) return AppTheme.warningYellow;
    if (s < 75) return AppTheme.accentOrange;
    return AppTheme.dangerRed;
  }

  String get _scoreLabel {
    final s = _vulnerabilityScore;
    if (s < 25) return 'Faible';
    if (s < 50) return 'Modéré';
    if (s < 75) return 'Élevé';
    return 'Critique';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── Score de vulnérabilité (live) ───────────────────────────
          _VulnerabilityScoreCard(
            score: _vulnerabilityScore,
            scoreColor: _scoreColor,
            scoreLabel: _scoreLabel,
            vulnerCount: _vulnerabilitesSelectionnees.length,
          ),

          const SizedBox(height: 16),

          // ── Logement ─────────────────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.primaryGreen,
            headerIcon: Icons.home_rounded,
            headerTitle: 'Type de Logement',
            children: [
              TextFormField(
                controller: _typeLogementController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description du logement',
                  prefixIcon: Icon(Icons.house_rounded, size: 20),
                  hintText: 'Ex: Maison en terre battue, appartement...',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Échelles d'évaluation ────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.secondaryBlue,
            headerIcon: Icons.assessment_rounded,
            headerTitle: 'Évaluation des Conditions de Vie',
            children: [
              _RatingScale(
                label: 'État général du logement',
                icon: Icons.home_repair_service_rounded,
                value: _etatLogement,
                onChanged: (v) => setState(() => _etatLogement = v),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEAEEF2)),
              const SizedBox(height: 16),
              _RatingScale(
                label: 'Accès à l\'eau potable',
                icon: Icons.water_drop_rounded,
                value: _acceauEau,
                onChanged: (v) => setState(() => _acceauEau = v),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEAEEF2)),
              const SizedBox(height: 16),
              _RatingScale(
                label: 'Accès à l\'électricité',
                icon: Icons.electric_bolt_rounded,
                value: _acceauElectricite,
                onChanged: (v) => setState(() => _acceauElectricite = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Biens possédés ───────────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.accentGold,
            headerIcon: Icons.inventory_2_rounded,
            headerTitle: 'Biens du Foyer',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AssetToggle(
                      label: 'Télévision',
                      icon: Icons.tv_rounded,
                      value: _possedeTelev,
                      onChanged: (v) => setState(() => _possedeTelev = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AssetToggle(
                      label: 'Réfrigérateur',
                      icon: Icons.kitchen_rounded,
                      value: _possedeFrigo,
                      onChanged: (v) => setState(() => _possedeFrigo = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AssetToggle(
                      label: 'Véhicule',
                      icon: Icons.two_wheeler_rounded,
                      value: _possedeVehicule,
                      onChanged: (v) => setState(() => _possedeVehicule = v),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Situation économique ──────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.accentOrange,
            headerIcon: Icons.work_rounded,
            headerTitle: 'Situation Économique',
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nombrePersonnesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Personnes au foyer',
                        prefixIcon: Icon(Icons.family_restroom_rounded, size: 20),
                        suffixText: 'pers.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _revenuController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Revenu mensuel',
                        prefixIcon: Icon(Icons.attach_money_rounded, size: 20),
                        suffixText: 'FCFA',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _situationEmploiController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Situation d\'emploi',
                  prefixIcon: Icon(Icons.business_center_rounded, size: 20),
                  hintText: 'Ex: Commerçante informelle, Sans emploi...',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Facteurs de vulnérabilité ─────────────────────────────────
          _FormCard(
            headerColor: AppTheme.dangerRed,
            headerIcon: Icons.warning_amber_rounded,
            headerTitle: 'Facteurs de Vulnérabilité',
            children: [
              Text(
                'Sélectionnez tous les facteurs applicables',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _vulnerabilitesDisponibles.map((entry) {
                  final (label, icon, color) = entry;
                  final isSelected = _vulnerabilitesSelectionnees.contains(label);
                  return _VulnerabilityChip(
                    label: label,
                    icon: icon,
                    color: color,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      isSelected
                          ? _vulnerabilitesSelectionnees.remove(label)
                          : _vulnerabilitesSelectionnees.add(label);
                    }),
                  );
                }).toList(),
              ),
              if (_vulnerabilitesSelectionnees.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.dangerRed.withValues(alpha: 0.20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: AppTheme.dangerRed),
                      const SizedBox(width: 8),
                      Text(
                        '${_vulnerabilitesSelectionnees.length} facteur(s) identifié(s)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.dangerRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 28),

          // ── Navigation ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Retour'),
                  onPressed: () =>
                      Provider.of<SurveyProvider>(context, listen: false)
                          .previousStep(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Suivant — Synthèse'),
                  onPressed: () {
                    final p = Provider.of<SurveyProvider>(
                        context, listen: false);
                    p.updateHousing(
                      typeLogement:       _typeLogementController.text,
                      etatLogement:       _etatLogement,
                      acceauEau:          _acceauEau,
                      acceauElectricite:  _acceauElectricite,
                      possedeTelev:       _possedeTelev,
                      possedeFrigo:       _possedeFrigo,
                      possedeVehicule:    _possedeVehicule,
                      nombrePersonnesFoyer:
                          int.tryParse(_nombrePersonnesController.text),
                      revenuEstime:
                          double.tryParse(_revenuController.text),
                      situationEmploi: _situationEmploiController.text,
                    );
                    p.currentSurvey.vulnerabilites =
                        _vulnerabilitesSelectionnees.toList();
                    p.nextStep();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Score de vulnérabilité ───────────────────────────────────────────────────
class _VulnerabilityScoreCard extends StatelessWidget {
  final int score;
  final Color scoreColor;
  final String scoreLabel;
  final int vulnerCount;

  const _VulnerabilityScoreCard({
    required this.score,
    required this.scoreColor,
    required this.scoreLabel,
    required this.vulnerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Gauge circulaire
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: const Color(0xFFEAEEF2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Score de vulnérabilité',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        scoreLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scoreColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFEAEEF2),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$vulnerCount facteur(s) de vulnérabilité sélectionné(s)',
                  style: const TextStyle(
                    fontSize: 11,
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

// ─── FormCard ─────────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final Color headerColor;
  final IconData headerIcon;
  final String headerTitle;
  final List<Widget> children;

  const _FormCard({
    required this.headerColor,
    required this.headerIcon,
    required this.headerTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFEAEEF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              border: Border(
                bottom: BorderSide(color: headerColor.withValues(alpha: 0.15)),
              ),
            ),
            child: Row(
              children: [
                Icon(headerIcon, color: headerColor, size: 17),
                const SizedBox(width: 8),
                Text(
                  headerTitle,
                  style: TextStyle(
                    color: headerColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Échelle de notation sémantique ──────────────────────────────────────────
class _RatingScale extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final ValueChanged<int> onChanged;

  const _RatingScale({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  // Couleur selon la note : 1 rouge → 5 vert
  static Color _colorFor(int rating) {
    switch (rating) {
      case 1: return AppTheme.dangerRed;
      case 2: return AppTheme.accentOrange;
      case 3: return AppTheme.warningYellow;
      case 4: return AppTheme.infoBlue;
      case 5: return AppTheme.successGreen;
      default: return AppTheme.lightText;
    }
  }

  static const _labels = ['Très\nmauvais', 'Mauvais', 'Moyen', 'Bon', 'Excellent'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 17, color: AppTheme.mediumText),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _colorFor(value).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labels[value - 1],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _colorFor(value),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (i) {
            final rating = i + 1;
            final isSelected = rating == value;
            final color = _colorFor(rating);
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(rating),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? color
                          : color.withValues(alpha: 0.25),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : color.withValues(alpha: 0.80),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── Toggle bien possédé ──────────────────────────────────────────────────────
class _AssetToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AssetToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: value
              ? AppTheme.primaryGreen
              : AppTheme.surfaceGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value
                ? AppTheme.primaryGreen
                : const Color(0xFFDDE2EA),
            width: value ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: value ? Colors.white : AppTheme.lightText,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: value ? FontWeight.w700 : FontWeight.w400,
                color: value ? Colors.white : AppTheme.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Chip de vulnérabilité ────────────────────────────────────────────────────
class _VulnerabilityChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _VulnerabilityChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : AppTheme.surfaceGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFDDE2EA),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : icon,
              size: 15,
              color: isSelected ? color : AppTheme.lightText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? color : AppTheme.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

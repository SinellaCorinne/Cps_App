import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/utils/app_theme.dart';
import 'package:app_cps/utils/pdf_generator.dart';
import 'package:app_cps/models/survey_model.dart';

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
    final s = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _observationsController    = TextEditingController(text: s.observationsGenerales ?? '');
    _recommandationsController = TextEditingController(text: s.recommandations ?? '');
    _typeAideController        = TextEditingController(text: s.typeAide ?? '');
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _recommandationsController.dispose();
    _typeAideController.dispose();
    super.dispose();
  }

  // Score calculé depuis les données de l'étape 2
  int _computeScore(SurveyModel s) {
    int score = 0;
    score += (5 - (s.etatLogement ?? 3)) * 6;
    score += (5 - (s.acceauEau ?? 3)) * 5;
    score += (5 - (s.acceauElectricite ?? 3)) * 4;
    score += s.vulnerabilites.length * 3;
    return score.clamp(0, 100);
  }

  Color _scoreColor(int score) {
    if (score < 25) return AppTheme.successGreen;
    if (score < 50) return AppTheme.warningYellow;
    if (score < 75) return AppTheme.accentOrange;
    return AppTheme.dangerRed;
  }

  String _scoreLabel(int score) {
    if (score < 25) return 'Faible';
    if (score < 50) return 'Modéré';
    if (score < 75) return 'Élevé';
    return 'Critique';
  }

  // Priorité d'aide recommandée automatiquement
  String _autoPriorite(int score) {
    if (score < 25) return 'Suivi social standard';
    if (score < 50) return 'Accompagnement social renforcé';
    if (score < 75) return 'Intervention urgente recommandée';
    return 'Prise en charge immédiate — Aide d\'urgence';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(
      builder: (context, provider, _) {
        final survey = provider.currentSurvey;
        final score  = _computeScore(survey);
        final color  = _scoreColor(score);
        final label  = _scoreLabel(score);

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [

              // ── Récapitulatif dossier ──────────────────────────────────
              _DossierSummaryCard(survey: survey, score: score, color: color, label: label),

              const SizedBox(height: 16),

              // ── Observations générales ─────────────────────────────────
              _FormCard(
                headerColor: AppTheme.primaryGreen,
                headerIcon: Icons.description_rounded,
                headerTitle: 'Observations Générales *',
                children: [
                  TextFormField(
                    controller: _observationsController,
                    maxLines: 7,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText:
                          'Décrivez la situation de l\'usager : conditions de vie, contexte familial, besoins prioritaires...',
                      contentPadding: EdgeInsets.all(14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Les observations sont obligatoires'
                            : null,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Recommandations ────────────────────────────────────────
              _FormCard(
                headerColor: AppTheme.secondaryBlue,
                headerIcon: Icons.lightbulb_rounded,
                headerTitle: 'Recommandations & Plan d\'Action *',
                children: [
                  // Suggestion automatique
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryBlue.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.secondaryBlue.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            size: 16, color: AppTheme.secondaryBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Suggestion : ${_autoPriorite(score)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _recommandationsController,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText:
                          'Actions préconisées, orientations vers des services, suivi à mettre en place...',
                      contentPadding: EdgeInsets.all(14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Les recommandations sont obligatoires'
                            : null,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Type d'aide ────────────────────────────────────────────
              _FormCard(
                headerColor: AppTheme.accentOrange,
                headerIcon: Icons.volunteer_activism_rounded,
                headerTitle: 'Type d\'Aide Préconisée',
                children: [
                  TextFormField(
                    controller: _typeAideController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nature de l\'aide',
                      prefixIcon: Icon(Icons.handshake_rounded, size: 20),
                      hintText: 'Ex: Aide alimentaire, AGR, Parrainage scolaire...',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Bloc génération PDF ────────────────────────────────────
              _PdfBlock(
                isGenerating: _isGeneratingPDF,
                onGenerate: () => _generatePdf(provider),
              ),

              const SizedBox(height: 28),

              // ── Navigation ─────────────────────────────────────────────
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Retour — Logement'),
                onPressed: () =>
                    provider.previousStep(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _generatePdf(SurveyProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGeneratingPDF = true);

    provider.updateSynthesis(
      observationsGenerales: _observationsController.text,
      recommandations:       _recommandationsController.text,
      typeAide:              _typeAideController.text,
    );

    final messenger = ScaffoldMessenger.of(context);
    final survey    = provider.currentSurvey;

    // Génère un ID si absent
    if (survey.id == null || survey.id!.isEmpty) {
      survey.id = 'ENQ-${DateTime.now().millisecondsSinceEpoch}';
    }

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      if (!mounted) return;
      await PDFGenerator.generateAndPreview(context, survey);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la génération : $e'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPDF = false);
    }
  }
}

// ─── Récapitulatif dossier ────────────────────────────────────────────────────
class _DossierSummaryCard extends StatelessWidget {
  final SurveyModel survey;
  final int score;
  final Color color;
  final String label;

  const _DossierSummaryCard({
    required this.survey,
    required this.score,
    required this.color,
    required this.label,
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
        children: [
          // En-tête dossier
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.folder_open_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${survey.prenom} ${survey.nom}'.trim().isEmpty
                            ? 'Usager non renseigné'
                            : '${survey.prenom} ${survey.nom}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE dd MMMM yyyy', 'fr_FR')
                            .format(survey.dateEnquete),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge score
                Column(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 5,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.25),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Text(
                              '$score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lignes de récap
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _RecapRow(
                  icon: Icons.location_on_rounded,
                  color: AppTheme.accentOrange,
                  label: 'Localisation',
                  value: [
                    survey.commune,
                    survey.arrondissement,
                  ].where((s) => s != null && s.isNotEmpty).join(' — '),
                  fallback: 'Non renseigné',
                ),
                const SizedBox(height: 8),
                _RecapRow(
                  icon: Icons.family_restroom_rounded,
                  color: AppTheme.secondaryBlue,
                  label: 'Personnes au foyer',
                  value: survey.nombrePersonnesFoyer != null
                      ? '${survey.nombrePersonnesFoyer} personne(s)'
                      : null,
                  fallback: 'Non renseigné',
                ),
                const SizedBox(height: 8),
                _RecapRow(
                  icon: Icons.work_rounded,
                  color: AppTheme.accentGold,
                  label: 'Situation emploi',
                  value: survey.situationEmploi,
                  fallback: 'Non renseigné',
                ),
                const SizedBox(height: 8),
                _RecapRow(
                  icon: Icons.warning_amber_rounded,
                  color: AppTheme.dangerRed,
                  label: 'Vulnérabilités',
                  value: survey.vulnerabilites.isEmpty
                      ? null
                      : '${survey.vulnerabilites.length} identifiée(s)',
                  fallback: 'Aucune',
                ),
                if (survey.agentNom != null &&
                    survey.agentNom!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _RecapRow(
                    icon: Icons.badge_rounded,
                    color: AppTheme.primaryGreen,
                    label: 'Agent',
                    value:
                        '${survey.agentNom} · ${survey.cpsOrigine ?? ''}',
                    fallback: '',
                  ),
                ],
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
  final Color color;
  final String label;
  final String? value;
  final String fallback;

  const _RecapRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.lightText,
                ),
              ),
              Text(
                (value != null && value!.isNotEmpty) ? value! : fallback,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bloc PDF ─────────────────────────────────────────────────────────────────
class _PdfBlock extends StatelessWidget {
  final bool isGenerating;
  final VoidCallback onGenerate;

  const _PdfBlock({required this.isGenerating, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFEAEEF2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: AppTheme.accentOrange, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rapport PDF Officiel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Format A4 · Prêt à imprimer et transmettre',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEAEEF2)),
          const SizedBox(height: 16),
          // Checklist document
          ..._docItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 16, color: AppTheme.successGreen),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isGenerating ? null : onGenerate,
              icon: isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 22),
              label: Text(
                isGenerating
                    ? 'Génération en cours...'
                    : 'Générer & Partager le Rapport PDF',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _docItems = [
    'En-tête officiel République du Bénin',
    'Données d\'identité et de localisation',
    'Évaluation des conditions de logement',
    'Facteurs de vulnérabilité identifiés',
    'Synthèse, recommandations et type d\'aide',
    'Signature de l\'agent et horodatage',
  ];
}

// ─── FormCard partagée ────────────────────────────────────────────────────────
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
                bottom:
                    BorderSide(color: headerColor.withValues(alpha: 0.15)),
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

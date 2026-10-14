import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/screens/steps/step_identity.dart';
import 'package:app_cps/screens/steps/step_housing.dart';
import 'package:app_cps/screens/steps/step_synthesis.dart';
import 'package:app_cps/utils/app_theme.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  static const _steps = [
    _StepMeta(
      label: 'Identité',
      description: 'Informations personnelles de l\'usager',
      icon: Icons.person_rounded,
    ),
    _StepMeta(
      label: 'Logement',
      description: 'Conditions de vie et vulnérabilités',
      icon: Icons.home_rounded,
    ),
    _StepMeta(
      label: 'Synthèse',
      description: 'Observations et rapport PDF',
      icon: Icons.summarize_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(
      builder: (context, provider, _) {
        final step = provider.currentStep;
        final meta = _steps[step];
        return Scaffold(
          backgroundColor: AppTheme.lightBackground,
          // ── AppBar ──────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {
                if (step > 0) {
                  provider.previousStep();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: Column(
              children: [
                const Text(
                  'Rapport d\'Enquête Sociale',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Étape ${step + 1} sur 3 · ${meta.label}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${((step + 1) / 3 * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── Corps ───────────────────────────────────────────────────────
          body: Column(
            children: [
              // Stepper + barre de progression
              _StepperHeader(currentStep: step, steps: _steps),
              // Étiquette de l'étape courante
              _StepLabel(meta: meta),
              // Contenu de l'étape
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(step),
                    child: _stepWidget(step),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stepWidget(int step) {
    switch (step) {
      case 0: return const StepIdentity();
      case 1: return const StepHousing();
      case 2: return const StepSynthesis();
      default: return const StepIdentity();
    }
  }
}

// ─── Métadonnées d'une étape ──────────────────────────────────────────────────
class _StepMeta {
  final String label;
  final String description;
  final IconData icon;
  const _StepMeta({
    required this.label,
    required this.description,
    required this.icon,
  });
}

// ─── Header Stepper ───────────────────────────────────────────────────────────
class _StepperHeader extends StatelessWidget {
  final int currentStep;
  final List<_StepMeta> steps;

  const _StepperHeader({required this.currentStep, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryGreen,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          // Barre de progression animée
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentStep + 1) / steps.length,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          // Indicateurs circulaires
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connecteur
                final stepIdx = index ~/ 2;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: stepIdx < currentStep
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }
              final stepIdx = index ~/ 2;
              final isCompleted = stepIdx < currentStep;
              final isActive = stepIdx == currentStep;
              return _StepDot(
                stepNumber: stepIdx + 1,
                label: steps[stepIdx].label,
                icon: steps[stepIdx].icon,
                isActive: isActive,
                isCompleted: isCompleted,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int stepNumber;
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;

  const _StepDot({
    required this.stepNumber,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 44 : 36,
          height: isActive ? 44 : 36,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.white
                : isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.20),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.40),
              width: isActive ? 2.5 : 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check_rounded,
                    color: AppTheme.primaryGreen, size: 18)
                : Icon(
                    icon,
                    color: isActive
                        ? AppTheme.primaryGreen
                        : Colors.white.withValues(alpha: 0.70),
                    size: isActive ? 20 : 17,
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

// ─── Label de l'étape courante ────────────────────────────────────────────────
class _StepLabel extends StatelessWidget {
  final _StepMeta meta;
  const _StepLabel({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(meta.icon, color: AppTheme.primaryGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkText,
                  ),
                ),
                Text(
                  meta.description,
                  style: const TextStyle(
                    fontSize: 12,
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

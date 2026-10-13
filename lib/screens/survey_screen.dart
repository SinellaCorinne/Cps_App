import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/screens/steps/step_identity.dart';
import 'package:app_cps/screens/steps/step_housing.dart';
import 'package:app_cps/screens/steps/step_synthesis.dart';
import 'package:app_cps/utils/app_theme.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rapport d\'Enquête Sociale'),
            actions: const [],
          ),
          body: Column(
            children: [
              // Stepper horizontal personnalisé
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    _StepIndicator(
                      stepNumber: 1,
                      label: 'Identité',
                      isActive: provider.currentStep == 0,
                      isCompleted: provider.currentStep > 0,
                    ),
                    _StepConnector(isActive: provider.currentStep > 0),
                    _StepIndicator(
                      stepNumber: 2,
                      label: 'Logement',
                      isActive: provider.currentStep == 1,
                      isCompleted: provider.currentStep > 1,
                    ),
                    _StepConnector(isActive: provider.currentStep > 1),
                    _StepIndicator(
                      stepNumber: 3,
                      label: 'Synthèse',
                      isActive: provider.currentStep == 2,
                      isCompleted: false,
                    ),
                  ],
                ),
              ),
              
              // Contenu de l'étape
              Expanded(
                child: _getStepContent(provider.currentStep),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return const StepIdentity();
      case 1:
        return const StepHousing();
      case 2:
        return const StepSynthesis();
      default:
        return const StepIdentity();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isCompleted) {
      color = AppTheme.successGreen;
    } else if (isActive) {
      color = AppTheme.primaryGreen;
    } else {
      color = Colors.grey.shade300;
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.5),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '$stepNumber',
                      style: TextStyle(
                        color: isActive ? Colors.white : color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.5,
        margin: const EdgeInsets.only(bottom: 28),
        color: isActive ? AppTheme.successGreen : Colors.grey.shade300,
      ),
    );
  }
}

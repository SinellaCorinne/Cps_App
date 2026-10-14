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
  late TextEditingController _agentNomController;
  late TextEditingController _cpsOrigineController;

  String _selectedGenre = 'Féminin';

  @override
  void initState() {
    super.initState();
    final s = Provider.of<SurveyProvider>(context, listen: false).currentSurvey;
    _nomController             = TextEditingController(text: s.nom);
    _prenomController          = TextEditingController(text: s.prenom);
    _ageController             = TextEditingController(text: s.age?.toString() ?? '');
    _telephoneController       = TextEditingController(text: s.telephone ?? '');
    _communeController         = TextEditingController(text: s.commune ?? '');
    _arrondissementController  = TextEditingController(text: s.arrondissement ?? '');
    _agentNomController        = TextEditingController(text: s.agentNom ?? '');
    _cpsOrigineController      = TextEditingController(text: s.cpsOrigine ?? '');
    _selectedGenre             = s.genre;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _ageController.dispose();
    _telephoneController.dispose();
    _communeController.dispose();
    _arrondissementController.dispose();
    _agentNomController.dispose();
    _cpsOrigineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // ── Section agent ─────────────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.secondaryBlue,
            headerIcon: Icons.badge_rounded,
            headerTitle: 'Informations de l\'Agent',
            children: [
              _FieldRow(
                children: [
                  Expanded(
                    child: _Field(
                      controller: _agentNomController,
                      label: 'Nom de l\'agent *',
                      icon: Icons.person_pin_rounded,
                      validator: _required('Le nom de l\'agent est obligatoire'),
                      capitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _cpsOrigineController,
                label: 'CPS d\'origine *',
                icon: Icons.account_balance_rounded,
                hint: 'Ex: CPS Abomey-Calavi',
                validator: _required('Le CPS est obligatoire'),
                capitalization: TextCapitalization.words,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Section usager ────────────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.primaryGreen,
            headerIcon: Icons.person_rounded,
            headerTitle: 'Identité de l\'Usager',
            children: [
              // Avatar
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.30),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),

              // Nom / Prénom
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      controller: _nomController,
                      label: 'Nom *',
                      icon: Icons.badge_rounded,
                      capitalization: TextCapitalization.characters,
                      validator: _required('Obligatoire'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      controller: _prenomController,
                      label: 'Prénom(s) *',
                      icon: Icons.person_outline_rounded,
                      capitalization: TextCapitalization.words,
                      validator: _required('Obligatoire'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Genre
              _GenreSelector(
                selected: _selectedGenre,
                onChanged: (g) => setState(() => _selectedGenre = g),
              ),

              const SizedBox(height: 16),

              // Âge / Téléphone
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      controller: _ageController,
                      label: 'Âge',
                      icon: Icons.cake_rounded,
                      suffix: 'ans',
                      keyboard: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _Field(
                      controller: _telephoneController,
                      label: 'Téléphone',
                      icon: Icons.phone_rounded,
                      hint: '+229 XX XX XX XX',
                      keyboard: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Section localisation ──────────────────────────────────────
          _FormCard(
            headerColor: AppTheme.accentOrange,
            headerIcon: Icons.location_on_rounded,
            headerTitle: 'Localisation',
            children: [
              _Field(
                controller: _communeController,
                label: 'Commune',
                icon: Icons.location_city_rounded,
                hint: 'Ex: Abomey-Calavi',
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _arrondissementController,
                label: 'Arrondissement / Quartier',
                icon: Icons.place_rounded,
                hint: 'Ex: Godomey',
                capitalization: TextCapitalization.words,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Navigation ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Suivant — Logement'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final p = Provider.of<SurveyProvider>(context, listen: false);
                      p.updateIdentity(
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        genre: _selectedGenre,
                        age: int.tryParse(_ageController.text),
                        telephone: _telephoneController.text,
                        commune: _communeController.text,
                        arrondissement: _arrondissementController.text,
                      );
                      // Agent info
                      p.currentSurvey.agentNom   = _agentNomController.text;
                      p.currentSurvey.cpsOrigine = _cpsOrigineController.text;
                      p.nextStep();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? Function(String?) _required(String msg) =>
      (v) => (v == null || v.trim().isEmpty) ? msg : null;
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              border: Border(
                bottom: BorderSide(
                  color: headerColor.withValues(alpha: 0.15),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(headerIcon, color: headerColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  headerTitle,
                  style: TextStyle(
                    color: headerColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Body
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

// ─── Champ textuel générique ──────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final String? suffix;
  final TextInputType? keyboard;
  final TextCapitalization capitalization;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.suffix,
    this.keyboard,
    this.capitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: capitalization,
      maxLines: 1,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final List<Widget> children;
  const _FieldRow({required this.children});
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
}

// ─── Sélecteur de genre ───────────────────────────────────────────────────────
class _GenreSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _GenreSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE2EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wc_rounded, size: 16, color: AppTheme.mediumText),
              SizedBox(width: 6),
              Text(
                'Genre *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mediumText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _GenreOption(
                  label: 'Féminin',
                  icon: Icons.woman_rounded,
                  isSelected: selected == 'Féminin',
                  onTap: () => onChanged('Féminin'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GenreOption(
                  label: 'Masculin',
                  icon: Icons.man_rounded,
                  isSelected: selected == 'Masculin',
                  onTap: () => onChanged('Masculin'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenreOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGreen
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryGreen
                : const Color(0xFFDDE2EA),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : AppTheme.lightText,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? Colors.white : AppTheme.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

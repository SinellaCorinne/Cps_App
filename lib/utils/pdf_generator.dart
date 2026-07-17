import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:app_cps/models/survey_model.dart';

class PDFGenerator {
  static Future<void> generateAndPreview(
    BuildContext context,
    SurveyModel survey,
  ) async {
    final pdf = pw.Document();

    // Génération du contenu PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(),
          pw.SizedBox(height: 20),
          _buildTitle(survey),
          pw.SizedBox(height: 20),
          _buildIdentitySection(survey),
          pw.SizedBox(height: 15),
          _buildHousingSection(survey),
          pw.SizedBox(height: 15),
          _buildVulnerabilitiesSection(survey),
          pw.SizedBox(height: 15),
          _buildSynthesisSection(survey),
          pw.SizedBox(height: 20),
          _buildFooter(survey),
        ],
        footer: (context) => _buildPageFooter(context),
      ),
    );

    // Prévisualisation et partage du PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Rapport_Enquete_${survey.nom}_${survey.prenom}.pdf',
    );
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green800, width: 2),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        children: [
          pw.Text(
            'RÉPUBLIQUE DU BÉNIN',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'MINISTÈRE DES AFFAIRES SOCIALES ET DE LA MICROFINANCE',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'Direction des Centres de Promotion Sociale',
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.green800, thickness: 1),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                width: 40,
                height: 40,
                decoration: pw.BoxDecoration(
                  color: PdfColors.green800,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'CPS',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitle(SurveyModel survey) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'RAPPORT D\'ENQUÊTE SOCIALE',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green900,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Text(
            'Réf: ${survey.id ?? "EN ATTENTE"} - ${DateFormat('dd/MM/yyyy').format(survey.dateEnquete)}',
            style: const pw.TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildIdentitySection(SurveyModel survey) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('1. IDENTITÉ ET SITUATION DE L\'USAGER'),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              children: [
                _buildInfoRow('Nom', survey.nom),
                _buildInfoRow('Prénom(s)', survey.prenom),
                _buildInfoRow('Genre', survey.genre),
                _buildInfoRow('Âge', survey.age != null ? '${survey.age} ans' : 'Non renseigné'),
                _buildInfoRow('Téléphone', survey.telephone ?? 'Non renseigné'),
                pw.SizedBox(height: 8),
                _buildInfoRow('Commune', survey.commune ?? 'Non renseigné'),
                _buildInfoRow('Arrondissement/Quartier', survey.arrondissement ?? 'Non renseigné'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHousingSection(SurveyModel survey) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('2. ÉVALUATION DU LOGEMENT ET CONDITIONS DE VIE'),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Type de logement', survey.typeLogement ?? 'Non renseigné'),
                _buildInfoRow('État du logement', _getRatingText(survey.etatLogement)),
                _buildInfoRow('Accès à l\'eau potable', _getRatingText(survey.acceauEau)),
                _buildInfoRow('Accès à l\'électricité', _getRatingText(survey.acceauElectricite)),
                pw.SizedBox(height: 8),
                _buildInfoRow('Nombre de personnes au foyer', survey.nombrePersonnesFoyer?.toString() ?? 'Non renseigné'),
                _buildInfoRow('Situation d\'emploi', survey.situationEmploi ?? 'Non renseigné'),
                _buildInfoRow('Revenu mensuel estimé', survey.revenuEstime != null ? '${NumberFormat('#,###', 'fr_FR').format(survey.revenuEstime)} FCFA' : 'Non renseigné'),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Biens possédés:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    _buildCheckbox('Télévision', survey.possedeTelev ?? false),
                    pw.SizedBox(width: 20),
                    _buildCheckbox('Réfrigérateur', survey.possedeFrigo ?? false),
                    pw.SizedBox(width: 20),
                    _buildCheckbox('Véhicule', survey.possedeVehicule ?? false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildVulnerabilitiesSection(SurveyModel survey) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('3. FACTEURS DE VULNÉRABILITÉ IDENTIFIÉS'),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: survey.vulnerabilites.isEmpty
                ? pw.Text(
                    'Aucun facteur de vulnérabilité spécifique identifié.',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  )
                : pw.Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: survey.vulnerabilites.map((vuln) {
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.orange100,
                          borderRadius: pw.BorderRadius.circular(3),
                          border: pw.Border.all(color: PdfColors.orange300),
                        ),
                        child: pw.Text(
                          vuln,
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSynthesisSection(SurveyModel survey) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('4. SYNTHÈSE ET RECOMMANDATIONS'),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Observations générales:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  survey.observationsGenerales ?? 'Aucune observation.',
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Recommandations et plan d\'action:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  survey.recommandations ?? 'Aucune recommandation.',
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 10),
                _buildInfoRow('Type d\'aide préconisée', survey.typeAide ?? 'À déterminer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(SurveyModel survey) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Agent social:',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    survey.agentNom ?? 'Non renseigné',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Signature: _______________',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CPS:',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    survey.cpsOrigine ?? 'Non renseigné',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Date:',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    DateFormat('dd/MM/yyyy').format(survey.dateEnquete),
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPageFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Page ${context.pageNumber} / ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.green800,
        borderRadius: pw.BorderRadius.only(
          topLeft: pw.Radius.circular(5),
          topRight: pw.Radius.circular(5),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCheckbox(String label, bool checked) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 12,
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey800),
          ),
          child: checked
              ? pw.Center(
                  child: pw.Text(
                    '✓',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        pw.SizedBox(width: 5),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  static String _getRatingText(int? rating) {
    if (rating == null) return 'Non évalué';
    switch (rating) {
      case 1:
        return 'Très mauvais (1/5)';
      case 2:
        return 'Mauvais (2/5)';
      case 3:
        return 'Moyen (3/5)';
      case 4:
        return 'Bon (4/5)';
      case 5:
        return 'Excellent (5/5)';
      default:
        return 'Non évalué';
    }
  }
}

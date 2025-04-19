import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraix/database/app.generalmanager.dart';

class BalanceService {
  // URL de base de l'API
  final String baseUrl = 'http://localhost:9090'; // À remplacer par votre URL d'API réelle

  // Récupérer le solde du transporteur par email
  Future<Map<String, dynamic>> getBalance(String email) async {
    try {
      // Récupérer le token d'authentification
      final String? token = await GeneralManagerDB.getSessionUser();

      if (token == null) {
        return {'success': false, 'message': 'Utilisateur non authentifié', 'data': null};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/soldes/mail/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic responseData = jsonDecode(responseBody);

        // Les données sont déjà dans le bon format, on les passe directement
        return {'success': true, 'message': 'Solde récupéré avec succès', 'data': responseData};
      } else {
        // Gérer les différents codes d'erreur
        String message = 'Erreur lors de la récupération du solde';

        try {
          final errorData = jsonDecode(response.body);
          message = errorData['message'] ?? message;
        } catch (_) {}

        return {'success': false, 'message': message, 'data': null};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion au serveur: ${e.toString()}', 'data': null};
    }
  }

  // Récupérer le solde du transporteur connecté
  Future<Map<String, dynamic>> getCurrentUserBalance() async {
    try {
      // Récupérer les informations de l'utilisateur connecté
      final userDetails = await GeneralManagerDB.getUserDetails();

      if (userDetails == null) {
        return {'success': false, 'message': 'Utilisateur non connecté', 'data': null};
      }

      // Utiliser l'email de l'utilisateur connecté
      return getBalance(userDetails.email);
    } catch (e) {
      return {'success': false, 'message': 'Erreur lors de la récupération du solde: ${e.toString()}', 'data': null};
    }
  }
}

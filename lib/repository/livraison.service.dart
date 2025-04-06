import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraix/database/app.generalmanager.dart';

class LivraisonService {
  // URL de base de l'API
  final String baseUrl = 'https://api.livraix.com'; // À remplacer par votre URL d'API réelle

  // Récupérer toutes les livraisons disponibles
  Future<Map<String, dynamic>> getLivraisons() async {
    try {
      // Récupérer le token d'authentification
      final String? token = await GeneralManagerDB.getSessionUser();

      if (token == null) {
        return {'success': false, 'message': 'Utilisateur non authentifié', 'data': null};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/livraisons'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
          final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> responseData = jsonDecode(responseBody);

        // Les données sont déjà dans le bon format, on les passe directement
        return {'success': true, 'message': 'Livraisons récupérées avec succès', 'data': responseData};
      } else {
        // Gérer les différents codes d'erreur
        String message = 'Erreur lors de la récupération des livraisons';

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
}

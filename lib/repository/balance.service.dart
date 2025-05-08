import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraix/database/app.generalmanager.dart';

class BalanceService {
  // URL de base de l'API
  final String baseUrl = 'https://api.livraix.com'; // À remplacer par votre URL d'API réelle

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
        // Décoder la réponse avec gestion de l'encodage UTF-8
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic responseData = jsonDecode(responseBody);

        // La réponse est directement passée à la vue
        // On suppose que l'API retourne déjà le format attendu comme dans l'exemple fourni
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

  // Calculer les frais de retrait
  Future<Map<String, dynamic>> calculateWithdrawalFee({
    required String country,
    required String provider,
    required double amount,
    String operationType = "TOP_UP",
    bool toReceive = true,
  }) async {
    try {
      // Récupérer le token d'authentification
      final String? token = await GeneralManagerDB.getSessionUser();

      if (token == null) {
        return {'success': false, 'message': 'Utilisateur non authentifié', 'data': null};
      }

      print('token: $token');
      print("provider: $provider");
      print("amount: $amount");
      print("operationType: $operationType");
      print("toReceive: $toReceive");

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/fee/getFee'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "country": country,
          "provider": provider,
          "amount": amount,
          "operationType": operationType,
          "toReceive": toReceive,
        }),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic responseData = jsonDecode(responseBody);

        if (responseData['success'] == true) {
          // Calculer les frais en soustrayant le montant initial du montant total
          final double totalAmount =
              responseData['amountWithFee'] != null ? double.parse(responseData['amountWithFee'].toString()) : 0.0;
          final double feeAmount = totalAmount - amount;
          return {
            'success': true,
            'message': responseData['message'] ?? 'Calcul des frais réussi',
            'data': {'totalAmount': totalAmount, 'feeAmount': feeAmount, 'originalAmount': amount}
          };
        } else {
          return {'success': false, 'message': responseData['message'] ?? 'Erreur lors du calcul des frais', 'data': null};
        }
      } else {
        // Gérer les différents codes d'erreur
        String message = 'Erreur lors du calcul des frais';

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

  // Faire un retrait
  Future<Map<String, dynamic>> makeWithdrawal({
    required String phoneNumber,
    required double amount,
    required String provider,
    String country = "CI",
    String currency = "XOF",
  }) async {
    try {
      // Récupérer le token d'authentification
      final String? token = await GeneralManagerDB.getSessionUser();

      if (token == null) {
        return {'success': false, 'message': 'Utilisateur non authentifié', 'data': null};
      }

      // Récupérer l'utilisateur actuellement connecté
      final userDetails = await GeneralManagerDB.getUserDetails();

      if (userDetails == null) {
        return {'success': false, 'message': 'Utilisateur non connecté', 'data': null};
      }

      final userId = userDetails.id;

      if (userId == null) {
        return {'success': false, 'message': 'ID utilisateur non disponible', 'data': null};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/paiement/hub/postPaymentIntents'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "userId": userId,
          "country": country,
          "provider": provider,
          "amount": amount,
          "currency": currency,
        }),
      );

        print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');


      if (response.statusCode == 200) {
        // Essayer de parser la réponse comme JSON
        try {
          final String responseBody = utf8.decode(response.bodyBytes);
          final dynamic responseData = jsonDecode(responseBody);

          return {'success': true, 'message': 'Retrait initié avec succès', 'data': responseData};
        } catch (_) {
          // Si la réponse n'est pas un JSON valide, utiliser le contenu texte brut
          final String responseText = response.body;

          return {
            'success': true,
            'message': 'Retrait initié',
            'data': {'response': responseText}
          };
        }
      } else {
        // Gérer les différents codes d'erreur
        String message = 'Erreur lors du retrait';

        try {
          // Essayer de parser l'erreur comme JSON
          final errorData = jsonDecode(response.body);
          message = errorData['message'] ?? message;
        } catch (_) {
          // Si ce n'est pas un JSON valide, utiliser le texte brut de la réponse
          message = response.body.isNotEmpty ? response.body : 'Quelque chose s\'est mal passé';
        }

        return {'success': false, 'message': message, 'data': null};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion au serveur: ${e.toString()}', 'data': null};
    }
  }
}

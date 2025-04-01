import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/models/user_cnx_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // URL de base de l'API
  final String baseUrl = 'https://api.livraix.com'; // À remplacer par votre URL d'API réelle

  // Méthode d'enregistrement d'un transporteur
  Future<Map<String, dynamic>> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String numeroPermis,
    required bool licence,
    required String localisation,
    required String numMatriculation,
    required String camionType,
    required bool assurance,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/registerTransporteur'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'role': 'TRANSPORTEUR',
          'numeroPermis': numeroPermis,
          'licence': licence,
          'localisation': localisation,
          'vehicule': {
            'numMatriculation': numMatriculation,
            'camionType': camionType,
            'capacite': 0,
            'assurance': assurance,
            'carteGrise': true
          }
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Enregistrement réussi
        return {
          'success': true,
          'message': 'Compte créé avec succès. Veuillez vérifier votre email pour activer votre compte.',
          'data': responseData
        };
      } else {
        // Échec de l'enregistrement
        return {'success': false, 'message': responseData['businessErreurDescription'] ?? 'Erreur lors de l\'enregistrement', 'data': null};
      }
    } catch (e) {
      // Erreur de connexion ou autre
      return {'success': false, 'message': 'Erreur de connexion au serveur: ${e.toString()}', 'data': null};
    }
  }

  // Méthode de validation du code email
  Future<Map<String, dynamic>> verifyEmailCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/valider-mail/$code'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Si la réponse contient un corps, on le décode
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        responseData = jsonDecode(response.body);
      }

      if (response.statusCode == 202) {
        // Vérification réussie
        return {'success': true, 'message': 'Votre adresse email a été vérifiée avec succès.', 'data': responseData};
      } else {
        // Échec de la vérification
        return {
          'success': false,
          'message': responseData['businessErreurDescription'] ?? 'Code de vérification incorrect ou expiré.',
          'data': null
        };
      }
    } catch (e) {
      // Erreur de connexion ou autre
      return {'success': false, 'message': 'Erreur de connexion au serveur: ${e.toString()}', 'data': null};
    }
  }

    // Méthode de connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // 1. Appel API pour l'authentification
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (loginResponse.statusCode != 200) {
        // Échec de l'authentification
        Map<String, dynamic> errorData = {};
        try {
          errorData = jsonDecode(loginResponse.body);
        } catch (_) {
          // Si le corps n'est pas un JSON valide
        }
        return {'success': false, 'message': errorData['businessErreurDescription'] ?? 'Identifiants incorrects', 'data': null};
      }

      // Succès de l'authentification
      final loginData = jsonDecode(loginResponse.body);
      final String token = loginData['token'];

      // Enregistrer le token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await GeneralManagerDB.saveSessionUser(token);

      // 2. Récupérer les informations de l'utilisateur
      final userResponse = await http.get(
        Uri.parse('$baseUrl/api/v1/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (userResponse.statusCode == 200) {
        // Traitement des informations utilisateur
        final List<dynamic> usersData = jsonDecode(userResponse.body);

        // Rechercher l'utilisateur correspondant à l'email
        Map<String, dynamic>? userData;
        for (var user in usersData) {
          if (user['email'] == email) {
            userData = user;
            break;
          }
        }

        if (userData != null) {
          // Adapter les données pour les mettre au format UserDetails
          // Ceci est un exemple - à adapter selon votre structure de données
          final userDetails = _mapUserDataToUserDetails(userData);

          // Sauvegarder les détails utilisateur
          if (userDetails != null) {
            await GeneralManagerDB.saveUserDetails(userDetails);
          }
        }

        return {
          'success': true,
          'message': 'Connexion réussie',
          'data': {'token': token}
        };
      } else {
        // Échec de récupération des informations utilisateur
        // Mais l'authentification a réussi, donc on considère comme un succès
        return {
          'success': true,
          'message': 'Connexion réussie, mais impossible de récupérer vos informations.',
          'data': {'token': token}
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion au serveur: ${e.toString()}', 'data': null};
    }
  }

  // Méthode privée pour mapper les données utilisateur au format UserDetails
  UserDetails? _mapUserDataToUserDetails(Map<String, dynamic> userData) {
    try {
      // Exemple d'adaptation - à personnaliser selon votre structure
      return UserDetails(
        id: userData['id'],
        username: userData['email'],
        roles: [userData['role']],
        email: userData['email'],
        typeCompte: [userData['role']],
        profile: Profile(
          id: 0, // ID par défaut ou à générer
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          telephone: '', // À compléter si disponible
          addresse: '', // À compléter si disponible
          createdAt: DateTime.now(),
          logo: null,
          isCompleted: true,
        ),
        createdAt: DateTime.now(),
        isDeleted: false,
        status: userData['enabled'] ?? false,
      );
    } catch (e) {
      print('Erreur lors du mapping des données utilisateur: ${e.toString()}');
      return null;
    }
  }
}

class ChatbotService {
  Future<String> getBotResponse(String userMessage) async {
    // Simuler un délai de réponse
    await Future.delayed(const Duration(milliseconds: 500));

    // Logique simple de réponse basée sur des mots-clés
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('prix') || lowerMessage.contains('coût')) {
      return 'Les prix varient selon la distance et le type de transport. Voulez-vous une estimation pour un trajet spécifique?';
    }

    if (lowerMessage.contains('maritime')) {
      return 'Nous proposons des services de fret maritime avec des conteneurs de différentes tailles. Quel type de marchandise souhaitez-vous transporter?';
    }

    if (lowerMessage.contains('aérien')) {
      return 'Le fret aérien est idéal pour les envois urgents et les marchandises de haute valeur. Quelle est votre destination?';
    }

    if (lowerMessage.contains('terrestre') || lowerMessage.contains('routier')) {
      return 'Notre réseau routier couvre toute la Côte d\'Ivoire. Nous disposons de différents types de camions selon vos besoins.';
    }

    if (lowerMessage.contains('bonjour') || lowerMessage.contains('salut')) {
      return 'Bonjour! Comment puis-je vous aider avec vos besoins en transport?';
    }

    return 'Je peux vous aider avec les services de fret maritime, aérien et terrestre. Que souhaitez-vous savoir en particulier?';
  }
}
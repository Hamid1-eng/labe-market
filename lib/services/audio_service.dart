import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final FlutterTts _tts = FlutterTts();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    _initTts();
  }

  void _initTts() {
    _tts.setLanguage('ff'); // Fula/Pular language code
    _tts.setPitch(1.0);
    _tts.setSpeechRate(0.8);
  }

  /// Guide audio en Pular pour les produits
  Future<void> readProductGuide(String productName) async {
    final text = _getPularProductGuide(productName);
    await _tts.speak(text);
  }

  /// Guide audio en Pular pour le panier
  Future<void> readCartGuide() async {
    final text = _getPularCartGuide();
    await _tts.speak(text);
  }

  /// Guide audio en Pular pour l'accueil
  Future<void> readHomeGuide() async {
    final text = _getPularHomeGuide();
    await _tts.speak(text);
  }

  /// Guide audio en Pular pour les favoris
  Future<void> readFavoritesGuide() async {
    final text = _getPularFavoritesGuide();
    await _tts.speak(text);
  }

  /// Guide audio en Pular pour les notifications
  Future<void> readNotificationsGuide() async {
    final text = _getPularNotificationsGuide();
    await _tts.speak(text);
  }

  /// Guide audio en Pular pour le profil
  Future<void> readProfileGuide() async {
    final text = _getPularProfileGuide();
    await _tts.speak(text);
  }

  /// Arrêter la lecture audio
  Future<void> stop() async {
    await _tts.stop();
  }

  // Guides en Pular
  String _getPularProductGuide(String productName) {
    return 'Jëfandikoo $productName. '
        'Moofal bidde, naata bilaagu neɗɗo kuutorta. '
        'Golle kanut hakkunde hee innde baaylo nde. '
        'Waada joomme teelewal ndiyam.';
  }

  String _getPularCartGuide() {
    return 'Binndirde kartal maa. '
        'Moofal ndiyam waawde leydi maa keewum. '
        'Waata kuutor haa mogulee naate baaylo. '
        'Jingire kodke maa kuutorta kam wee baaylo.';
  }

  String _getPularHomeGuide() {
    return 'Jamme ngoodi e Labé Marché. '
        'Wonaa e ndiyam be njangte. '
        'Naatu e gollal, jawdi, e feere. '
        'Jëfandikoo jokkondiral ngol ngam yidde.';
  }

  String _getPularFavoritesGuide() {
    return 'Moofal yilteeni maa. '
        'Waata baaylo kaa hee innde yilte. '
        'Golle jëngal maa kuutorta. '
        'Naate moofal baaylo kam dañde kuutorta baay.';
  }

  String _getPularNotificationsGuide() {
    return 'Kabaruuji maa. '
        'Waata neɗɗo kuutorta maa neɓa. '
        'Golle kabaruuji ndiyam waawde. '
        'Jingire kodke maa haa daartum.';
  }

  String _getPularProfileGuide() {
    return 'Kontine maa. '
        'Moofal ndiyam binndirde waawde. '
        'Golle imaaɗe maa kuutorta. '
        'Waata famme maa haa neɓoye taare.';
  }
}

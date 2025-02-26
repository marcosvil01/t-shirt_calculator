const Map<String, double> _shirtPrices = {
  'S': 7.99,
  'M': 9.95,
  'L': 13.50,
  'XL': 15.99,
};

/// Calcula el preu sense descomptes d'un nombre [numero] de samarretes,
/// de talla [talla], i amb un cost extra si [customPrint] és true.
/// Llencem ArgumentError si [numero] és negatiu, o si la talla no està en `_shirtPrices`.
double calculaPreuSamarretes(int numero, String talla, {bool customPrint = false}) {
  if (numero < 0) {
    throw ArgumentError('El número de samarretes no pot ser negatiu');
  }

  // Rebem el preu base de la talla
  final double? basePrice = _shirtPrices[talla];
  if (basePrice == null) {
    throw ArgumentError('Talla desconeguda: $talla');
  }

  // Si hi ha estampat personalitzat, sumem 3.0 al preu de cada samarreta
  final double finalUnitPrice = customPrint ? (basePrice + 3.0) : basePrice;

  return numero * finalUnitPrice;
}

/// Retorna l'import de descompte a aplicar sobre [preu] en funció de [tipusDescompte].
///  tipusDescompte:
///    1 => 10%
///    2 => 20€ si preu > 100
///    3 => 50% si preu > 300
///    0 => cap descompte
double calculaDescompte(double preu, int tipusDescompte) {
  switch (tipusDescompte) {
    case 1: // 10%
      return preu * 0.10;
    case 2: // 20€ si supera 100
      return (preu > 100) ? 20.0 : 0.0;
    case 3: // 50% si supera 300
      return (preu > 300) ? (preu * 0.5) : 0.0;
    default: // cap descompte
      return 0.0;
  }
}

/// Funció final que calcula el preu definitiu.
/// [numero], [talla], [tipusDescompte], i si [customPrint] és true.
double preuDefinitiu(int numero, String talla, int tipusDescompte, {bool customPrint = false}) {
  // Preu base (sense descompte) amb o sense estampat
  final double preuSenseDescompte = calculaPreuSamarretes(numero, talla, customPrint: customPrint);
  // Import de descompte a restar
  final double descompte = calculaDescompte(preuSenseDescompte, tipusDescompte);
  return preuSenseDescompte - descompte;
}

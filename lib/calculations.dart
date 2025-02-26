double calculaPreuSamarretes(int numero, String talla) {
  // Afegim aquest control previ:
  if (numero < 0) {
    throw ArgumentError('El número de samarretes no pot ser negatiu');
  }

  double preuUnitari;
  switch (talla) {
    case 'S':
      preuUnitari = 7.99;
      break;
    case 'M':
      preuUnitari = 9.95;
      break;
    case 'L':
      preuUnitari = 13.50;
      break;
    default:
      throw ArgumentError('Talla desconeguda: $talla');
  }

  return numero * preuUnitari;
}


double calculaDescompte(double preu, int tipusDescompte) {
  // tipusDescompte:
  //    1 => 10%
  //    2 => 20€ si preu > 100
  //    0 (o un altre valor) => cap descompte

  switch (tipusDescompte) {
    case 1:
    // 10%
      return preu * 0.10;
    case 2:
    // 20€ si supera 100
      return (preu > 100) ? 20.0 : 0.0;
    default:
      return 0.0;
  }
}

double preuDefinitiu(int numero, String talla, int tipusDescompte) {
  final preuSenseDescompte = calculaPreuSamarretes(numero, talla);
  final descompte = calculaDescompte(preuSenseDescompte, tipusDescompte);
  return preuSenseDescompte - descompte;
}

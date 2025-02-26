import 'package:flutter_test/flutter_test.dart';
import 'package:tshirt_calculator/calculations.dart';

void main() {
  group('Proves unitàries de càlcul de samarretes (25 tests)', () {
    // 1) 3 tests bàsics de calculaPreuSamarretes amb 0 samarretes
    test('1) Talla S, 0 samarretes => 0.0', () {
      final preu = calculaPreuSamarretes(0, 'S');
      expect(preu, 0.0);
    });

    test('2) Talla M, 0 samarretes => 0.0', () {
      final preu = calculaPreuSamarretes(0, 'M');
      expect(preu, 0.0);
    });

    test('3) Talla L, 0 samarretes => 0.0', () {
      final preu = calculaPreuSamarretes(0, 'L');
      expect(preu, 0.0);
    });

    // 2) Casos estranys: talla invàlida, negatiu
    test('4) Talla invàlida => ArgumentError', () {
      expect(() => calculaPreuSamarretes(5, 'XXL'), throwsArgumentError);
    });

    test('5) Nombre de samarretes negatiu => ArgumentError', () {
      expect(() => calculaPreuSamarretes(-1, 'S'), throwsArgumentError);
    });

    // 3) Alguns càlculs normals
    // S = 7.99, M = 9.95, L = 13.50, XL = 15.99
    test('6) Talla S, 10 samarretes => 79.9', () {
      final preu = calculaPreuSamarretes(10, 'S');
      expect(preu, closeTo(79.9, 0.0001));
    });

    test('7) Talla M, 10 samarretes => 99.5', () {
      final preu = calculaPreuSamarretes(10, 'M');
      expect(preu, closeTo(99.5, 0.0001));
    });

    test('8) Talla L, 10 samarretes => 135.0', () {
      final preu = calculaPreuSamarretes(10, 'L');
      expect(preu, closeTo(135.0, 0.0001));
    });

    // 4) Tests de calculaDescompte (tipus 1 = 10%)
    test('9) Descompte 1 (10%) sobre 100.0 => 10.0', () {
      final d = calculaDescompte(100.0, 1);
      expect(d, closeTo(10.0, 0.0001));
    });

    test('10) Descompte 1 (10%) sobre 0.0 => 0.0', () {
      final d = calculaDescompte(0.0, 1);
      expect(d, closeTo(0.0, 0.0001));
    });

    // 5) Tests de calculaDescompte (tipus 2 = 20€ si >100)
    test('11) Descompte 2 (20€) sobre 120 => 20.0', () {
      final d = calculaDescompte(120.0, 2);
      expect(d, closeTo(20.0, 0.0001));
    });

    test('12) Descompte 2 (20€) sobre 100 => 0.0 (no supera 100)', () {
      final d = calculaDescompte(100.0, 2);
      expect(d, closeTo(0.0, 0.0001));
    });

    // 6) Tests de preuDefinitiu (combina funcions)
    test('13) preuDefinitiu(0,S,0) => 0', () {
      final preu = preuDefinitiu(0, 'S', 0);
      expect(preu, 0.0);
    });

    test('14) preuDefinitiu(10,S,1) => 79.9 - 10% = 71.91', () {
      final preu = preuDefinitiu(10, 'S', 1);
      expect(preu, closeTo(71.91, 0.0001));
    });

    test('15) preuDefinitiu(10,S,2) => 79.9 (no arriba a 100) => sense descompte => 79.9', () {
      final preu = preuDefinitiu(10, 'S', 2);
      expect(preu, closeTo(79.9, 0.0001));
    });

    test('16) preuDefinitiu(20,S,2) => 20*7.99=159.8 => -20 => 139.8', () {
      final preu = preuDefinitiu(20, 'S', 2);
      expect(preu, closeTo(139.8, 0.0001));
    });

    // 7) Nova funcionalitat: Talla XL (15.99)
    test('17) Talla XL, 2 samarretes => 31.98', () {
      final preu = calculaPreuSamarretes(2, 'XL');
      expect(preu, closeTo(31.98, 0.0001));
    });

    // 8) customPrint = true (+3.0 per samarreta)
    test('18) Talla S amb customPrint, 1 samarreta => 7.99+3=10.99', () {
      final preu = calculaPreuSamarretes(1, 'S', customPrint: true);
      expect(preu, closeTo(10.99, 0.0001));
    });

    test('19) Talla L amb customPrint, 2 samarretes => 2*(13.50+3)= 33.0', () {
      final preu = calculaPreuSamarretes(2, 'L', customPrint: true);
      // 13.50 + 3 = 16.50 x 2 = 33.0
      expect(preu, closeTo(33.0, 0.0001));
    });

    // 9) descompte tipus 3 = 50% si > 300
    test('20) Descompte 3 (50%) sobre 400 => 200 (excedeix 300)', () {
      final d = calculaDescompte(400.0, 3);
      expect(d, closeTo(200.0, 0.0001));
    });

    test('21) Descompte 3 (50%) sobre 250 => 0 (no excedeix 300)', () {
      final d = calculaDescompte(250.0, 3);
      expect(d, closeTo(0.0, 0.0001));
    });

    // 10) preuDefinitiu amb customPrint + descompte tipus 3
    test('22) preuDefinitiu(25, XL, 3, customPrint) => comprova >300 i aplicació 50%', () {
      // Talla XL = 15.99. Amb customPrint -> 15.99+3=18.99
      // 25 samarretes x 18.99 = 474.75
      // supera 300 => 50% => descompte = 237.375 => preu final = 237.375
      final preu = preuDefinitiu(25, 'XL', 3, customPrint: true);
      expect(preu, closeTo(237.375, 0.0001));
    });

    // 11) tests addicionals per decimals o text en el input (exemple)
    test('23) Input "4.5" => llança FormatException si fem int.parse("4.5")', () {
      expect(
            () {
          int numSamarretes = int.parse('4.5');
          return calculaPreuSamarretes(numSamarretes, 'S');
        },
        throwsFormatException,
      );
    });

    test('24) Input "abc" => llança FormatException si fem int.parse("abc")', () {
      expect(
            () {
          int numSamarretes = int.parse('abc');
          return calculaPreuSamarretes(numSamarretes, 'S');
        },
        throwsFormatException,
      );
    });

    // 12) preuDefinitiu combinat: 30 samarretes L, customPrint, sense descompte
    test('25) preuDefinitiu(30, L, 0, customPrint:true)', () {
      // L = 13.50 + 3.0 => 16.50 unitari
      // 30 x 16.50 = 495.0
      // sense descompte => 495.0
      final preu = preuDefinitiu(30, 'L', 0, customPrint: true);
      expect(preu, closeTo(495.0, 0.0001));
    });
  });
}

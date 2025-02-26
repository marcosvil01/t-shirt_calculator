import 'package:flutter_test/flutter_test.dart';
import 'package:tshirt_calculator/calculations.dart';

void main() {
  group('Proves unitàries de càlcul de samarretes (22 tests)', () {
    //
    // 1) 3 tests bàsics de calculaPreuSamarretes amb 0 samarretes
    //
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

    //
    // 2) Casos “estranys” (talla invàlida o nº samarretes negatiu)
    //
    test('4) Talla invàlida => ArgumentError', () {
      expect(() => calculaPreuSamarretes(5, 'XL'), throwsArgumentError);
    });

    test('5) Nombre de samarretes negatiu => ArgumentError', () {
      expect(() => calculaPreuSamarretes(-1, 'S'), throwsArgumentError);
    });

    //
    // 3) Alguns càlculs normals de preus
    //
    test('6) Talla S, 10 samarretes => 79.90', () {
      final preu = calculaPreuSamarretes(10, 'S');
      expect(preu, closeTo(79.9, 0.0001));
    });

    test('7) Talla M, 10 samarretes => 99.50', () {
      final preu = calculaPreuSamarretes(10, 'M');
      expect(preu, closeTo(99.5, 0.0001));
    });

    test('8) Talla L, 10 samarretes => 135.00', () {
      final preu = calculaPreuSamarretes(10, 'L');
      expect(preu, closeTo(135.0, 0.0001));
    });

    //
    // 4) Tests de calculaDescompte() - descompte tipus 1 (10%)
    //
    test('9) Descompte 1 (10%) sobre 100.00 => 10.00', () {
      final d = calculaDescompte(100.0, 1);
      expect(d, closeTo(10.0, 0.0001));
    });

    test('10) Descompte 1 (10%) sobre 99.00 => 9.90', () {
      final d = calculaDescompte(99.0, 1);
      expect(d, closeTo(9.9, 0.0001));
    });

    test('11) Descompte 1 (10%) sobre 0.00 => 0.00', () {
      final d = calculaDescompte(0.0, 1);
      expect(d, 0.0);
    });

    //
    // 5) Tests de calculaDescompte() - descompte tipus 2 (20€ si >100)
    //
    test('12) Descompte 2 (20€) sobre 120 => 20', () {
      final d = calculaDescompte(120.0, 2);
      expect(d, closeTo(20.0, 0.0001));
    });

    test('13) Descompte 2 (20€) sobre 100 => 0', () {
      final d = calculaDescompte(100.0, 2);
      expect(d, closeTo(0.0, 0.0001));
    });

    test('14) Descompte 2 (20€) sobre 101 => 20', () {
      final d = calculaDescompte(101.0, 2);
      expect(d, closeTo(20.0, 0.0001));
    });

    test('15) Descompte 2 (20€) sobre 80 => 0', () {
      final d = calculaDescompte(80.0, 2);
      expect(d, closeTo(0.0, 0.0001));
    });

    //
    // 6) Tests de preuDefinitiu() - combinem les funcions
    //
    test('16) preuDefinitiu(0,S,0) => 0', () {
      final preu = preuDefinitiu(0, 'S', 0);
      expect(preu, 0.0);
    });

    test('17) preuDefinitiu(10,S,1) => 10*S - 10%', () {
      // 10 * 7.99 = 79.90 => descompte 10% = 7.99 => total 71.91
      final preu = preuDefinitiu(10, 'S', 1);
      expect(preu, closeTo(71.91, 0.0001));
    });

    test('18) preuDefinitiu(10,S,2) => sense descompte (79.90) perquè no supera 100€', () {
      // 10 * 7.99 = 79.90 => no supera 100 => descompte 0 => total 79.90
      final preu = preuDefinitiu(10, 'S', 2);
      expect(preu, closeTo(79.90, 0.0001));
    });

    test('19) preuDefinitiu(20,S,2) => sí supera 100€ => 20€ menys', () {
      // 20 * 7.99 = 159.8 => 159.8 > 100 => 159.8 - 20 = 139.8
      final preu = preuDefinitiu(20, 'S', 2);
      expect(preu, closeTo(139.8, 0.0001));
    });

    test('20) preuDefinitiu(5,L,1) => 5x13.50=67.50 => descompte 10%=6.75 => total 60.75', () {
      // 5 * 13.50 = 67.50 => 10% = 6.75 => total 60.75
      final preu = preuDefinitiu(5, 'L', 1);
      expect(preu, closeTo(60.75, 0.0001));
    });

    //
    // 7) Afegim 2 tests més per decimals i text al "numero"
    //    (Simulem què passa si es parseja un input de l'usuari).
    //
    test('21) Input "4.5" => es llança FormatException a la conversió a int', () {
      // Simulem que l'usuari escriu "4.5" i nosaltres fem: int.parse("4.5")
      // Això llença FormatException, ja que no és un enter sencer.
      expect(
            () {
          int numSamarretes = int.parse('4.5');
          return calculaPreuSamarretes(numSamarretes, 'S');
        },
        throwsFormatException,
      );
    });

    test('22) Input "hola" => es llança FormatException a la conversió a int', () {
      // Simulem que l'usuari escriu "hola" i fem: int.parse("hola")
      // Llença FormatException, ja que no pot convertir text a enter.
      expect(
            () {
          int numSamarretes = int.parse('hola');
          return calculaPreuSamarretes(numSamarretes, 'S');
        },
        throwsFormatException,
      );
    });
  });
}

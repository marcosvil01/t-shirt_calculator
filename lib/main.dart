import 'package:flutter/material.dart';
import 'calculations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-shirt Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TshirtCalculatorPage(),
    );
  }
}

class TshirtCalculatorPage extends StatefulWidget {
  const TshirtCalculatorPage({super.key});

  @override
  State<TshirtCalculatorPage> createState() => _TshirtCalculatorPageState();
}

class _TshirtCalculatorPageState extends State<TshirtCalculatorPage> {
  final TextEditingController _numController = TextEditingController();

  // Talla seleccionada: S, M, L, XL
  String? _selectedSize;

  // Tipus de descompte (0,1,2,3)
  int _discountType = 0;

  // Si l’usuari vol estampat personalitzat
  bool _customPrint = false;

  double? _calculatedPrice;

  @override
  void initState() {
    super.initState();
    _numController.addListener(_updatePrice);
  }

  @override
  void dispose() {
    _numController.dispose();
    super.dispose();
  }

  void _updatePrice() {
    setState(() {
      _calculatedPrice = _computePrice();
    });
  }

  double? _computePrice() {
    if (_selectedSize == null) return null;
    if (_numController.text.isEmpty) return null;

    // Intentem parsejar el text a int
    final int? numShirts = int.tryParse(_numController.text);
    if (numShirts == null || numShirts < 0) {
      // si és null o negatiu, tornem null per indicar que no és un valor vàlid
      return null;
    }

    return preuDefinitiu(
      numShirts,
      _selectedSize!,
      _discountType,
      customPrint: _customPrint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double? currentPrice = _computePrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField per al nombre de samarretes
            TextField(
              controller: _numController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nombre de samarretes',
              ),
            ),
            const SizedBox(height: 16),

            // RadioButtons per a talla (S, M, L, XL)
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Small (7.99€)'),
                    value: 'S',
                    groupValue: _selectedSize,
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Medium (9.95€)'),
                    value: 'M',
                    groupValue: _selectedSize,
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Large (13.50€)'),
                    value: 'L',
                    groupValue: _selectedSize,
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('X-Large (15.99€)'),
                    value: 'XL',
                    groupValue: _selectedSize,
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Switch per al customPrint
            SwitchListTile(
              title: const Text('Estampat personalitzat (+3€ / samarreta)'),
              value: _customPrint,
              onChanged: (val) {
                setState(() {
                  _customPrint = val;
                });
              },
            ),

            const SizedBox(height: 16),

            // Dropdown per al tipus de descompte
            DropdownButton<int>(
              value: _discountType,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Cap descompte (0)')),
                DropdownMenuItem(value: 1, child: Text('Descompte 10% (1)')),
                DropdownMenuItem(value: 2, child: Text('20€ si > 100 (2)')),
                DropdownMenuItem(value: 3, child: Text('50% si > 300 (3)')),
              ],
              onChanged: (newValue) {
                setState(() {
                  _discountType = newValue ?? 0;
                });
              },
            ),

            const SizedBox(height: 16),

            // Mostrem el preu
            if (currentPrice != null)
              Text(
                'Preu total: ${currentPrice.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const Text(
                'Introdueix dades vàlides per calcular el preu',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'calculations.dart'; // Importem les funcions de càlcul

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-shirt Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
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

  // Opcions de talla, representem internament com 'S', 'M', 'L'
  String? _selectedSize;

  // Opcions de descompte, representem tipusDescompte = 0,1,2 per a la lògica
  int _discountType = 0;

  // Per recalcular en temps real
  double? _calculatedPrice;

  // Escoltem canvis al TextField
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

    final int? numShirts = int.tryParse(_numController.text);
    if (numShirts == null || numShirts <= 0) return null;

    // Fem servir la nostra funció de càlcul final:
    return preuDefinitiu(numShirts, _selectedSize!, _discountType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Calculator'),
      ),
      body: Padding(
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

            // RadioButtons per a talla
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
                        _calculatedPrice = _computePrice();
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
                        _calculatedPrice = _computePrice();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Large (13.50€)'),
                    value: 'L',
                    groupValue: _selectedSize,
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                        _calculatedPrice = _computePrice();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown per seleccionar el tipus de descompte
            DropdownButton<int>(
              value: _discountType,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Cap descompte')),
                DropdownMenuItem(value: 1, child: Text('Descompte 10%')),
                DropdownMenuItem(value: 2, child: Text('20€ si > 100€')),
              ],
              onChanged: (newValue) {
                setState(() {
                  _discountType = newValue ?? 0;
                  _calculatedPrice = _computePrice();
                });
              },
            ),

            const SizedBox(height: 16),

            // Mostrem el preu només si ja el podem calcular
            if (_calculatedPrice != null)
              Text(
                'Preu total: ${_calculatedPrice!.toStringAsFixed(2)}€',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

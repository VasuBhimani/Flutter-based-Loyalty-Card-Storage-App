import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/models/card_model.dart';
import '../bloc/cards_bloc.dart';

class AddCardPage extends StatefulWidget {
  final CardModel? cardToEdit;
  const AddCardPage({Key? key, this.cardToEdit}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _cardNumberController;
  late TextEditingController _issuerController;
  DateTime? _expirationDate;
  String? _barcode;
  String? _qrCode;
  String? _logoUrl;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    final card = widget.cardToEdit;
    _nameController = TextEditingController(text: card?.name ?? '');
    _cardNumberController = TextEditingController(text: card?.cardNumber ?? '');
    _issuerController = TextEditingController(text: card?.issuer ?? '');
    _expirationDate = card?.expirationDate;
    _barcode = card?.barcode;
    _qrCode = card?.qrCode;
    _logoUrl = card?.logoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoUrl = pickedFile.path;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final card = CardModel(
        id: widget.cardToEdit?.id,
        name: _nameController.text,
        cardNumber: _cardNumberController.text,
        issuer: _issuerController.text,
        expirationDate: _expirationDate,
        barcode: _barcode,
        qrCode: _qrCode,
        logoUrl: _logoUrl,
      );
      if (widget.cardToEdit != null) {
        context.read<CardsBloc>().add(UpdateCard(card));
      } else {
        context.read<CardsBloc>().add(AddCard(card));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_logoUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_logoUrl!),
                )
              else
                CircleAvatar(
                  radius: 50,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: _pickImage,
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Card Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: 'Issuer',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _expirationDate != null
                      ? 'Expiration Date: ${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                      : 'Select Expiration Date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    setState(() {
                      _expirationDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              if (_isScanning)
                SizedBox(
                  height: 200,
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        setState(() {
                          _barcode = barcode.rawValue;
                          _isScanning = false;
                        });
                      }
                    },
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isScanning = true;
                    });
                  },
                  child: const Text('Scan Barcode'),
                ),
              const SizedBox(height: 16),
              if (_barcode != null)
                Column(
                  children: [
                    const Text('Scanned Barcode:'),
                    Text(_barcode!),
                    const SizedBox(height: 16),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../domain/models/card_model.dart';
import '../bloc/cards_bloc.dart';
import '../pages/add_card_page.dart';

class CardDetailsPage extends StatelessWidget {
  final String cardId;

  const CardDetailsPage({
    Key? key,
    required this.cardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsBloc, CardsState>(
      builder: (context, state) {
        if (state is CardsLoaded) {
          final card = state.cards.firstWhere(
            (c) => c.id == cardId,
            orElse: () => throw Exception('Card not found'),
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(card.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCardPage(cardToEdit: card),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (card.logoUrl != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(card.logoUrl!),
                    )
                  else
                    CircleAvatar(
                      radius: 50,
                      child: Text(card.name[0].toUpperCase()),
                    ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Number',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card.cardNumber,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          if (card.issuer != null) ...[
                            Text(
                              'Issuer',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              card.issuer!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (card.expirationDate != null) ...[
                            Text(
                              'Expiration Date',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${card.expirationDate!.day}/${card.expirationDate!.month}/${card.expirationDate!.year}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (card.barcode != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Barcode',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: card.barcode!,
                              width: double.infinity,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (card.qrCode != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR Code',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: QrImageView(
                                data: card.qrCode!,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.qr_code),
                    label: Text('Generate QR Code'),
                    onPressed: () {
                      final qrData = card.cardNumber.isNotEmpty
                          ? card.cardNumber
                          : card.id;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Card QR Code'),
                          content: StatefulBuilder(
                            builder: (context, setState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 150.0,
                                ),
                                const SizedBox(height: 16),
                                Text('Card Number: $qrData'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

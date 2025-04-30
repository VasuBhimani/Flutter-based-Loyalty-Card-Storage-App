import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/models/card_model.dart';
import '../bloc/cards_bloc.dart';
import './add_card_page.dart';
import './card_details_page.dart';

class CardsListPage extends StatelessWidget {
  const CardsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCardPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CardsBloc, CardsState>(
        builder: (context, state) {
          if (state is CardsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CardsError) {
            return Center(child: Text(state.message));
          }

          if (state is CardsLoaded) {
            final cards = state.cards;
            if (cards.isEmpty) {
              return const Center(
                child: Text('No cards added yet. Tap + to add a new card.'),
              );
            }

            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            context.read<CardsBloc>().add(DeleteCard(card.id));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: card.logoUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(card.logoUrl!),
                            )
                          : CircleAvatar(
                              child: Text(card.name[0].toUpperCase()),
                            ),
                      title: Text(card.name),
                      subtitle: Text(card.issuer ?? ''),
                      trailing: card.expirationDate != null
                          ? Text(
                              'Expires: ${card.expirationDate!.day}/${card.expirationDate!.month}/${card.expirationDate!.year}')
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CardDetailsPage(cardId: card.id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}

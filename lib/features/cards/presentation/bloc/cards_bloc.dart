import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/card_model.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/notification_service.dart';

// Events
abstract class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCards extends CardsEvent {}

class AddCard extends CardsEvent {
  final CardModel card;

  const AddCard(this.card);

  @override
  List<Object?> get props => [card];
}

class UpdateCard extends CardsEvent {
  final CardModel card;

  const UpdateCard(this.card);

  @override
  List<Object?> get props => [card];
}

class DeleteCard extends CardsEvent {
  final String cardId;

  const DeleteCard(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

// States
abstract class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object?> get props => [];
}

class CardsInitial extends CardsState {}

class CardsLoading extends CardsState {}

class CardsLoaded extends CardsState {
  final List<CardModel> cards;

  const CardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class CardsError extends CardsState {
  final String message;

  const CardsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final LocalStorageService localStorageService;
  final NotificationService notificationService;
  final List<CardModel> _cards = [];

  CardsBloc({
    required this.localStorageService,
    required this.notificationService,
  }) : super(CardsInitial()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<UpdateCard>(_onUpdateCard);
    on<DeleteCard>(_onDeleteCard);
  }

  Future<void> _onLoadCards(LoadCards event, Emitter<CardsState> emit) async {
    try {
      emit(CardsLoading());
      final cardIds = await localStorageService.getAllCardIds();
      _cards.clear();

      for (final cardId in cardIds) {
        final cardData = await localStorageService.getCard(cardId);
        if (cardData != null) {
          _cards.add(CardModel.fromJson(cardData));
        }
      }

      emit(CardsLoaded(List.from(_cards)));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> _onAddCard(AddCard event, Emitter<CardsState> emit) async {
    try {
      emit(CardsLoading());
      await localStorageService.saveCard(event.card.id, event.card.toJson());
      _cards.add(event.card);

      // Schedule expiration notification if card has expiration date
      if (event.card.expirationDate != null) {
        await notificationService.scheduleExpirationNotification(
          cardId: event.card.id,
          cardName: event.card.name,
          expirationDate: event.card.expirationDate!,
        );
      }

      emit(CardsLoaded(List.from(_cards)));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> _onUpdateCard(UpdateCard event, Emitter<CardsState> emit) async {
    try {
      emit(CardsLoading());
      await localStorageService.saveCard(event.card.id, event.card.toJson());
      final index = _cards.indexWhere((card) => card.id == event.card.id);
      if (index != -1) {
        _cards[index] = event.card;
      }

      // Update expiration notification if card has expiration date
      if (event.card.expirationDate != null) {
        await notificationService.scheduleExpirationNotification(
          cardId: event.card.id,
          cardName: event.card.name,
          expirationDate: event.card.expirationDate!,
        );
      }

      emit(CardsLoaded(List.from(_cards)));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> _onDeleteCard(DeleteCard event, Emitter<CardsState> emit) async {
    try {
      emit(CardsLoading());
      await localStorageService.deleteCard(event.cardId);
      _cards.removeWhere((card) => card.id == event.cardId);

      // Cancel any scheduled notifications for this card
      await notificationService.cancelNotification(event.cardId.hashCode);
      await notificationService.cancelNotification(event.cardId.hashCode + 1);

      emit(CardsLoaded(List.from(_cards)));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }
}

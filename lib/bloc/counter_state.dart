import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int value;

  const CounterState({required this.value});

  // Initial state
  const CounterState.initial() : value = 0;

  @override
  List<Object> get props => [value];
} 
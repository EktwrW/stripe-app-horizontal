part of 'metodo_de_pago_bloc.dart';

@immutable
class MetodoDePagoState {
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;

  String get montoPagarString => '${(this.montoPagar * 100).floor()}';

  MetodoDePagoState({
    this.montoPagar = 350.12,
    this.moneda = 'USD',
    this.tarjetaActiva = false,
    this.tarjeta,
  });

  MetodoDePagoState copyWith({
    double montoPagar,
    String moneda,
    bool tarjetaActiva,
    TarjetaCredito tarjeta,
  }) =>
      MetodoDePagoState(
          montoPagar: montoPagar ?? this.montoPagar,
          moneda: moneda ?? this.moneda,
          tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
          tarjeta: tarjeta ?? this.tarjeta);
}

//class MetodoDePagoInitial extends MetodoDePagoState {}

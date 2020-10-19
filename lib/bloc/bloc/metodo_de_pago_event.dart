part of 'metodo_de_pago_bloc.dart';

@immutable
abstract class MetodoDePagoEvent {}

class OnSeleccionarTarjeta extends MetodoDePagoEvent {
  final TarjetaCredito tarjeta;

  OnSeleccionarTarjeta(this.tarjeta);
}

class OnDesactivarTarjeta extends MetodoDePagoEvent {}

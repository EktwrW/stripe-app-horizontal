import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/models/tarjeta_credito.dart';

part 'metodo_de_pago_event.dart';
part 'metodo_de_pago_state.dart';

class MetodoDePagoBloc extends Bloc<MetodoDePagoEvent, MetodoDePagoState> {
  MetodoDePagoBloc() : super(MetodoDePagoState());

  @override
  Stream<MetodoDePagoState> mapEventToState(
    MetodoDePagoEvent event,
  ) async* {
    if (event is OnSeleccionarTarjeta) {
      yield state.copyWith(tarjetaActiva: true, tarjeta: event.tarjeta);
    } else if (event is OnDesactivarTarjeta) {
      yield state.copyWith(tarjetaActiva: false);
    }
  }
}

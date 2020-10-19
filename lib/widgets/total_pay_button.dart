import 'dart:io';

//import 'package:credit_card_slider/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/bloc/metodo_de_pago_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/constants.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final pagarBloc = context.bloc<MetodoDePagoBloc>().state;

    return Container(
      width: width,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total', style: kDarkTitleStyle),
              Text('${pagarBloc.montoPagar} ${pagarBloc.moneda}',
                  style: kSubtitleStyle)
            ],
          ),
          BlocBuilder<MetodoDePagoBloc, MetodoDePagoState>(
            builder: (context, state) {
              return _BtnPay(state);
            },
          )
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final MetodoDePagoState state;

  const _BtnPay(this.state);

  @override
  Widget build(BuildContext context) {
    //iniciamos el build context retornando el estado tarjeta activa y muestra
    //la opcion boton de pago con tarjeta, caso contrario, muestra boton de
    //pago nativo google o apple pay.
    return state.tarjetaActiva
        ? buildBotonTarjeta(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildBotonTarjeta(BuildContext context) {
    return MaterialButton(
        height: 45,
        minWidth: 170,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(FontAwesomeIcons.solidCreditCard, color: Colors.white),
            Text('  Pagar', style: kTitleStyle),
          ],
        ),
        onPressed: () async {
          mostrarLoading(context);
          final stripeService = new StripeService();
          final state = context.bloc<MetodoDePagoBloc>().state;
          final tarjeta = state.tarjeta;
          final mesAnio = tarjeta.expiracyDate.split('/');

          final resp = await stripeService.pagarConTarjetaExistente(
            amount: state.montoPagarString,
            currency: state.moneda,
            card: CreditCard(
              number: tarjeta.cardNumber,
              expMonth: int.parse(mesAnio[0]),
              expYear: int.parse(mesAnio[1]),
            ),
          );

          Navigator.pop(context);

          if (resp.ok) {
            mostrarAlerta(context, 'Tarjeta OK', 'Todo Correcto');
          } else {
            //print(resp.msg);
            mostrarAlerta(context, 'Ups! Algo salió mal', resp.msg);
          }
        });
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
        height: 45,
        minWidth: 150,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(
                Platform.isAndroid
                    ? FontAwesomeIcons.google
                    : FontAwesomeIcons.apple,
                color: Colors.white),
            Text(' Pay', style: TextStyle(color: Colors.white, fontSize: 22)),
          ],
        ),
        onPressed: () async {
          mostrarLoading(context);
          final stripeService = new StripeService();
          final state = context.bloc<MetodoDePagoBloc>().state;

          final resp = await stripeService.pagarConGooglePayApplePay(
            amount: state.montoPagarString,
            currency: state.moneda,
          );

          Navigator.pop(context);

          if (resp.ok) {
            mostrarAlerta(context, 'Aprobado', 'Pago Exitoso');
          } else {
            mostrarAlerta(context, 'Ups! Algo salió mal', resp.msg);
          }
        });
  }
}

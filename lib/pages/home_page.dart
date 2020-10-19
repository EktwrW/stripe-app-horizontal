import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/bloc/metodo_de_pago_bloc.dart';

import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/constants.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  final stripeService = new StripeService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ignore: close_sinks
    final metodoDePAgoBloc = context.bloc<MetodoDePagoBloc>();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pagar',
            style: kTitleStyle,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  mostrarLoading(context);
                  // mostrarLoading(context);
                  // await Future.delayed(Duration(seconds: 1));
                  // Navigator.pop(context);
                  //mostrarAlerta(context, 'Hola', 'Mundo');

                  final amount = metodoDePAgoBloc.state.montoPagarString;
                  final currency = metodoDePAgoBloc.state.moneda;

                  final resp = await this.stripeService.pagarConTarjetaNueva(
                        amount: amount,
                        currency: currency,
                      );

                  Navigator.pop(context);

                  if (resp.ok) {
                    mostrarAlerta(context, 'Tarjeta OK', 'Todo Correcto');
                  } else {
                    mostrarAlerta(context, 'Ups! Algo salió mal', resp.msg);
                  }
                })
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: 200,
              child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  physics: BouncingScrollPhysics(),
                  itemCount: tarjetas.length,
                  itemBuilder: (_, i) {
                    final tarjeta = tarjetas[i];

                    return GestureDetector(
                      onTap: () {
                        context
                            .bloc<MetodoDePagoBloc>()
                            .add(OnSeleccionarTarjeta(tarjeta));
                        Navigator.push(
                            context, navegarFadeIn(context, TarjetaPage()));
                      },
                      child: Hero(
                        tag: tarjeta.cardNumber,
                        child: CreditCardWidget(
                          cardNumber: tarjeta.cardNumberHidden,
                          expiryDate: tarjeta.expiracyDate,
                          cardHolderName: tarjeta.cardHolderName,
                          cvvCode: tarjeta.cvv,
                          showBackView: false,
                          cardBgColor: Colors.indigo,
                        ),
                      ),
                    );
                  }),
            ),
            Positioned(bottom: 0, child: TotalPayButton())
          ],
        ));
  }
}

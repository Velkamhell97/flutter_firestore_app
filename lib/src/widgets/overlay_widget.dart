import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({Key? key}) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  final ValueNotifier<bool> _dialogNotifier = ValueNotifier(false);

  void _showDialog() {
    _dialogNotifier.value = true;

    Future.delayed(const Duration(seconds: 5), () {
      _dialogNotifier.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Aqui se ve la utilidad de listener del bloc
    return Consumer<ConnectionProvider>(
      builder: (_, connection, __) {
        if(!connection.online) _showDialog();

        return Positioned.fill(
          top: 30,
          bottom: null,
          left: 30,
          right: 30,
          child: ValueListenableBuilder<bool>(
            valueListenable: _dialogNotifier,
            builder: (_, value, __) => _OverlayDialog(show: value),
          ),
        );
      },
    );
  }
}

class _OverlayDialog extends StatelessWidget {
  final bool show;

  const _OverlayDialog({Key? key, required this.show}) : super(key: key);

  static const _animationDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    /// Tambien se hubiera hecho lo mismo que el selector
    // final isLoged = FirebaseAuth.instance.currentUser != null;

    return AnimatedSwitcher(
      duration: _animationDuration,
      
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.0, -2.0), end: const Offset(0, 0)).animate(animation),
            child: child,
          ),
        );
      },
      
      child: show ? Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10.0),
        child: Selector<ConnectionProvider, String>(
          selector: (_, model) => model.route,
          builder: (_, route, __) {
            final isLoged = route == 'app';

            return ListTile(
              horizontalTitleGap: 0,
              isThreeLine: true,
              leading: SizedBox( //-Para centrarlo
                // height: double.infinity,
                child: Icon(!isLoged ? Icons.wifi_off : Icons.edit)
              ),
              title: const Text('No estas conectado a la red'),
              subtitle: Text(!isLoged 
                ? 'Puede que algunas funciones no esten disponibles'
                : 'Los elementos se guardaran locales hasta cuando te conectes de nuevo'
              ),
            );
          },
        )
      ) : const SizedBox.shrink(),
    );
  }
}
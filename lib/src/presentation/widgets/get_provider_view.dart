import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

abstract class GetProviderView<T> extends StatelessWidget {
  const GetProviderView({super.key});

  /// context.read<T>();
  T notifier(BuildContext context) => context.read<T>();

  P notifier2<P>(BuildContext context) => context.read<P>();

  /// context.watch<T>();
  T listener(BuildContext context) => context.watch<T>();

  P listener2<P>(BuildContext context) => context.watch<P>();

  @override
  Widget build(BuildContext context);
}

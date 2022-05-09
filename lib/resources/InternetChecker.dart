
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:spendzz/resources/Block_Unblock_provider.dart';
import 'ConnectivityProvider.dart';

List<SingleChildWidget> provider = [
  ChangeNotifierProvider(
    create: (_) => ConnectivityProvider(),
  ),
  ChangeNotifierProvider(create: (_)=>Block_UnblockUser())
];
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Entrypoint del aplicativo. Inicializa Supabase y arranca la app.
Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();

	final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
	final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

	await Supabase.initialize(
		url: supabaseUrl,
		anonKey: supabaseAnonKey,
	);

	runApp(const ProviderScope(child: NexusCampusApp()));
}

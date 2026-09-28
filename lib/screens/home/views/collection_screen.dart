import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/screens/home/widgets/collection/collection_section.dart';

import '../blocs/get_cookie_bloc/get_cookie_bloc.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCookieBloc(FirebaseCookieRepo())..add(GetCookie()),
      child: const _CollectionView(),
    );
  }
}

class _CollectionView extends StatelessWidget {
  const _CollectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<GetCookieBloc, GetCookieState>(
              builder: (context, state) {
                if (state is GetCookieSuccess) {
                  if (state.cookies.isEmpty) {
                    return const Center(
                      child: Text('No cookies have been added yet.'),
                    );
                  }

                  return CollectionSection(cookies: state.cookies);
                }

                if (state is GetCookieFailure) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

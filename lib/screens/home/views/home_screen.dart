import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/blueberry-vanilla.png', width: 58, height: 58),
            const SizedBox(width: 8),
            const Text(
              'COOKIES',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.cart)),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_left_to_line),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () async {
            //       try {
            //         await SeedDatabase().addCookies();

            //         if (!context.mounted) return;

            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text('Cookies added successfully! 🍪'),
            //           ),
            //         );

            //         context.read<GetCookieBloc>().add(GetCookie());
            //       } catch (error) {
            //         if (!context.mounted) return;

            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Something went wrong: $error')),
            //         );
            //       }
            //     },
            //     child: const Text('Add cookies to Firebase'),
            //   ),
            // ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<GetCookieBloc, GetCookieState>(
                builder: (context, state) {
                  return switch (state) {
                    GetCookieSuccess() when state.cookies.isEmpty =>
                      const Center(
                        child: Text('No cookies have been added yet.'),
                      ),
                    GetCookieSuccess() => GridView.builder(
                      itemCount: state.cookies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.58,
                          ),
                      itemBuilder: (context, index) =>
                          _CookieCard(cookie: state.cookies[index]),
                    ),
                    GetCookieFailure() => _FailureView(message: state.message),
                    _ => const Center(child: CircularProgressIndicator()),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CookieCard extends StatelessWidget {
  const _CookieCard({required this.cookie});

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DetailsScreen(cookie: cookie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox.expand(
                  child: CookieImage(
                    picture: cookie.picture,
                    name: cookie.name,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // FRUITY + BALANCE
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _Badge(
                        label: cookie.isFru ? 'FRUITY' : 'CLASSIC',
                        color: Colors.deepPurpleAccent.shade700,
                      ),
                      const _Badge(
                        label: '🍇 BALANCE',
                        color: Color(0xFFB86A3C),
                        background: Color(0xFFF5E8E1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // COOKIE NAME
                  Text(
                    cookie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // DESCRIPTION
                  Text(
                    cookie.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // PRICE + ADD BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 5,
                          crossAxisAlignment:
                              WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${cookie.discount.toStringAsFixed(2)} €',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            ),

                            if (cookie.discount > 0)
                              Text(
                                '${cookie.price.toStringAsFixed(2)} €',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  decoration:
                                      TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),

                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          // We'll connect this to the cart later
                        },
                        icon: const Icon(
                          CupertinoIcons.add_circled_solid,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    this.background,
  });

  final String label;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<GetCookieBloc>().add(GetCookie());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

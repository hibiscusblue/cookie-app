import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
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
            Image.asset(
              'assets/blueberry-vanilla.png',
              width: 58,
              height: 58,
              fit: BoxFit.contain,
            ),
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
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (context, index) {
            return Material(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // COOKIE IMAGE
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/blueberry-vanilla.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                                
                    // COOKIE INFORMATION
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LABELS
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent.shade700,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'FRUITY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                                
                              const SizedBox(width: 8),
                                
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFEAD2C5,
                                  ).withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  '🫐 BALANCE',
                                  style: TextStyle(
                                    color: Color(0xFFB86A3C),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                                
                          const SizedBox(height: 8),
                                
                          // COOKIE NAME
                          const Text(
                            'Blueberry Vanilla',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                                
                          const SizedBox(height: 2),
                                
                          // COOKIE DESCRIPTION
                          Text(
                            'Your moment of bliss.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                                
                          const SizedBox(height: 4),
                                
                          // COOKIE PRICE
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '2.99 €',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '3.99 €',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(CupertinoIcons.add_circled_solid),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

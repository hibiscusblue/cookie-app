// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_application_1/app.dart';

class FakeUserRepository implements UserRepository {
  @override
  Stream<MyUser?> get user => Stream.value(MyUser.empty);

  @override
  Future<void> logOut() async {}

  @override
  Future<void> setUserData(MyUser user) async {}

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async => myUser;
}

void main() {
  testWidgets('shows the authentication screen', (WidgetTester tester) async {
    await tester.pumpWidget(NaimApp(FakeUserRepository()));
    await tester.pump();

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}

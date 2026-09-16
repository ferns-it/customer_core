import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/core/config/app_config.dart';
import 'package:customer_core/src/core/config/app_env.dart';
import 'package:customer_core/src/core/config/ui_config.dart';
import 'package:customer_core/src/core/constants/enums.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_pagination.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:customer_core/src/presentation/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

/// [LoginScreen] only reads a handful of members of `AuthProvider`. Only those
/// are implemented, so an unstubbed member shows up as a clear error instead of
/// silently returning a wrong value.
class _FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  _FakeAuthProvider({this.selectedAuthView = AuthView.login});

  @override
  final AuthView selectedAuthView;

  @override
  final loginFormKey = GlobalKey<FormState>();

  @override
  final resetFormKey = GlobalKey<FormBuilderState>();

  @override
  final changePasswordFormKey = GlobalKey<FormBuilderState>();

  @override
  final newPasswordFieldKey = GlobalKey<FormFieldState>();

  @override
  final loginUserNameController = TextEditingController();

  @override
  final loginUserPasswordController = TextEditingController();

  @override
  bool get loginPasswordHide => true;

  @override
  bool get loginLoading => false;

  @override
  bool get isRegisterMode => false;

  @override
  bool get resetPasswordHide => true;

  @override
  bool get resetLoading => false;

  @override
  bool get resetLoadingSecondary => false;

  @override
  int get currentForgotForm => 0;

  @override
  String get newPassword => '';

  @override
  void toggleLoginPassword() {}

  @override
  void toggleResetPassword() {}

  @override
  void updateCurrentForgotForm(int formNo) {}

  @override
  void onChangeSelectedAuthView(AuthView value) {}

  @override
  void clearValues({bool registerControllersOnly = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'AuthProvider.${invocation.memberName} is not used by this test');
}

/// `ShopProvider.setDefaultCountry()` (called from the screen's post frame
/// callback) returns early while no country was loaded, so none of these are
/// reached - they throw to make that explicit.
class _FakeStoreRepo implements IStoreRepo {
  @override
  Future<Either<AppExceptions, StoreSettingsDataModel>>
      getStoreSettings() async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ProductCategoryModel>> getCategories() async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ProductDetailsPagination>>
      getProductsByPagination({
    required String categoryID,
    required String numberOfProducts,
    required String pageNumber,
  }) async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'IStoreRepo.${invocation.memberName} is not used by this test');
}

const Size _phoneSize = Size(360, 800);

Future<void> _pumpLoginScreen(
  WidgetTester tester, {
  required AuthProvider authProvider,
  double keyboardInset = 0,
  Size viewSize = _phoneSize,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = viewSize;
  // The keyboard is reported through the view's bottom inset, which is exactly
  // what the framework sees while the real keyboard is on screen.
  tester.view.viewInsets = FakeViewPadding(bottom: keyboardInset);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider.value(value: ShopProvider(_FakeStoreRepo())),
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(value: ThemeProvider()),
      ],
      // The screen reads its text styles from a ThemeExtension that the real app
      // theme registers.
      child: MaterialApp(
        theme: ThemeData(extensions: [lightCustomTextStyle]),
        home: LoginScreen(),
      ),
    ),
  );

  // Unmounts the screen (and cancels its countdown timer) at the end of a test.
  addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
}

/// The logo of the auth screen.
Rect _logoRect(WidgetTester tester) => tester.getRect(find.byType(Image));

/// The glass auth card (the only blurred surface of the screen).
Rect _cardRect(WidgetTester tester) =>
    tester.getRect(find.byType(BackdropFilter));
void main() {
  setUpAll(() {
    AppConfig.instance = AppConfig(
      applicationName: 'Test App',
      shopName: 'Test Shop',
      shopId: 'test-shop',
      shopIdentifier: 'test-shop',
      shopInfoEmail: 'test@example.com',
      shopInfoPhone: const ['0000000000'],
      shopInfoAddress: 'Test Address',
      buildIdentifier: 'test',
      country: Country.values.first,
      fireBaseProjectId: 'test',
      env: AppEnv.dev,
      isCategoryImageEnabled: false,
    );
    // Assets of this package, as referenced by the generated `Assets` class.
    UiConfig.instance = UiConfig(
      logo: 'lib/assets/images/app_logo_01.png',
      logoWithoutBackground: 'lib/assets/images/app_logo_01.png',
      bgImage: 'lib/assets/images/app_logo_01.png',
      bannerImages: const [],
    );
  });
  testWidgets(
      'the logo keeps the same position when the shorter forgot-password form '
      'replaces the login form', (tester) async {
    await _pumpLoginScreen(tester, authProvider: _FakeAuthProvider());
    expect(tester.takeException(), isNull);
    final Rect loginLogo = _logoRect(tester);
    expect(loginLogo.height, greaterThan(0.0));

    // Same screen, but showing the (much shorter) forgot-password form. The logo
    // used to move down here, because the content was vertically centred.
    await _pumpLoginScreen(
      tester,
      authProvider: _FakeAuthProvider(
        selectedAuthView: AuthView.forgotPassword,
      ),
    );
    expect(tester.takeException(), isNull);
    final Rect forgotLogo = _logoRect(tester);

    expect(forgotLogo.top, moreOrLessEquals(loginLogo.top, epsilon: 0.01));
    expect(
        forgotLogo.height, moreOrLessEquals(loginLogo.height, epsilon: 0.01));
  });

  testWidgets(
      'the logo and the card keep their size and position when the keyboard '
      'opens', (tester) async {
    await _pumpLoginScreen(tester, authProvider: _FakeAuthProvider());
    expect(tester.takeException(), isNull);
    final Rect logo = _logoRect(tester);
    final Rect card = _cardRect(tester);

    // Keyboard appears.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    await tester.pump();

    // Regression guard: the screen used to scale the whole layout down and
    // re-centre it (FittedBox) as soon as the keyboard was open.
    expect(_logoRect(tester), logo);
    expect(_cardRect(tester), card);
  });

  testWidgets('the password field stays above the keyboard once it is focused',
      (tester) async {
    const double keyboardInset = 320;
    // Short screen, so the field really is behind the keyboard.
    await _pumpLoginScreen(
      tester,
      authProvider: _FakeAuthProvider(),
      keyboardInset: keyboardInset,
      viewSize: const Size(360, 640),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(TextFormField).last);
    await tester.pumpAndSettle();

    final Rect field = tester.getRect(find.byType(TextFormField).last);
    expect(field.top, greaterThanOrEqualTo(0.0));
    expect(field.bottom, lessThanOrEqualTo(640 - keyboardInset));
  });
}

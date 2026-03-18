import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/utils/validators.dart';
import 'package:jobi/core/widgets/app_text_field.dart';
import 'package:jobi/core/widgets/primary_button.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@jobi.kz');
  final _passwordController = TextEditingController(text: 'jobi123');
  final _phoneController = TextEditingController(text: '+7 701 111 22 33');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.status != current.status || previous.message != current.message,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/home');
          } else if (state.status == AuthStatus.otpSent &&
              state.pendingPhone != null) {
            context.go(
              '/auth/otp?phone=${Uri.encodeComponent(state.pendingPhone!)}',
            );
          } else if (state.status == AuthStatus.failure && state.message != null) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.text('signInTitle')),
            bottom: TabBar(
              tabs: [
                Tab(text: l10n.text('emailTab')),
                Tab(text: l10n.text('phoneOtpTab')),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        Form(
                          key: _emailFormKey,
                          child: ListView(
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                l10n.text('signInEmailHint'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 24),
                              AppTextField(
                                controller: _emailController,
                                label: l10n.text('email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _passwordController,
                                label: l10n.text('password'),
                                obscureText: true,
                                validator: Validators.password,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.text('forgotPasswordPlaceholder'),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(l10n.text('forgotPassword')),
                                ),
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return PrimaryButton(
                                    label: l10n.text('signIn'),
                                    isLoading:
                                        state.status == AuthStatus.authenticating,
                                    onPressed: () {
                                      if (_emailFormKey.currentState!.validate()) {
                                        context.read<AuthCubit>().signInWithEmail(
                                              email: _emailController.text.trim(),
                                              password: _passwordController.text.trim(),
                                            );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _phoneFormKey,
                          child: ListView(
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                l10n.text('signInPhoneHint'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 24),
                              AppTextField(
                                controller: _phoneController,
                                label: l10n.text('phoneNumber'),
                                keyboardType: TextInputType.phone,
                                validator: Validators.phone,
                              ),
                              const SizedBox(height: 24),
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return PrimaryButton(
                                    label: l10n.text('sendOtpCode'),
                                    isLoading:
                                        state.status == AuthStatus.authenticating,
                                    onPressed: () {
                                      if (_phoneFormKey.currentState!.validate()) {
                                        context
                                            .read<AuthCubit>()
                                            .sendOtp(_phoneController.text.trim());
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(l10n.text('demoOtpHint')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.read<AuthCubit>().signInWithGooglePlaceholder(),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(l10n.text('googlePlaceholder')),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/auth/sign-up'),
                    child: Text(l10n.text('needAccountSignUp')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

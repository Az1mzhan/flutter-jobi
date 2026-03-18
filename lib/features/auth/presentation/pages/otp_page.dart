import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/widgets/app_text_field.dart';
import 'package:jobi/core/widgets/primary_button.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phone});

  final String phone;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.message != current.message,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        } else if (state.status == AuthStatus.failure && state.message != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.text('verifyOtpTitle'))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    l10n.format('otpHint', {'phone': widget.phone}),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.text('demoOtpHint')),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _otpController,
                    label: l10n.text('verificationCode'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if ((value ?? '').trim().length != 6) {
                        return l10n.text('enterSixDigitCode');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        label: l10n.text('verifyAndContinue'),
                        isLoading: state.status == AuthStatus.authenticating,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().verifyOtp(
                                  phone: widget.phone,
                                  code: _otpController.text.trim(),
                                );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.read<AuthCubit>().sendOtp(widget.phone),
                    child: Text(l10n.text('resendCode')),
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

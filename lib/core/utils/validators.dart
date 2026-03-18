class Validators {
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Поле "$fieldName" обязательно';
    }
    return null;
  }

  static String? email(String? value) {
    if (required(value, fieldName: 'Email') != null) {
      return 'Email обязателен';
    }

    final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Введите корректный email';
    }
    return null;
  }

  static String? password(String? value) {
    if (required(value, fieldName: 'Пароль') != null) {
      return 'Пароль обязателен';
    }
    if (value!.trim().length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  static String? phone(String? value) {
    if (required(value, fieldName: 'Номер телефона') != null) {
      return 'Номер телефона обязателен';
    }

    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      return 'Введите корректный номер телефона';
    }
    return null;
  }
}

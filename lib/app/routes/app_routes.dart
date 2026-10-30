abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const transaction = _Paths.transaction;
  static const transactionAdd = _Paths.transactionAdd;
  static const transactionDetail = _Paths.transactionDetail;
  static const report = _Paths.report;
  static const accounts = _Paths.accounts;
  static const categories = _Paths.categories;
  static const settings = _Paths.settings;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const transaction = '/transaction';
  static const transactionAdd = '/transaction/add';
  static const transactionDetail = '/transaction/detail';
  static const report = '/report';
  static const accounts = '/accounts';
  static const categories = '/categories';
  static const settings = '/settings';
}


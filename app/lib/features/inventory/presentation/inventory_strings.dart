import '../../../core/currency/gym_currency_provider.dart';

/// Copy for the Counter Sale screen.
abstract final class InventoryStrings {
  static const counterSaleTitle = 'Counter Sale';
  static const searchHint = 'Search name or SKU';
  static const nothingMatched = 'Nothing matched';
  static const noSellableItems = 'No items available to sell';
  static const noPermission = 'You do not have permission to create a Counter Sale.';
  static const amountDueLabel = 'Amount due';
  static const continueLabel = 'Continue';
  static const removeLine = 'Remove';
  static const quantityLabel = 'Qty';
  static const onHandLabel = 'On hand';
  static const emptyTrayHint = 'Tap an item to add it';
  static const loadFailed = 'Could not load items';

  static String formatMoney(String amount) => formatCurrencyAmount(amount);

  static String onHand(String qty) => '$onHandLabel $qty';
}

import '../../../core/currency/gym_currency_provider.dart';

/// Copy for the Counter Sale screen.
abstract final class InventoryStrings {
  static const counterSaleTitle = 'Counter Sale';
  static const searchHint = 'Search name or SKU';
  static const nothingMatched = 'Nothing matched';
  static const noSellableItems = 'No items available to sell';
  static const noPermission =
      'You do not have permission to create a Counter Sale.';
  static const amountDueLabel = 'Amount due';
  static const continueLabel = 'Continue';
  static const backLabel = 'Back';
  static const confirmLabel = 'Confirm';
  static const newSaleLabel = 'New sale';
  static const removeLine = 'Remove';
  static const quantityLabel = 'Qty';
  static const onHandLabel = 'On hand';
  static const emptyTrayHint = 'Tap an item to add it';
  static const loadFailed = 'Could not load items';
  static const paymentMethodsLoadFailed = 'Could not load payment methods';
  static const noPaymentMethods =
      'Add payment methods under Payment methods before you can settle.';
  static const buyerStepTitle = 'Buyer';
  static const buyerMemberLabel = 'Member';
  static const buyerMemberHint = 'Select a member';
  static const buyerNameLabel = 'Buyer name';
  static const buyerNameHint = 'Name, if not a Member';
  static const tenderStepTitle = 'Tender';
  static const splitLabel = 'Split';
  static const leaveSplitLabel = 'Single method';
  static const remainderLabel = 'Remaining';
  static const splitTotalLabel = 'Entered';
  static const successTitle = 'Sale posted';
  static const saleNumberLabel = 'Sale number';
  static const overOnHandHint = 'Quantity is above on hand';
  static const mapPaymentMethodHint =
      'Map this payment method in Go-live setup';

  static String formatMoney(String amount) => formatCurrencyAmount(amount);

  static String onHand(String qty) => '$onHandLabel $qty';

  static String onlyAvailable(String qty) => 'Only $qty available';

  static String expectedTotal(String amount) => 'Expected total $amount';
}

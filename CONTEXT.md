# Gym management

The language of the gym product: members, front-desk sales, and the books beside them.

## Language

**Counter Sale**:
A sale of catalog items made at the front desk on the day it is taken, and completed when the cashier takes one or more tenders. An unfinished sale is not kept.
_Avoid_: POS, Record Payment, member sale

**Sale line**:
A quantity of one catalog item on a Counter Sale, priced at that item's sale rate, plus tax when the item has a tax code. The quantity follows the item's unit, choosing the item again adds more, and a tracked item cannot be posted beyond the quantity on hand.
_Avoid_: cart row, SKU line

**Buyer name**:
An optional name on a Counter Sale for a person who is not a Member. The sale names a Member, a buyer name, or neither.
_Avoid_: customer, client, walk-in

**Amount due**:
The total a Counter Sale settles for, equal to the sum of its line charges. Tax is included when an item has a tax code.
_Avoid_: tax line, grand total

**Payment method**:
An active way the gym takes money. The counter offers every one of them.
_Avoid_: tender, pad

**Tender**:
One payment method and the amount of a Counter Sale it settles. One method can settle the whole amount due, or Split can settle it with at least two tenders whose amounts add up to the amount due.
_Avoid_: payment

**Split**:
The choice to settle a Counter Sale with at least two Tenders. Split is not itself a payment method.
_Avoid_: split payment

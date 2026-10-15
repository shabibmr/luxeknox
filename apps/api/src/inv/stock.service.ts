import { Injectable } from '@nestjs/common';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  addMoney,
  addQty,
  cmpMoney,
  cmpQty,
  divValueByQty,
  mulQtyUnitCost,
  subMoney,
  subQty,
} from '../platform/money/money';
import type { NewStockMovement } from '../platform/db/schema/inventory';
import { StockRepository } from './stock.repository';

export interface StockSource {
  sourceType: string;
  sourceId: number;
  sourceLineId?: number | null;
  movementDate: string;
}

export interface StockMovementResult {
  qtyOnHand: string;
  stockValue: string;
  avgCost: string;
  unitCost: string;
  value: string;
}

@Injectable()
export class StockService {
  constructor(private readonly stockRepository: StockRepository) {}

  /**
   * Receive stock at the given net value. Caller must own the ambient transaction.
   */
  async receive(
    itemId: number,
    qty: string,
    value: string,
    source: StockSource,
  ): Promise<StockMovementResult> {
    await this.requireTracked(itemId);
    if (cmpQty(qty, '0') <= 0) {
      throw new BusinessRuleError('Receive quantity must be positive', [
        { rule: 'invalid_stock_qty', item_id: itemId, quantity: qty },
      ]);
    }
    if (cmpMoney(value, '0') < 0) {
      throw new BusinessRuleError('Receive value must be non-negative', [
        { rule: 'invalid_stock_value', item_id: itemId, value },
      ]);
    }

    const locked = await this.stockRepository.lockStockForUpdate(itemId);
    const prevQty = locked?.qty_on_hand ?? '0.000';
    const prevValue = locked?.stock_value ?? '0.00';
    const qtyOnHand = addQty(prevQty, qty);
    const stockValue = addMoney(prevValue, value);
    const avgCost = cmpQty(qtyOnHand, '0') === 0 ? '0.0000' : divValueByQty(stockValue, qtyOnHand);
    const unitCost = divValueByQty(value, qty);

    await this.persist(itemId, locked, qtyOnHand, stockValue, avgCost, {
      item_id: itemId,
      movement_date: source.movementDate,
      source_type: source.sourceType,
      source_id: source.sourceId,
      source_line_id: source.sourceLineId ?? null,
      qty_in: qty,
      qty_out: '0.000',
      unit_cost: unitCost,
      value,
      balance_qty: qtyOnHand,
      balance_value: stockValue,
      created_at: new Date(),
    });

    return { qtyOnHand, stockValue, avgCost, unitCost, value };
  }

  /**
   * Issue stock at the current average cost. The last issue that empties stock
   * takes the remaining value so `stock_value` is never left non-zero at qty 0.
   * Caller must own the ambient transaction.
   */
  async issue(itemId: number, qty: string, source: StockSource): Promise<StockMovementResult> {
    await this.requireTracked(itemId);
    if (cmpQty(qty, '0') <= 0) {
      throw new BusinessRuleError('Issue quantity must be positive', [
        { rule: 'invalid_stock_qty', item_id: itemId, quantity: qty },
      ]);
    }

    const locked = await this.stockRepository.lockStockForUpdate(itemId);
    const prevQty = locked?.qty_on_hand ?? '0.000';
    const prevValue = locked?.stock_value ?? '0.00';
    const avgCost = locked?.avg_cost ?? '0.0000';

    if (cmpQty(qty, prevQty) > 0) {
      throw new BusinessRuleError('Insufficient stock on hand', [
        {
          rule: 'insufficient_stock',
          item_id: itemId,
          requested: qty,
          available: prevQty,
        },
      ]);
    }

    const qtyOnHand = subQty(prevQty, qty);
    const emptying = cmpQty(qtyOnHand, '0') === 0;
    const value = emptying ? prevValue : mulQtyUnitCost(qty, avgCost);
    const stockValue = emptying ? '0.00' : subMoney(prevValue, value);
    const nextAvg = emptying ? '0.0000' : avgCost;
    const unitCost = emptying && cmpQty(qty, '0') > 0 ? divValueByQty(value, qty) : avgCost;

    await this.persist(itemId, locked, qtyOnHand, stockValue, nextAvg, {
      item_id: itemId,
      movement_date: source.movementDate,
      source_type: source.sourceType,
      source_id: source.sourceId,
      source_line_id: source.sourceLineId ?? null,
      qty_in: '0.000',
      qty_out: qty,
      unit_cost: unitCost,
      value,
      balance_qty: qtyOnHand,
      balance_value: stockValue,
      created_at: new Date(),
    });

    return {
      qtyOnHand,
      stockValue,
      avgCost: nextAvg,
      unitCost,
      value,
    };
  }

  private async requireTracked(itemId: number): Promise<void> {
    const item = await this.stockRepository.findTrackedItem(itemId);
    if (!item) {
      throw new NotFoundError(`Item ${itemId} was not found`);
    }
    if (!item.inventory_tracked) {
      throw new BusinessRuleError('Item is not inventory-tracked', [
        { rule: 'item_not_tracked', item_id: itemId },
      ]);
    }
  }

  private async persist(
    itemId: number,
    locked: { id: number; row_version: number } | null,
    qtyOnHand: string,
    stockValue: string,
    avgCost: string,
    movement: NewStockMovement,
  ): Promise<void> {
    if (!locked) {
      await this.stockRepository.insertStock({
        item_id: itemId,
        qty_on_hand: qtyOnHand,
        stock_value: stockValue,
        avg_cost: avgCost,
        row_version: 1,
      });
    } else {
      await this.stockRepository.updateStock(itemId, {
        qty_on_hand: qtyOnHand,
        stock_value: stockValue,
        avg_cost: avgCost,
        row_version: locked.row_version + 1,
      });
    }
    await this.stockRepository.insertMovement(movement);
  }
}

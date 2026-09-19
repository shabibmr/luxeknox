import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';

/**
 * Base interface for all strongly typed domain events.
 */
export interface DomainEvent<T = unknown> {
  readonly eventName: string;
  readonly occurredAt: Date;
  readonly payload: T;
}

/**
 * Strongly typed in-process domain event bus.
 * Wraps NestJS EventEmitter2 to provide typed event dispatching and subscription.
 */
@Injectable()
export class DomainEventBus {
  private readonly logger = new Logger(DomainEventBus.name);

  constructor(private readonly eventEmitter: EventEmitter2) {}

  /**
   * Dispatches a domain event in-process synchronously/asynchronously to all registered listeners.
   *
   * @param event The domain event instance to emit
   */
  async emit<T>(event: DomainEvent<T>): Promise<any[]> {
    this.logger.debug(`Emitting domain event: ${event.eventName}`);
    return this.eventEmitter.emitAsync(event.eventName, event);
  }

  /**
   * Synchronous emit helper if consumers only need fire-and-forget sync execution.
   */
  emitSync<T>(event: DomainEvent<T>): boolean {
    this.logger.debug(`Emitting sync domain event: ${event.eventName}`);
    return this.eventEmitter.emit(event.eventName, event);
  }

  /**
   * Subscribes a listener to a domain event name.
   */
  on<T>(eventName: string, listener: (event: DomainEvent<T>) => void | Promise<void>): void {
    this.eventEmitter.on(eventName, listener);
  }
}

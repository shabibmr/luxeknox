import { describe, it, expect, vi, beforeEach } from 'vitest';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { DomainEventBus, type DomainEvent } from './domain-events';

interface MemberRegisteredPayload {
  memberId: number;
  email: string;
}

class MemberRegisteredEvent implements DomainEvent<MemberRegisteredPayload> {
  readonly eventName = 'member.registered';
  readonly occurredAt = new Date();

  constructor(public readonly payload: MemberRegisteredPayload) {}
}

describe('DomainEventBus', () => {
  let eventEmitter: EventEmitter2;
  let domainEventBus: DomainEventBus;

  beforeEach(() => {
    eventEmitter = new EventEmitter2();
    domainEventBus = new DomainEventBus(eventEmitter);
  });

  it('delivers domain events to registered listeners in-process', async () => {
    const handler = vi.fn();
    domainEventBus.on<MemberRegisteredPayload>('member.registered', (event) => {
      handler(event);
    });

    const event = new MemberRegisteredEvent({ memberId: 42, email: 'member@example.com' });
    await domainEventBus.emit(event);

    expect(handler).toHaveBeenCalledTimes(1);
    expect(handler).toHaveBeenCalledWith(event);
    expect(handler.mock.calls[0][0].payload.memberId).toBe(42);
  });

  it('supports synchronous event dispatch', () => {
    const handler = vi.fn();
    domainEventBus.on<MemberRegisteredPayload>('member.registered', (event) => {
      handler(event);
    });

    const event = new MemberRegisteredEvent({ memberId: 99, email: 'sync@example.com' });
    domainEventBus.emitSync(event);

    expect(handler).toHaveBeenCalledTimes(1);
    expect(handler).toHaveBeenCalledWith(event);
  });
});

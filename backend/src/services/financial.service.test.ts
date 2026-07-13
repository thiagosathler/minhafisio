import { describe, it, expect, vi, beforeEach } from 'vitest';
import { FinancialService } from './financial.service';

describe('FinancialService', () => {
  let service: FinancialService;
  let repository: any;

  beforeEach(() => {
    repository = {
      createPayment: vi.fn(),
      findPaymentsByWorkspace: vi.fn(),
    };
    service = new FinancialService(repository as any);
  });

  it('should create a payment successfully', async () => {
    repository.createPayment.mockResolvedValue({ id: '1' });
    const result = await service.createPayment({
      workspaceId: 'w1',
      personId: 'p1',
      amount: 100,
      dueDate: new Date(),
    });
    expect(repository.createPayment).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should throw if missing required fields', async () => {
    await expect(service.createPayment({
      workspaceId: '',
      personId: 'p1',
      amount: 100,
      dueDate: new Date(),
    })).rejects.toThrow('Workspace, Person, amount and dueDate are required.');
  });
});

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { SystemService } from './system.service';

describe('SystemService', () => {
  let service: SystemService;
  let repository: any;

  beforeEach(() => {
    repository = {
      createNotification: vi.fn(),
      findNotifications: vi.fn(),
    };
    service = new SystemService(repository as any);
  });

  it('should create a notification successfully', async () => {
    repository.createNotification.mockResolvedValue({ id: '1' });
    const result = await service.createNotification({
      workspaceId: 'w1',
      title: 'Test',
      content: 'Message'
    });
    expect(repository.createNotification).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });
});

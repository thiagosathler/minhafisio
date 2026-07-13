import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ScheduleService } from './schedule.service';

describe('ScheduleService', () => {
  let service: ScheduleService;
  let repository: any;

  beforeEach(() => {
    repository = {
      createRule: vi.fn(),
      findSessionsByWorkspace: vi.fn(),
    };
    service = new ScheduleService(repository as any);
  });

  it('should create a schedule rule successfully', async () => {
    repository.createRule.mockResolvedValue({ id: '1' });
    const result = await service.createScheduleRule({
      workspaceId: 'w1',
      offeringId: 'o1',
      professionalId: 'p1',
      weekday: 'MONDAY',
      startMinute: 480,
      endMinute: 540,
      startDate: new Date(),
    });
    expect(repository.createRule).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should throw if missing required fields', async () => {
    await expect(service.createScheduleRule({
      workspaceId: '',
      offeringId: 'o1',
      professionalId: 'p1',
      weekday: 'MONDAY',
      startMinute: 480,
      endMinute: 540,
      startDate: new Date(),
    })).rejects.toThrow('Workspace, Offering and Professional are required.');
  });
});

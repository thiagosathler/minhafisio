import { describe, it, expect, vi, beforeEach } from 'vitest';
import { CatalogService } from './catalog.service';

describe('CatalogService', () => {
  let service: CatalogService;
  let repository: any;

  beforeEach(() => {
    repository = {
      createService: vi.fn(),
      createOffering: vi.fn(),
      findAllServicesByWorkspace: vi.fn(),
    };
    service = new CatalogService(repository as any);
  });

  it('should create a service successfully', async () => {
    repository.createService.mockResolvedValue({ id: '1', name: 'Pilates' });
    const result = await service.createService({ workspaceId: 'w1', name: 'Pilates' });
    expect(repository.createService).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should throw if name is missing in service', async () => {
    await expect(service.createService({ workspaceId: 'w1', name: '' })).rejects.toThrow('Service name is required.');
  });
});

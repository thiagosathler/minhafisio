import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ResourceService } from './resource.service';

describe('ResourceService', () => {
  let service: ResourceService;
  let repository: any;

  beforeEach(() => {
    repository = {
      create: vi.fn(),
      findAllByWorkspace: vi.fn(),
    };
    service = new ResourceService(repository as any);
  });

  it('should create a resource successfully', async () => {
    repository.create.mockResolvedValue({ id: '1', name: 'Sala 01' });
    const result = await service.createResource({ workspaceId: 'w1', name: 'Sala 01', type: 'ROOM' });
    expect(repository.create).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should throw if type is missing in resource', async () => {
    await expect(service.createResource({ workspaceId: 'w1', name: 'Sala 01', type: '' })).rejects.toThrow('Resource name and type are required.');
  });
});

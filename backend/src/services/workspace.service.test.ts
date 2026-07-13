import { describe, it, expect, vi, beforeEach } from 'vitest';
import { WorkspaceService } from './workspace.service';
import { WorkspaceRepository } from '../repositories/workspace.repository';

describe('WorkspaceService', () => {
  let service: WorkspaceService;
  let repository: any; // Mock

  beforeEach(() => {
    repository = {
      create: vi.fn(),
      findById: vi.fn(),
      findAll: vi.fn(),
      update: vi.fn(),
      softDelete: vi.fn(),
    };
    service = new WorkspaceService(repository as unknown as WorkspaceRepository);
  });

  it('should create a workspace successfully', async () => {
    const mockData = { name: 'Test Clinic' };
    const mockCreated = { id: '1', ...mockData, status: 'ACTIVE' };
    repository.create.mockResolvedValue(mockCreated);

    const result = await service.createWorkspace(mockData);

    expect(repository.create).toHaveBeenCalledWith({
      ...mockData,
      status: 'ACTIVE',
    });
    expect(result).toEqual(mockCreated);
  });

  it('should throw error if name is missing when creating workspace', async () => {
    await expect(service.createWorkspace({ name: '' })).rejects.toThrow('Workspace name is required.');
  });
});

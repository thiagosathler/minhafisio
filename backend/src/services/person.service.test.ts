import { describe, it, expect, vi, beforeEach } from 'vitest';
import { PersonService } from './person.service';

describe('PersonService', () => {
  let service: PersonService;
  let repository: any; // Mock

  beforeEach(() => {
    repository = {
      create: vi.fn(),
      findAllByWorkspace: vi.fn(),
    };
    service = new PersonService(repository as any);
  });

  it('should create a person successfully', async () => {
    const mockCreated = { id: '1', name: 'João', workspaceId: 'w1' };
    repository.create.mockResolvedValue(mockCreated);

    const result = await service.createPerson({
      name: 'João',
      workspaceId: 'w1',
      isProfessional: true,
      crefito: '12345'
    });

    expect(repository.create).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should throw if name is missing', async () => {
    await expect(service.createPerson({ name: '', workspaceId: 'w1' })).rejects.toThrow('Name is required.');
  });
});

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UserService } from './user.service';
import bcrypt from 'bcrypt';

describe('UserService', () => {
  let service: UserService;
  let repository: any; // Mock

  beforeEach(() => {
    repository = {
      create: vi.fn(),
      findByEmail: vi.fn(),
      findById: vi.fn(),
      createUserWorkspace: vi.fn(),
      updateLastLogin: vi.fn(),
    };
    service = new UserService(repository as any);
  });

  it('should register a new user successfully', async () => {
    repository.findByEmail.mockResolvedValue(null);
    repository.create.mockResolvedValue({ id: '1', email: 'test@test.com' });
    repository.createUserWorkspace.mockResolvedValue({});

    const result = await service.registerUser({
      name: 'Test',
      email: 'test@test.com',
      passwordRaw: 'password',
      workspaceId: 'w1',
    });

    expect(repository.findByEmail).toHaveBeenCalledWith('test@test.com');
    expect(repository.create).toHaveBeenCalled();
    expect(repository.createUserWorkspace).toHaveBeenCalled();
    expect(result.id).toBe('1');
  });

  it('should not register if email already exists', async () => {
    repository.findByEmail.mockResolvedValue({ id: '1' });
    
    await expect(
      service.registerUser({ name: 'Test', email: 'test@test.com', passwordRaw: 'password', workspaceId: 'w1' })
    ).rejects.toThrow('Email already registered.');
  });
});

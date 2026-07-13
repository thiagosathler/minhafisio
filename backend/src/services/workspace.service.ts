import { WorkspaceRepository } from '../repositories/workspace.repository';
import { Prisma } from '@prisma/client';

export class WorkspaceService {
  constructor(private workspaceRepository: WorkspaceRepository) {}

  async createWorkspace(data: {
    name: string;
    legalName?: string;
    document?: string;
    email?: string;
    phone?: string;
    timezone?: string;
  }) {
    if (!data.name) {
      throw new Error('Workspace name is required.');
    }
    
    // Regras de negócio adicionais poderiam ser validadas aqui
    
    return this.workspaceRepository.create({
      ...data,
      status: 'ACTIVE',
    });
  }

  async getWorkspaceById(id: string) {
    const workspace = await this.workspaceRepository.findById(id);
    if (!workspace) {
      throw new Error('Workspace not found.');
    }
    return workspace;
  }

  async getWorkspacesByUser(userId: string) {
    return this.workspaceRepository.findByUserId(userId);
  }

  async updateWorkspace(id: string, data: Prisma.WorkspaceUpdateInput) {
    return this.workspaceRepository.update(id, data);
  }

  async deleteWorkspace(id: string) {
    return this.workspaceRepository.softDelete(id);
  }
}

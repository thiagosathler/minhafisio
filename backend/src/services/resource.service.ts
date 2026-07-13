import { ResourceRepository } from '../repositories/resource.repository';

export class ResourceService {
  constructor(private resourceRepository: ResourceRepository) {}

  async createResource(data: { workspaceId: string; name: string; type: string; capacity?: number; color?: string; description?: string }) {
    if (!data.name || !data.type) throw new Error('Resource name and type are required.');
    
    return this.resourceRepository.create({
      workspace: { connect: { id: data.workspaceId } },
      name: data.name,
      type: data.type,
      capacity: data.capacity || 1,
      color: data.color,
      description: data.description,
    });
  }

  async getResourcesByWorkspace(workspaceId: string) {
    return this.resourceRepository.findAllByWorkspace(workspaceId);
  }
}

import { CatalogRepository } from '../repositories/catalog.repository';

export class CatalogService {
  constructor(private catalogRepository: CatalogRepository) {}

  async createService(data: { workspaceId: string; name: string; color?: string }) {
    if (!data.name) throw new Error('Service name is required.');
    
    return this.catalogRepository.createService({
      workspace: { connect: { id: data.workspaceId } },
      name: data.name,
      color: data.color
    });
  }

  async createOffering(data: { serviceId: string; name: string; mode: string; durationMinutes: number; capacity?: number; defaultPrice?: number }) {
    if (!data.name || !data.durationMinutes) throw new Error('Offering name and duration are required.');

    return this.catalogRepository.createOffering({
      service: { connect: { id: data.serviceId } },
      name: data.name,
      mode: data.mode,
      durationMinutes: data.durationMinutes,
      capacity: data.capacity || 1,
      defaultPrice: data.defaultPrice
    });
  }

  async getServicesByWorkspace(workspaceId: string) {
    return this.catalogRepository.findAllServicesByWorkspace(workspaceId);
  }
}

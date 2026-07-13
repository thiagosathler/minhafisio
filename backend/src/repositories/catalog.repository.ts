import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class CatalogRepository {
  async createService(data: Prisma.ServiceCreateInput) {
    return prisma.service.create({ data });
  }

  async findServiceById(id: string) {
    return prisma.service.findUnique({
      where: { id },
      include: { offerings: true }
    });
  }

  async findAllServicesByWorkspace(workspaceId: string) {
    return prisma.service.findMany({
      where: { workspaceId, active: true },
      include: { offerings: true }
    });
  }

  async findOfferingById(id: string) {
    return prisma.offering.findUnique({ where: { id } });
  }

  async createOffering(data: Prisma.OfferingCreateInput) {
    return prisma.offering.create({ data });
  }
}

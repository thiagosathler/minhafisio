import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class ResourceRepository {
  async create(data: Prisma.ResourceCreateInput) {
    return prisma.resource.create({ data });
  }

  async findAllByWorkspace(workspaceId: string) {
    return prisma.resource.findMany({
      where: { workspaceId, active: true },
    });
  }
}

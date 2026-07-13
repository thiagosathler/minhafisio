import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class WorkspaceRepository {
  async create(data: Prisma.WorkspaceCreateInput) {
    return prisma.workspace.create({ data });
  }

  async findById(id: string) {
    return prisma.workspace.findUnique({ where: { id } });
  }

  async findByUserId(userId: string) {
    return prisma.workspace.findMany({
      where: {
        users: {
          some: {
            userId: userId
          }
        }
      }
    });
  }

  async update(id: string, data: Prisma.WorkspaceUpdateInput) {
    return prisma.workspace.update({ where: { id }, data });
  }

  async softDelete(id: string) {
    return prisma.workspace.update({
      where: { id },
      data: { deletedAt: new Date(), status: 'INACTIVE' },
    });
  }
}

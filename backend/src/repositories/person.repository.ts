import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class PersonRepository {
  async create(data: Prisma.PersonCreateInput) {
    return prisma.person.create({ data });
  }

  async findById(id: string) {
    return prisma.person.findUnique({
      where: { id },
      include: { professional: true, client: true }
    });
  }

  async findAllByWorkspace(workspaceId: string, isClient?: boolean, isProfessional?: boolean) {
    const where: any = { workspaceId, active: true };
    if (isClient === true) {
      where.client = { isNot: null };
    }
    if (isProfessional === true) {
      where.professional = { isNot: null };
    }
    return prisma.person.findMany({
      where,
      include: { professional: true, client: true },
      orderBy: { name: 'asc' }
    });
  }
}

import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class FinancialRepository {
  async createContract(data: Prisma.ContractCreateInput) {
    return prisma.contract.create({ data });
  }

  async createPackage(data: Prisma.PackageCreateInput) {
    return prisma.package.create({ data });
  }

  async createPayment(data: Prisma.PaymentCreateInput) {
    return prisma.payment.create({ data });
  }

  async findPaymentsByWorkspace(workspaceId: string) {
    return prisma.payment.findMany({
      where: { workspaceId },
      include: { person: true }
    });
  }
}

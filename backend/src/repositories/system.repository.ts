import { prisma } from '../lib/prisma';
import { Prisma } from '@prisma/client';

export class SystemRepository {
  async createNotification(data: Prisma.NotificationCreateInput) {
    return prisma.notification.create({ data });
  }

  async findNotifications(workspaceId: string, userId?: string) {
    const where: any = { workspaceId };
    if (userId) where.userId = userId;
    return prisma.notification.findMany({ where, orderBy: { createdAt: 'desc' } });
  }

  async createLog(data: Prisma.SystemLogCreateInput) {
    return prisma.systemLog.create({ data });
  }

  async findLogs(workspaceId: string) {
    return prisma.systemLog.findMany({ where: { workspaceId }, orderBy: { createdAt: 'desc' } });
  }
}

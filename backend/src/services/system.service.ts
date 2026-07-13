import { SystemRepository } from '../repositories/system.repository';

export class SystemService {
  constructor(private systemRepository: SystemRepository) {}

  async createNotification(data: { workspaceId: string; userId?: string; title: string; content: string }) {
    if (!data.workspaceId || !data.title || !data.content) {
      throw new Error('Workspace, title and content are required.');
    }
    return this.systemRepository.createNotification({
      workspace: { connect: { id: data.workspaceId } },
      userId: data.userId,
      title: data.title,
      content: data.content,
    });
  }

  async getNotifications(workspaceId: string, userId?: string) {
    return this.systemRepository.findNotifications(workspaceId, userId);
  }

  async createLog(data: { workspaceId: string; userId?: string; action: string; entity: string; entityId: string; details?: string }) {
    if (!data.workspaceId || !data.action || !data.entity || !data.entityId) {
      throw new Error('Workspace, action, entity and entityId are required.');
    }
    return this.systemRepository.createLog({
      workspace: { connect: { id: data.workspaceId } },
      userId: data.userId,
      action: data.action,
      entity: data.entity,
      entityId: data.entityId,
      details: data.details,
    });
  }
}

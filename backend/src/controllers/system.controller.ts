import { FastifyRequest, FastifyReply } from 'fastify';
import { SystemService } from '../services/system.service';

export class SystemController {
  constructor(private systemService: SystemService) {}

  async createNotification(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const notification = await this.systemService.createNotification(data);
      return reply.status(201).send(notification);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getNotifications(req: FastifyRequest<{ Querystring: { workspaceId: string, userId?: string } }>, reply: FastifyReply) {
    try {
      const { workspaceId, userId } = req.query;
      if (!workspaceId) {
        return reply.status(400).send({ error: 'workspaceId query param is required' });
      }
      const notifications = await this.systemService.getNotifications(workspaceId, userId);
      return reply.send(notifications);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

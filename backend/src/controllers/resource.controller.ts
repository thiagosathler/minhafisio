import { FastifyRequest, FastifyReply } from 'fastify';
import { ResourceService } from '../services/resource.service';

export class ResourceController {
  constructor(private resourceService: ResourceService) {}

  async create(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const resource = await this.resourceService.createResource(data);
      return reply.status(201).send(resource);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getAllByWorkspace(req: FastifyRequest<{ Querystring: { workspaceId: string } }>, reply: FastifyReply) {
    try {
      const { workspaceId } = req.query;
      if (!workspaceId) {
        return reply.status(400).send({ error: 'workspaceId query param is required' });
      }
      const resources = await this.resourceService.getResourcesByWorkspace(workspaceId);
      return reply.send(resources);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

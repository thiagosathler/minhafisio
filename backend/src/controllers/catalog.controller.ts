import { FastifyRequest, FastifyReply } from 'fastify';
import { CatalogService } from '../services/catalog.service';

export class CatalogController {
  constructor(private catalogService: CatalogService) {}

  async createService(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const service = await this.catalogService.createService(data);
      return reply.status(201).send(service);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async createOffering(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const offering = await this.catalogService.createOffering(data);
      return reply.status(201).send(offering);
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
      const services = await this.catalogService.getServicesByWorkspace(workspaceId);
      return reply.send(services);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

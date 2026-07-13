import { FastifyInstance } from 'fastify';
import { ResourceController } from '../controllers/resource.controller';
import { ResourceService } from '../services/resource.service';
import { ResourceRepository } from '../repositories/resource.repository';

export async function resourceRoutes(fastify: FastifyInstance) {
  const repository = new ResourceRepository();
  const service = new ResourceService(repository);
  const controller = new ResourceController(service);

  fastify.post('/resources', controller.create.bind(controller));
  fastify.get('/resources', controller.getAllByWorkspace.bind(controller));
}

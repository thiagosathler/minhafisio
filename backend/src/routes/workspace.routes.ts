import { FastifyInstance } from 'fastify';
import { WorkspaceController } from '../controllers/workspace.controller';
import { WorkspaceService } from '../services/workspace.service';
import { WorkspaceRepository } from '../repositories/workspace.repository';
import { authenticate } from '../middlewares/auth.middleware';

export async function workspaceRoutes(fastify: FastifyInstance) {
  // Simple Dependency Injection (Manual Composition)
  const repository = new WorkspaceRepository();
  const service = new WorkspaceService(repository);
  const controller = new WorkspaceController(service);

  fastify.post('/workspaces', { preHandler: [authenticate] }, controller.create.bind(controller));
  fastify.get('/workspaces/:id', { preHandler: [authenticate] }, controller.getById.bind(controller));
  fastify.get('/workspaces', { preHandler: [authenticate] }, controller.getAll.bind(controller));
  fastify.put('/workspaces/:id', controller.update.bind(controller));
  fastify.delete('/workspaces/:id', controller.delete.bind(controller));
}

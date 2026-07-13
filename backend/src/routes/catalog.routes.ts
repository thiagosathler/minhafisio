import { FastifyInstance } from 'fastify';
import { CatalogController } from '../controllers/catalog.controller';
import { CatalogService } from '../services/catalog.service';
import { CatalogRepository } from '../repositories/catalog.repository';

export async function catalogRoutes(fastify: FastifyInstance) {
  const repository = new CatalogRepository();
  const service = new CatalogService(repository);
  const controller = new CatalogController(service);

  fastify.post('/catalog/services', controller.createService.bind(controller));
  fastify.post('/catalog/offerings', controller.createOffering.bind(controller));
  fastify.get('/catalog/services', controller.getAllByWorkspace.bind(controller));
}

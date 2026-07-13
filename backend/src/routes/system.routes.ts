import { FastifyInstance } from 'fastify';
import { SystemController } from '../controllers/system.controller';
import { SystemService } from '../services/system.service';
import { SystemRepository } from '../repositories/system.repository';

export async function systemRoutes(fastify: FastifyInstance) {
  const repository = new SystemRepository();
  const service = new SystemService(repository);
  const controller = new SystemController(service);

  fastify.post('/system/notifications', controller.createNotification.bind(controller));
  fastify.get('/system/notifications', controller.getNotifications.bind(controller));
}

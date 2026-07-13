import { FastifyInstance } from 'fastify';
import { ScheduleController } from '../controllers/schedule.controller';
import { ScheduleService } from '../services/schedule.service';
import { ScheduleRepository } from '../repositories/schedule.repository';
import { CatalogRepository } from '../repositories/catalog.repository';

export async function scheduleRoutes(fastify: FastifyInstance) {
  const scheduleRepo = new ScheduleRepository();
  const catalogRepo = new CatalogRepository();
  const service = new ScheduleService(scheduleRepo, catalogRepo);
  const controller = new ScheduleController(service);

  fastify.post('/schedule/sessions', controller.createAvulsoSession.bind(controller));
  fastify.get('/schedule/sessions', controller.getSessions.bind(controller));
}

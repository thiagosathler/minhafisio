import { FastifyInstance } from 'fastify';
import { PersonController } from '../controllers/person.controller';
import { PersonService } from '../services/person.service';
import { PersonRepository } from '../repositories/person.repository';

export async function personRoutes(fastify: FastifyInstance) {
  const repository = new PersonRepository();
  const service = new PersonService(repository);
  const controller = new PersonController(service);

  fastify.post('/persons', controller.create.bind(controller));
  fastify.get('/persons', controller.getAllByWorkspace.bind(controller));
}

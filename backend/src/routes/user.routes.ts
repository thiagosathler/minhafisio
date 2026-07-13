import { FastifyInstance } from 'fastify';
import { UserController } from '../controllers/user.controller';
import { UserService } from '../services/user.service';
import { UserRepository } from '../repositories/user.repository';

export async function userRoutes(fastify: FastifyInstance) {
  const repository = new UserRepository();
  const service = new UserService(repository);
  const controller = new UserController(service);

  fastify.post('/auth/register', controller.register.bind(controller));
  fastify.post('/auth/login', controller.login.bind(controller));
}

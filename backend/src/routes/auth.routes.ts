import { FastifyInstance } from 'fastify';
import { AuthController } from '../controllers/auth.controller';
import { AuthService } from '../services/auth.service';
import { UserRepository } from '../repositories/user.repository';

export async function authRoutes(fastify: FastifyInstance) {
  const repo = new UserRepository();
  const service = new AuthService(repo);
  const controller = new AuthController(service);

  fastify.post('/auth/register', controller.register.bind(controller));
  fastify.post('/auth/login', controller.login.bind(controller));
}

import { FastifyRequest, FastifyReply } from 'fastify';
import { AuthService } from '../services/auth.service';

export class AuthController {
  constructor(private authService: AuthService) {}

  async register(req: FastifyRequest, reply: FastifyReply) {
    try {
      const { name, email, password, workspaceName } = req.body as any;
      if (!name || !email || !password || !workspaceName) {
        return reply.status(400).send({ error: 'Campos obrigatórios ausentes.' });
      }
      
      const result = await this.authService.register(name, email, password, workspaceName);
      return reply.status(201).send(result);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async login(req: FastifyRequest, reply: FastifyReply) {
    try {
      const { email, password } = req.body as any;
      if (!email || !password) {
        return reply.status(400).send({ error: 'Campos obrigatórios ausentes.' });
      }

      const result = await this.authService.login(email, password);
      return reply.send(result);
    } catch (error: any) {
      return reply.status(401).send({ error: error.message });
    }
  }
}

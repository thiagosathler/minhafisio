import { FastifyRequest, FastifyReply } from 'fastify';
import { UserService } from '../services/user.service';

export class UserController {
  constructor(private userService: UserService) {}

  async register(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const user = await this.userService.registerUser({
        name: data.name,
        email: data.email,
        passwordRaw: data.password,
        workspaceId: data.workspaceId,
        role: data.role
      });
      return reply.status(201).send(user);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async login(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const result = await this.userService.login(data.email, data.password);
      return reply.send(result);
    } catch (error: any) {
      return reply.status(401).send({ error: error.message });
    }
  }
}

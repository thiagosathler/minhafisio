import { FastifyRequest, FastifyReply } from 'fastify';
import { WorkspaceService } from '../services/workspace.service';
import { Prisma } from '@prisma/client';

export class WorkspaceController {
  constructor(private workspaceService: WorkspaceService) {}

  async create(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const workspace = await this.workspaceService.createWorkspace(data);
      return reply.status(201).send(workspace);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getById(req: FastifyRequest<{ Params: { id: string } }>, reply: FastifyReply) {
    try {
      const workspace = await this.workspaceService.getWorkspaceById(req.params.id);
      return reply.send(workspace);
    } catch (error: any) {
      return reply.status(404).send({ error: error.message });
    }
  }

  async getAll(req: FastifyRequest, reply: FastifyReply) {
    const userId = (req as any).user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }
    const workspaces = await this.workspaceService.getWorkspacesByUser(userId);
    return reply.send(workspaces);
  }

  async update(req: FastifyRequest<{ Params: { id: string } }>, reply: FastifyReply) {
    try {
      const data = req.body as Prisma.WorkspaceUpdateInput;
      const workspace = await this.workspaceService.updateWorkspace(req.params.id, data);
      return reply.send(workspace);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async delete(req: FastifyRequest<{ Params: { id: string } }>, reply: FastifyReply) {
    try {
      const workspace = await this.workspaceService.deleteWorkspace(req.params.id);
      return reply.send(workspace);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

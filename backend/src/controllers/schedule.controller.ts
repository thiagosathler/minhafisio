import { FastifyRequest, FastifyReply } from 'fastify';
import { ScheduleService } from '../services/schedule.service';

export class ScheduleController {
  constructor(private scheduleService: ScheduleService) {}

  async createAvulsoSession(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      
      const session = await this.scheduleService.createAvulsoSession({
        workspaceId: data.workspaceId,
        offeringId: data.offeringId,
        professionalId: data.professionalId,
        personId: data.personId,
        sessionDate: new Date(data.sessionDate),
        startMinute: data.startMinute,
      });

      return reply.status(201).send(session);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getSessions(req: FastifyRequest<{ Querystring: { workspaceId: string, startDate: string, endDate: string } }>, reply: FastifyReply) {
    try {
      const { workspaceId, startDate, endDate } = req.query;
      if (!workspaceId || !startDate || !endDate) {
        return reply.status(400).send({ error: 'workspaceId, startDate, and endDate query params are required' });
      }

      const sessions = await this.scheduleService.getSessions(workspaceId, new Date(startDate), new Date(endDate));
      return reply.send(sessions);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

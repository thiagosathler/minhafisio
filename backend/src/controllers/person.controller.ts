import { FastifyRequest, FastifyReply } from 'fastify';
import { PersonService } from '../services/person.service';

export class PersonController {
  constructor(private personService: PersonService) {}

  async create(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const person = await this.personService.createPerson(data);
      return reply.status(201).send(person);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getAllByWorkspace(req: FastifyRequest<{ Querystring: { workspaceId: string, isClient?: string, isProfessional?: string } }>, reply: FastifyReply) {
    try {
      const { workspaceId, isClient, isProfessional } = req.query;
      if (!workspaceId) {
        return reply.status(400).send({ error: 'workspaceId query param is required' });
      }
      const persons = await this.personService.getPersonsByWorkspace(workspaceId, isClient === 'true', isProfessional === 'true');
      return reply.send(persons);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

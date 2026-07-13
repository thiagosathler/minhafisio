import { FastifyRequest, FastifyReply } from 'fastify';
import { FinancialService } from '../services/financial.service';

export class FinancialController {
  constructor(private financialService: FinancialService) {}

  async createPayment(req: FastifyRequest, reply: FastifyReply) {
    try {
      const data = req.body as any;
      const payment = await this.financialService.createPayment(data);
      return reply.status(201).send(payment);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }

  async getPayments(req: FastifyRequest<{ Querystring: { workspaceId: string } }>, reply: FastifyReply) {
    try {
      const { workspaceId } = req.query;
      if (!workspaceId) {
        return reply.status(400).send({ error: 'workspaceId query param is required' });
      }
      const payments = await this.financialService.getPayments(workspaceId);
      return reply.send(payments);
    } catch (error: any) {
      return reply.status(400).send({ error: error.message });
    }
  }
}

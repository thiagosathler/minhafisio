import { FastifyInstance } from 'fastify';
import { FinancialController } from '../controllers/financial.controller';
import { FinancialService } from '../services/financial.service';
import { FinancialRepository } from '../repositories/financial.repository';

export async function financialRoutes(fastify: FastifyInstance) {
  const repository = new FinancialRepository();
  const service = new FinancialService(repository);
  const controller = new FinancialController(service);

  fastify.post('/financial/payments', controller.createPayment.bind(controller));
  fastify.get('/financial/payments', controller.getPayments.bind(controller));
}

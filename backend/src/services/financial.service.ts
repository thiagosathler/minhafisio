import { FinancialRepository } from '../repositories/financial.repository';

export class FinancialService {
  constructor(private financialRepository: FinancialRepository) {}

  async createPayment(data: {
    workspaceId: string;
    personId: string;
    amount: number;
    dueDate: Date;
  }) {
    if (!data.workspaceId || !data.personId || data.amount === undefined || !data.dueDate) {
      throw new Error('Workspace, Person, amount and dueDate are required.');
    }

    return this.financialRepository.createPayment({
      workspace: { connect: { id: data.workspaceId } },
      person: { connect: { id: data.personId } },
      amount: data.amount,
      dueDate: new Date(data.dueDate),
    });
  }

  async getPayments(workspaceId: string) {
    return this.financialRepository.findPaymentsByWorkspace(workspaceId);
  }
}

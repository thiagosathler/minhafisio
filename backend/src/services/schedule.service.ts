import { ScheduleRepository } from '../repositories/schedule.repository';
import { CatalogRepository } from '../repositories/catalog.repository';

export class ScheduleService {
  constructor(
    private scheduleRepository: ScheduleRepository,
    private catalogRepository: CatalogRepository
  ) {}

  async createAvulsoSession(data: {
    workspaceId: string;
    offeringId: string;
    professionalId: string;
    personId: string;
    sessionDate: Date;
    startMinute: number;
  }) {
    // Descobrir o tempo do Offering para calcular endMinute
    const offering = await this.catalogRepository.findOfferingById(data.offeringId);
    if (!offering) throw new Error('Offering não encontrado');

    const endMinute = data.startMinute + offering.durationMinutes;

    return this.scheduleRepository.createAvulsoSession({
      workspaceId: data.workspaceId,
      offeringId: data.offeringId,
      professionalId: data.professionalId,
      personId: data.personId,
      sessionDate: data.sessionDate,
      startMinute: data.startMinute,
      endMinute,
    });
  }

  async getSessions(workspaceId: string, startDate: Date, endDate: Date) {
    return this.scheduleRepository.getSessionsByDateRange(workspaceId, startDate, endDate);
  }
}

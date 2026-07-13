import { prisma } from '../lib/prisma';

export class ScheduleRepository {
  async createAvulsoSession(data: {
    workspaceId: string;
    offeringId: string;
    professionalId: string;
    personId: string;
    sessionDate: Date;
    startMinute: number;
    endMinute: number;
  }) {
    // Cria a sessão e já atrela o Attendance para o paciente
    return prisma.session.create({
      data: {
        workspaceId: data.workspaceId,
        offeringId: data.offeringId,
        professionalId: data.professionalId,
        sessionDate: data.sessionDate,
        startMinute: data.startMinute,
        endMinute: data.endMinute,
        status: 'SCHEDULED',
        attendances: {
          create: {
            personId: data.personId,
            status: 'SCHEDULED',
          }
        }
      },
      include: {
        attendances: { include: { person: true } },
        offering: true,
        professional: true,
      }
    });
  }

  async getSessionsByDateRange(workspaceId: string, startDate: Date, endDate: Date) {
    return prisma.session.findMany({
      where: {
        workspaceId,
        sessionDate: {
          gte: startDate,
          lte: endDate,
        },
      },
      include: {
        attendances: { include: { person: true } },
        offering: true,
        professional: true,
      },
      orderBy: [
        { sessionDate: 'asc' },
        { startMinute: 'asc' }
      ]
    });
  }
}

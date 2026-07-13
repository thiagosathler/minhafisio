import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('Cleaning database...');
  await prisma.attendance.deleteMany();
  await prisma.session.deleteMany();
  await prisma.scheduleRule.deleteMany();
  await prisma.offering.deleteMany();
  await prisma.service.deleteMany();
  await prisma.clientProfile.deleteMany();
  await prisma.professionalProfile.deleteMany();
  await prisma.person.deleteMany();
  await prisma.userWorkspace.deleteMany();
  await prisma.user.deleteMany();
  await prisma.workspace.deleteMany();

  console.log('Start seeding...');
  
  const passwordHash = await bcrypt.hash('123456', 10);

  // WORKSPACE 1
  const workspace1 = await prisma.workspace.create({
    data: {
      name: 'Clínica Fisio & Pilates',
      legalName: 'Fisio Pilates Saúde LTDA',
      document: '12345678000199',
      email: 'contato@fisiopilates.com.br',
      phone: '11999998888',
      timezone: 'America/Sao_Paulo',
      status: 'ACTIVE',
    },
  });

  const user1_w1 = await prisma.user.create({
    data: {
      name: 'Ana (Dona)',
      email: 'ana@fisiopilates.com',
      passwordHash,
      workspaces: {
        create: {
          workspaceId: workspace1.id,
          role: 'OWNER',
          isOwner: true,
        }
      }
    }
  });

  const user2_w1 = await prisma.user.create({
    data: {
      name: 'Bruno (Fisio)',
      email: 'bruno@fisiopilates.com',
      passwordHash,
      workspaces: {
        create: {
          workspaceId: workspace1.id,
          role: 'PROFESSIONAL',
          isOwner: false,
        }
      }
    }
  });

  // WORKSPACE 2
  const workspace2 = await prisma.workspace.create({
    data: {
      name: 'Estúdio Corpo Ativo',
      legalName: 'Corpo Ativo Estúdio LTDA',
      document: '98765432000188',
      email: 'contato@corpoativo.com.br',
      phone: '11988887777',
      timezone: 'America/Sao_Paulo',
      status: 'ACTIVE',
    },
  });

  const user1_w2 = await prisma.user.create({
    data: {
      name: 'Carla (Dona)',
      email: 'carla@corpoativo.com',
      passwordHash,
      workspaces: {
        create: {
          workspaceId: workspace2.id,
          role: 'OWNER',
          isOwner: true,
        }
      }
    }
  });

  const user2_w2 = await prisma.user.create({
    data: {
      name: 'Daniel (Recepção)',
      email: 'daniel@corpoativo.com',
      passwordHash,
      workspaces: {
        create: {
          workspaceId: workspace2.id,
          role: 'RECEPTIONIST',
          isOwner: false,
        }
      }
    }
  });

  // --- SEEDS DE AGENDA PARA WORKSPACE 1 ---
  const prof1 = await prisma.person.create({
    data: {
      workspaceId: workspace1.id,
      name: 'Ana (Dona)',
      professional: { create: {} }
    }
  });

  const prof2 = await prisma.person.create({
    data: {
      workspaceId: workspace1.id,
      name: 'Bruno (Fisio)',
      professional: { create: {} }
    }
  });

  const client1 = await prisma.person.create({
    data: {
      workspaceId: workspace1.id,
      name: 'João da Silva',
      email: 'joao@email.com',
      phone: '11911112222',
      client: { create: {} }
    }
  });

  const client2 = await prisma.person.create({
    data: {
      workspaceId: workspace1.id,
      name: 'Maria Oliveira',
      email: 'maria@email.com',
      phone: '11933334444',
      client: { create: {} }
    }
  });

  const service1 = await prisma.service.create({
    data: {
      workspaceId: workspace1.id,
      name: 'Fisioterapia Motora',
      color: '#FF0000',
    }
  });

  const offering1 = await prisma.offering.create({
    data: {
      serviceId: service1.id,
      name: 'Sessão de Fisioterapia Motora',
      mode: 'INDIVIDUAL',
      durationMinutes: 60,
    }
  });

  const service2 = await prisma.service.create({
    data: {
      workspaceId: workspace1.id,
      name: 'Pilates Aparelhos',
      color: '#00FF00',
    }
  });

  const offering2 = await prisma.offering.create({
    data: {
      serviceId: service2.id,
      name: 'Aula de Pilates Aparelhos',
      mode: 'GROUP',
      durationMinutes: 60,
    }
  });

  // Criando sessões em dias diferentes do mês atual (Julho 2026)
  const createSessionSeed = async (dateStr: string, startHour: number, endHour: number, offeringId: string, profId: string, clientId: string, status: string) => {
    await prisma.session.create({
      data: {
        workspaceId: workspace1.id,
        offeringId: offeringId,
        professionalId: profId,
        sessionDate: new Date(dateStr),
        startMinute: startHour * 60,
        endMinute: endHour * 60,
        status,
        attendances: {
          create: [{ personId: clientId, status: 'SCHEDULED' }]
        }
      }
    });
  };

  await createSessionSeed('2026-07-09T00:00:00Z', 9, 10, offering1.id, prof1.id, client1.id, 'CONFIRMED');
  await createSessionSeed('2026-07-09T00:00:00Z', 10, 11, offering2.id, prof2.id, client2.id, 'SCHEDULED');
  await createSessionSeed('2026-07-08T00:00:00Z', 17, 18, offering2.id, prof2.id, client1.id, 'COMPLETED');
  await createSessionSeed('2026-07-14T00:00:00Z', 10, 11, offering1.id, prof1.id, client2.id, 'SCHEDULED');
  await createSessionSeed('2026-07-14T00:00:00Z', 14, 15, offering1.id, prof2.id, client1.id, 'CONFIRMED');

  console.log(`Created 2 workspaces, 4 users, and several sessions for Workspace 1.`);
  console.log('Emails:');
  console.log('- ana@fisiopilates.com');
  console.log('- bruno@fisiopilates.com');
  console.log('- carla@corpoativo.com');
  console.log('- daniel@corpoativo.com');
  console.log('Senha para todos: 123456');
  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

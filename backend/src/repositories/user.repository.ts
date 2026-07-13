import { prisma } from '../lib/prisma';

export class UserRepository {
  async findByEmail(email: string) {
    return prisma.user.findUnique({
      where: { email },
      include: { workspaces: { include: { workspace: true } } }
    });
  }

  async createUserWithWorkspace(name: string, email: string, passwordHash: string, workspaceName: string) {
    return prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: { name, email, passwordHash },
      });

      const workspace = await tx.workspace.create({
        data: { name: workspaceName, email },
      });

      await tx.userWorkspace.create({
        data: { userId: user.id, workspaceId: workspace.id, role: 'OWNER' }
      });

      return { user, workspace };
    });
  }
}

import { UserRepository } from '../repositories/user.repository';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export class AuthService {
  constructor(private userRepository: UserRepository) {}

  async register(name: string, email: string, passwordString: string, workspaceName: string) {
    const existing = await this.userRepository.findByEmail(email);
    if (existing) {
      throw new Error('E-mail já está em uso.');
    }

    const passwordHash = await bcrypt.hash(passwordString, 10);

    return this.userRepository.createUserWithWorkspace(name, email, passwordHash, workspaceName);
  }

  async login(email: string, passwordString: string) {
    const user = await this.userRepository.findByEmail(email);
    if (!user) {
      throw new Error('Credenciais inválidas.');
    }

    const isValid = await bcrypt.compare(passwordString, user.passwordHash);
    if (!isValid) {
      throw new Error('Credenciais inválidas.');
    }

    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET || 'super-secret-key-for-dev',
      { expiresIn: '7d' }
    );

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        workspaces: user.workspaces.map(uw => uw.workspace)
      }
    };
  }
}

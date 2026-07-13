import { UserRepository } from '../repositories/user.repository';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'super-secret-key-for-dev';

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async registerUser(data: { name: string; email: string; passwordRaw: string; workspaceId: string; role?: string }) {
    const existing = await this.userRepository.findByEmail(data.email);
    if (existing) {
      throw new Error('Email already registered.');
    }

    const passwordHash = await bcrypt.hash(data.passwordRaw, 10);

    const user = await this.userRepository.create({
      name: data.name,
      email: data.email,
      passwordHash,
      status: 'ACTIVE'
    });

    await this.userRepository.createUserWorkspace({
      userId: user.id,
      workspaceId: data.workspaceId,
      role: data.role || 'PROFESSIONAL',
      isOwner: data.role === 'OWNER'
    });

    return user;
  }

  async login(email: string, passwordRaw: string) {
    const user = await this.userRepository.findByEmail(email);
    if (!user || user.status !== 'ACTIVE') {
      throw new Error('Invalid credentials or inactive user.');
    }

    const match = await bcrypt.compare(passwordRaw, user.passwordHash);
    if (!match) {
      throw new Error('Invalid credentials.');
    }

    await this.userRepository.updateLastLogin(user.id);

    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1d' });
    
    return { user, token };
  }
}

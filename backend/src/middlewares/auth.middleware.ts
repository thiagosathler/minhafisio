import { FastifyRequest, FastifyReply } from 'fastify';
import jwt from 'jsonwebtoken';

export async function authenticate(req: FastifyRequest, reply: FastifyReply) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return reply.status(401).send({ error: 'No token provided' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'super-secret-key-for-dev') as any;
    (req as any).user = { id: decoded.userId }; // Map userId from payload to id
  } catch (error) {
    return reply.status(401).send({ error: 'Invalid token' });
  }
}

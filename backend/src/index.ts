import Fastify from 'fastify';
import cors from '@fastify/cors';
import { workspaceRoutes } from './routes/workspace.routes';
import { personRoutes } from './routes/person.routes';
import { catalogRoutes } from './routes/catalog.routes';
import { resourceRoutes } from './routes/resource.routes';
import { scheduleRoutes } from './routes/schedule.routes';
import { financialRoutes } from './routes/financial.routes';
import { systemRoutes } from './routes/system.routes';
import { authRoutes } from './routes/auth.routes';
import dotenv from 'dotenv';

dotenv.config();

const fastify = Fastify({ logger: true });

async function build() {
  await fastify.register(cors, { origin: true });
  
  // Registrar rotas
  fastify.register(workspaceRoutes, { prefix: '/api' });
  fastify.register(personRoutes, { prefix: '/api' });
  fastify.register(catalogRoutes, { prefix: '/api' });
  fastify.register(resourceRoutes, { prefix: '/api' });
  fastify.register(scheduleRoutes, { prefix: '/api' });
  fastify.register(financialRoutes, { prefix: '/api' });
  fastify.register(systemRoutes, { prefix: '/api' });
  fastify.register(authRoutes, { prefix: '/api' });

  return fastify;
}

build().then((app) => {
  app.listen({ port: 3333, host: '0.0.0.0' }, (err, address) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    console.log(`Server listening at ${address}`);
  });
});

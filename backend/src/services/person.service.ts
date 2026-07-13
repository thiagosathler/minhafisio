import { PersonRepository } from '../repositories/person.repository';

export class PersonService {
  constructor(private personRepository: PersonRepository) {}

  async createPerson(data: {
    workspaceId: string;
    name: string;
    cpf?: string;
    email?: string;
    isProfessional?: boolean;
    isClient?: boolean;
    crefito?: string;
  }) {
    if (!data.name) {
      throw new Error('Name is required.');
    }
    if (!data.workspaceId) {
      throw new Error('Workspace is required.');
    }

    const personCreateInput: any = {
      workspace: { connect: { id: data.workspaceId } },
      name: data.name,
      cpf: data.cpf,
      email: data.email,
    };

    if (data.isProfessional) {
      personCreateInput.professional = {
        create: { crefito: data.crefito }
      };
    }

    if (data.isClient) {
      personCreateInput.client = {
        create: {}
      };
    }

    return this.personRepository.create(personCreateInput);
  }

  async getPersonsByWorkspace(workspaceId: string, isClient?: boolean, isProfessional?: boolean) {
    return this.personRepository.findAllByWorkspace(workspaceId, isClient, isProfessional);
  }
}

import type { User, UserProfile } from '@mono/types';
import type { createApiClient } from '../client';

export function createUsersService(client: ReturnType<typeof createApiClient>) {
  return {
    me: () => client.request<UserProfile>('/api/v1/users/me'),

    getById: (id: string) => client.request<User>(`/api/v1/users/${id}`),
  };
}

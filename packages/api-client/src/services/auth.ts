import type { AuthTokens, LoginRequest, RegisterRequest } from '@mono/types';
import type { createApiClient } from '../client';

export function createAuthService(client: ReturnType<typeof createApiClient>) {
  return {
    login: (data: LoginRequest) =>
      client.request<AuthTokens>('/api/v1/auth/login', {
        method: 'POST',
        body: JSON.stringify(data),
      }),

    register: (data: RegisterRequest) =>
      client.request<AuthTokens>('/api/v1/auth/register', {
        method: 'POST',
        body: JSON.stringify(data),
      }),

    refresh: (refreshToken: string) =>
      client.request<AuthTokens>('/api/v1/auth/refresh', {
        method: 'POST',
        body: JSON.stringify({ refreshToken }),
      }),

    logout: () =>
      client.request<void>('/api/v1/auth/logout', { method: 'POST' }),
  };
}

// Shared types across the entire monorepo.
// Import in apps/web: import type { User } from '@mono/types'
// Import in packages: import type { User } from '@mono/types'

export type { AuthTokens, LoginRequest, RegisterRequest } from './auth';
export type { ApiError, ApiResponse, PaginatedResponse } from './common';
export type { User, UserProfile } from './user';


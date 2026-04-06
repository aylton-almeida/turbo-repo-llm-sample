export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: string;
  updatedAt: string;
}

export interface UserProfile extends User {
  avatarUrl?: string;
  bio?: string;
}

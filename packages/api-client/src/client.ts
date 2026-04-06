export interface ApiClientConfig {
  baseUrl: string;
  getToken?: () => string | null;
}

export function createApiClient(config: ApiClientConfig) {
  async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
    const token = config.getToken?.();
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...(options.headers as Record<string, string>),
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    const response = await fetch(`${config.baseUrl}${path}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const errorBody = (await response.json().catch(() => ({}))) as Record<string, unknown>;
      const detail = errorBody['detail'] as Record<string, unknown> | undefined;
      throw new Error(
        String(detail?.['message'] ?? `HTTP ${response.status}: ${response.statusText}`),
      );
    }

    return response.json() as Promise<T>;
  }

  return { request };
}

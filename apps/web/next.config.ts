import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  transpilePackages: ['@mono/ui', '@mono/utils', '@mono/types', '@mono/api-client'],
};

export default nextConfig;

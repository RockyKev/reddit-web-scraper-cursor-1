import type { DigestData } from './frontend-types';

let apiFetchTime = 0;
let lastFetchTime: Date | null = null;

export async function fetchDigest(date?: Date): Promise<DigestData> {
  // Debug environment variables
  console.log('Environment in API:', {
    VITE_API_URL: import.meta.env.VITE_API_URL,
    NODE_ENV: import.meta.env.NODE_ENV,
    MODE: import.meta.env.MODE
  });

  const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
  const dateParam = date ? `?date=${date.toISOString().split('T')[0]}` : '';
  const fullUrl = `${apiUrl}/api/digest${dateParam}`;
  console.log('Making API request to:', fullUrl);
  
  const fetchStartTime = performance.now();
  try {
    const response = await fetch(fullUrl);
    console.log('API response status:', response.status);
    if (!response.ok) {
      throw new Error(`Failed to fetch digest data: ${response.status} ${response.statusText}`);
    }
    const data = await response.json();
    apiFetchTime = performance.now() - fetchStartTime;
    lastFetchTime = new Date();
    console.log('Received API data:', data);
    return data;
  } catch (error) {
    console.error('Error fetching digest:', error);
    throw error;
  }
}

export function getApiFetchTime(): number {
  return apiFetchTime;
}

export function getLastFetchTime(): Date | null {
  return lastFetchTime;
} 
import type { DigestData } from './frontend-types';

let apiFetchTime = 0;
let lastFetchTime: Date | null = null;

export async function fetchDigest(date?: Date): Promise<DigestData> {
  const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
  const dateParam = date ? `?date=${date.toISOString().split('T')[0]}` : '';
  const fullUrl = `${apiUrl}/api/digest${dateParam}`;
  
  const fetchStartTime = performance.now();
  try {
    const response = await fetch(fullUrl);
    if (!response.ok) {
      throw new Error(`Failed to fetch digest data: ${response.status} ${response.statusText}`);
    }
    const data = await response.json();
    apiFetchTime = performance.now() - fetchStartTime;
    lastFetchTime = new Date();
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
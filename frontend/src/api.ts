import type { DigestData } from './frontend-types';

let apiFetchTime = 0;
let lastFetchTime: Date | null = null;

export async function fetchDigest(date?: Date): Promise<DigestData> {
  const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
  const dateParam = date ? `?date=${date.toISOString().split('T')[0]}` : '';
  const fullUrl = `${apiUrl}/api/digest${dateParam}`;
  
  const fetchStartTime = performance.now();
  try {
    const response = await fetch(fullUrl, {
      signal: AbortSignal.timeout(10000)
    });
    
    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Server error (${response.status}): ${errorText || response.statusText}`);
    }
    
    const data = await response.json();
    apiFetchTime = performance.now() - fetchStartTime;
    lastFetchTime = new Date();
    return data;
  } catch (error) {
    if (error instanceof TypeError && error.message === 'Failed to fetch') {
      throw new Error(`Cannot connect to API server at ${apiUrl}. Please check if the server is running and accessible.`);
    }
    if (error instanceof DOMException && error.name === 'AbortError') {
      throw new Error('Request timed out. The server took too long to respond.');
    }
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
import pkg from 'express';
const { Router } = pkg;
import { getMockDigest } from '../services/mock-data.service.js';
import { DigestService } from '../services/digest-service.js';

const router = Router();
const digestService = new DigestService();

// GET /api/digest
router.get('/digest', async (req, res) => {
  try {
    // Use mock data if USE_MOCK_DATA is true, otherwise use real database
    const useMockData = process.env.USE_MOCK_DATA === 'true';
    const digest = useMockData ? await getMockDigest() : await digestService.getDigest();
    res.json(digest);
  } catch (error) {
    console.error('Error fetching digest:', error);
    if (error instanceof Error) {
      console.error('Error details:', {
        message: error.message,
        stack: error.stack,
        name: error.name
      });
    }
    res.status(500).json({ 
      error: 'Failed to fetch digest data',
      details: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

export default router; 
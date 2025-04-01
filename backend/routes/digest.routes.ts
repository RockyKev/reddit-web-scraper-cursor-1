import pkg from 'express';
const { Router } = pkg;
import { getMockDigest } from '../services/mock-data.service.js';
import { DigestService } from '../services/digest-service.js';
import { logger } from '../utils/logger.js';

const router = Router();
const digestService = new DigestService();

// GET /api/digest
router.get('/digest', async (req, res) => {
  try {
    // Check if we should use mock data
    const useMockData = process.env.USE_MOCK_DATA === 'true';
    
    if (useMockData) {
      const mockDigest = await getMockDigest();
      return res.json(mockDigest);
    }

    // Get real data
    const digest = await digestService.getDigest();
    return res.json(digest);
  } catch (error) {
    logger.error('Error in digest route:', error);
    if (error instanceof Error) {
      logger.error('Error details:', {
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
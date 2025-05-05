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
    // Get date from query parameter or use current date
    const date = req.query.date as string || new Date().toISOString().split('T')[0];
    logger.info('Fetching digest for date:', date);
    logger.info('Request query params:', req.query);

    // Check if we should use mock data
    const useMockData = process.env.USE_MOCK_DATA === 'true';
    logger.info('Using mock data:', useMockData);
    
    if (useMockData) {
      const mockDigest = await getMockDigest(date);
      return res.json(mockDigest);
    }

    // Get real data
    const digest = await digestService.getDigest(date);
    logger.info('Digest response date:', digest.date);
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
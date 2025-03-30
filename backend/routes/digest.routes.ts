import pkg from 'express';
const { Router } = pkg;
import { getMockDigest } from '../services/mock-data.service.ts';

const router = Router();

// GET /api/digest
router.get('/digest', async (req, res) => {
  try {
    const digest = await getMockDigest();
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
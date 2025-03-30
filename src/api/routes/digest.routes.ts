import { Router } from 'express';
import { getMockDigest } from '../../services/mock-data.service.js';

const router = Router();

router.get('/digest', (req, res) => {
  try {
    const digest = getMockDigest();
    res.json(digest);
  } catch (error) {
    console.error('Error serving mock digest:', error);
    res.status(500).json({ error: 'Failed to serve digest' });
  }
});

export default router; 
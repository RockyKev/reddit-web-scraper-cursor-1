import { Router, Request, Response } from 'express';
import { DigestService } from '../../services/digest.service';

const router = Router();
const digestService = new DigestService();

interface DigestError extends Error {
  code?: string;
}

router.get('/', async (req: Request, res: Response) => {
  try {
    const { date } = req.query;
    
    // Validate date format if provided
    if (date && typeof date === 'string') {
      const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
      if (!dateRegex.test(date)) {
        return res.status(400).json({
          error: {
            code: 'INVALID_DATE_FORMAT',
            message: 'Date must be in YYYY-MM-DD format'
          }
        });
      }
    }

    const digest = await digestService.getDigest(date as string);
    res.json(digest);
  } catch (error) {
    const digestError = error as DigestError;
    
    if (digestError.message === 'No data found for the specified date') {
      return res.status(404).json({
        error: {
          code: 'NOT_FOUND',
          message: 'No digest data found for the specified date'
        }
      });
    }

    console.error('Error fetching digest:', digestError);
    res.status(500).json({
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'An error occurred while fetching the digest'
      }
    });
  }
});

export default router; 
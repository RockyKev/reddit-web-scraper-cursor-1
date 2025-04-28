import 'dotenv/config';
import { ScoreCalculator } from '../services/score-calculator.js';
import { logger } from '../utils/logger.js';

async function calculateScores(date: string) {
  try {
    const calculator = new ScoreCalculator();
    await calculator.calculateScoresForDate(date);
  } catch (error) {
    logger.error('Error calculating scores:', error);
    process.exit(1);
  }
}

// Get date from command line argument or use today's date
const date = process.argv[2] || new Date().toISOString().split('T')[0];
calculateScores(date); 
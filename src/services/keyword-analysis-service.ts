import { RedditPost, RedditComment } from '../types/reddit';
import { KeywordExtractor } from './keyword-extractor';
import { logger } from '../utils/logger';

export class KeywordAnalysisService {
  private keywordExtractor: KeywordExtractor;

  constructor() {
    this.keywordExtractor = new KeywordExtractor();
  }

  /**
   * Extract keywords from a post and its top comments
   * @param post The Reddit post
   * @param comments Array of all comments on the post
   * @returns Array of keywords
   */
  public extractKeywordsFromPost(post: RedditPost, comments: RedditComment[]): string[] {
    try {
      // Get top comments based on score
      const topComments = this.getTopComments(comments);
      
      // Extract keywords from post and top comments
      return this.keywordExtractor.extractKeywords(post, topComments);
    } catch (error) {
      logger.error('Error extracting keywords:', error);
      return [];
    }
  }

  /**
   * Get top comments based on score
   * @param comments Array of all comments
   * @returns Array of top comments
   */
  private getTopComments(comments: RedditComment[]): RedditComment[] {
    // Sort comments by score in descending order
    const sortedComments = [...comments].sort((a, b) => b.score - a.score);
    
    // If we have fewer comments than TOP_COMMENTERS_PER_POST, return all of them
    if (sortedComments.length <= 5) {
      return sortedComments;
    }

    // Get the top 5 comments
    return sortedComments.slice(0, 5);
  }
} 
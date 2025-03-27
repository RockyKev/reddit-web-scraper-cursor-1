import { stopwords, TfIdf } from 'natural';
import { logger } from '../utils/logger';

interface WeightedKeyword {
  word: string;
  relevance: number;
}

export class KeywordExtractor {
  private tfidf: TfIdf;

  constructor() {
    this.tfidf = new TfIdf();
  }

  /**
   * Extracts keywords from text using TF-IDF and frequency analysis
   * @param text The text to extract keywords from
   * @param maxKeywords Maximum number of keywords to return
   * @returns Array of weighted keywords
   */
  async extractKeywords(text: string, maxKeywords: number = 15): Promise<WeightedKeyword[]> {
    try {
      // For single document, we'll use a simpler frequency-based approach
      const tokens = this.tokenize(text);
      const wordFreq = new Map<string, number>();

      // Count word frequencies
      tokens.forEach(word => {
        wordFreq.set(word, (wordFreq.get(word) || 0) + 1);
      });

      // Convert to array and sort by frequency
      const keywords = Array.from(wordFreq.entries())
        .map(([word, frequency]) => ({ 
          word, 
          relevance: frequency / tokens.length // Normalize by document length
        }))
        .sort((a, b) => {
          // Sort by relevance first, then alphabetically for equal relevance
          if (b.relevance !== a.relevance) {
            return b.relevance - a.relevance;
          }
          return a.word.localeCompare(b.word);
        })
        .slice(0, maxKeywords);

      return keywords;
    } catch (error) {
      logger.error('Error extracting keywords:', error);
      throw error;
    }
  }

  /**
   * Extracts keywords from multiple texts and combines their relevance scores
   * @param texts Array of texts to extract keywords from
   * @param maxKeywords Maximum number of keywords to return
   * @returns Array of weighted keywords
   */
  async extractKeywordsFromMultiple(texts: string[], maxKeywords: number = 15): Promise<WeightedKeyword[]> {
    try {
      if (texts.length === 0) {
        return [];
      }

      // Reset TF-IDF
      this.tfidf = new TfIdf();

      // Process each text
      const nonEmptyTexts = texts.filter(text => text.trim().length > 0);
      if (nonEmptyTexts.length === 0) {
        return [];
      }

      // Add documents to TF-IDF
      nonEmptyTexts.forEach(text => {
        const tokens = this.tokenize(text);
        if (tokens.length > 0) {
          this.tfidf.addDocument(tokens);
        }
      });

      // Get combined TF-IDF scores
      const termScores = new Map<string, number>();
      const allTokens = new Set<string>();

      // Collect all unique tokens
      nonEmptyTexts.forEach(text => {
        const tokens = this.tokenize(text);
        tokens.forEach(token => allTokens.add(token));
      });

      // Calculate scores for each term
      allTokens.forEach(term => {
        if (!stopwords.includes(term)) {
          let totalScore = 0;
          // Get TF-IDF score for each document
          for (let i = 0; i < nonEmptyTexts.length; i++) {
            totalScore += this.tfidf.tfidf(term, i);
          }
          termScores.set(term, totalScore);
        }
      });

      // Convert to array and sort by relevance
      const keywords = Array.from(termScores.entries())
        .map(([word, relevance]) => ({ word, relevance }))
        .sort((a, b) => {
          // Sort by relevance first, then alphabetically for equal relevance
          if (b.relevance !== a.relevance) {
            return b.relevance - a.relevance;
          }
          return a.word.localeCompare(b.word);
        })
        .slice(0, maxKeywords);

      return keywords;
    } catch (error) {
      logger.error('Error extracting keywords from multiple texts:', error);
      throw error;
    }
  }

  /**
   * Tokenizes text and removes stop words
   * @param text The text to tokenize
   * @returns Array of tokens
   */
  private tokenize(text: string): string[] {
    // Convert to lowercase and split into words
    const words = text.toLowerCase()
      .split(/\s+/)
      .map(word => word.replace(/[^a-z]/g, '')) // Remove non-alphabetic chars from each word
      .filter(word => word.length > 0); // Remove empty strings
    
    // Remove stop words and short words
    return words.filter(word => 
      word.length > 2 && 
      !stopwords.includes(word) &&
      /^[a-z]+$/.test(word) // Only keep alphabetic words
    );
  }
} 
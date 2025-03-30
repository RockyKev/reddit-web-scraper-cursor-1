import { RedditPost, RedditComment } from '../types/reddit';
import { WordTokenizer, TfIdf } from 'natural';

// Common English stop words to filter out
const STOP_WORDS = new Set([
  'the', 'be', 'to', 'of', 'and', 'a', 'in', 'that', 'have', 'i',
  'it', 'for', 'not', 'on', 'with', 'he', 'as', 'you', 'do', 'at',
  'this', 'but', 'his', 'by', 'from', 'they', 'we', 'say', 'her', 'she',
  'or', 'an', 'will', 'my', 'one', 'all', 'would', 'there', 'their', 'what',
  'so', 'up', 'out', 'if', 'about', 'who', 'get', 'which', 'go', 'me',
  'when', 'make', 'can', 'like', 'time', 'no', 'just', 'him', 'know', 'take',
  'people', 'into', 'year', 'your', 'good', 'some', 'could', 'them', 'see', 'other',
  'than', 'then', 'now', 'look', 'only', 'come', 'its', 'over', 'think', 'also',
  'back', 'after', 'use', 'two', 'how', 'our', 'work', 'first', 'well', 'way',
  'even', 'new', 'want', 'because', 'any', 'these', 'give', 'day', 'most', 'us'
]);

export class KeywordExtractor {
  private tokenizer: WordTokenizer;
  private tfidf: TfIdf;

  constructor() {
    this.tokenizer = new WordTokenizer();
    this.tfidf = new TfIdf();
  }

  /**
   * Extract keywords from a post and its comments
   * @param post The Reddit post
   * @param comments Array of comments on the post
   * @returns Array of keywords
   */
  public extractKeywords(post: RedditPost, comments: RedditComment[]): string[] {
    // Combine post content and comments
    const text = this.combineText(post, comments);
    
    // Add document to TF-IDF
    this.tfidf.addDocument(text);
    
    // Get top terms
    const terms: string[] = [];
    this.tfidf.listTerms(0 /* document index */)
      .slice(0, 10)  // Get top 10 terms
      .forEach(item => terms.push(item.term));
    
    return terms;
  }

  /**
   * Combine post content and comments into a single text
   */
  private combineText(post: RedditPost, comments: RedditComment[]): string {
    const texts = [
      post.title,
      post.content || '',
      ...comments.map(c => c.content)
    ];
    return texts.join(' ').toLowerCase();
  }

  /**
   * Count word frequencies in text
   */
  private countWordFrequencies(text: string): Map<string, number> {
    const wordFreq = new Map<string, number>();
    
    // Split into words and count frequencies
    const words = text.split(/\W+/);
    for (const word of words) {
      // Skip empty strings, numbers, and stop words
      if (word.length < 3 || /^\d+$/.test(word) || STOP_WORDS.has(word)) {
        continue;
      }
      
      wordFreq.set(word, (wordFreq.get(word) || 0) + 1);
    }
    
    return wordFreq;
  }

  /**
   * Get top N most frequent words
   */
  private getTopWords(wordFreq: Map<string, number>, n: number): string[] {
    return Array.from(wordFreq.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, n)
      .map(([word]) => word);
  }
} 
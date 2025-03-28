import { KeywordExtractor } from '../../src/services/keyword-extractor';

describe('KeywordExtractor', () => {
  let extractor: KeywordExtractor;

  beforeEach(() => {
    extractor = new KeywordExtractor();
  });

  describe('extractKeywords (single document)', () => {
    it('should extract keywords from a single document', async () => {
      const text = 'The quick brown fox jumps over the lazy dog. The fox is quick and brown.';
      const keywords = await extractor.extractKeywords(text);

      // Check that we have the expected keywords
      const expectedWords = ['brown', 'fox', 'quick', 'jumps', 'lazy', 'dog'];
      keywords.forEach(k => {
        expect(expectedWords).toContain(k.word);
      });

      // Check that words with higher frequency have higher relevance
      const foxKeyword = keywords.find(k => k.word === 'fox');
      const jumpKeyword = keywords.find(k => k.word === 'jumps');
      expect(foxKeyword).toBeDefined();
      expect(jumpKeyword).toBeDefined();
      expect(foxKeyword!.relevance).toBeGreaterThan(jumpKeyword!.relevance);
    });

    it('should respect maxKeywords parameter', async () => {
      const text = 'The quick brown fox jumps over the lazy dog. The fox is quick and brown.';
      const keywords = await extractor.extractKeywords(text, 3);

      expect(keywords).toHaveLength(3);
      expect(keywords.map(k => k.word)).toEqual(['brown', 'fox', 'quick']);
    });

    it('should handle empty text', async () => {
      const keywords = await extractor.extractKeywords('');
      expect(keywords).toHaveLength(0);
    });

    it('should handle text with only stop words', async () => {
      const text = 'the and or but in on at to for of with by';
      const keywords = await extractor.extractKeywords(text);
      expect(keywords).toHaveLength(0);
    });

    it('should handle text with numbers and special characters', async () => {
      const text = 'The quick brown fox123 jumps! over the lazy dog.';
      const keywords = await extractor.extractKeywords(text);

      // Check that we have the expected keywords
      const expectedWords = ['quick', 'brown', 'fox', 'jumps', 'lazy', 'dog'];
      const receivedWords = keywords.map(k => k.word);
      expectedWords.forEach(word => {
        expect(receivedWords).toContain(word);
      });

      // Check that non-alphabetic words are removed
      expect(keywords.some(k => /[^a-z]/.test(k.word))).toBe(false);
    });
  });

  describe('extractKeywordsFromMultiple (multiple documents)', () => {
    it('should extract keywords from multiple documents', async () => {
      const texts = [
        'The quick brown fox jumps over the lazy dog.',
        'The fox is quick and brown.',
        'A lazy dog sleeps in the sun.'
      ];
      const keywords = await extractor.extractKeywordsFromMultiple(texts);

      // Check that we have the expected keywords
      const expectedWords = ['quick', 'brown', 'fox', 'lazy', 'dog', 'sleeps', 'sun'];
      const receivedWords = keywords.map(k => k.word);
      expectedWords.forEach(word => {
        expect(receivedWords).toContain(word);
      });

      // Check that words appearing in multiple documents have higher relevance
      const foxKeyword = keywords.find(k => k.word === 'fox');
      const sleepsKeyword = keywords.find(k => k.word === 'sleeps');
      expect(foxKeyword).toBeDefined();
      expect(sleepsKeyword).toBeDefined();
      expect(foxKeyword!.relevance).toBeGreaterThan(sleepsKeyword!.relevance);
    });

    it('should respect maxKeywords parameter', async () => {
      const texts = [
        'The quick brown fox jumps over the lazy dog.',
        'The fox is quick and brown.',
        'A lazy dog sleeps in the sun.'
      ];
      const keywords = await extractor.extractKeywordsFromMultiple(texts, 3);

      expect(keywords).toHaveLength(3);
      // Words appearing in multiple documents should be ranked higher
      expect(keywords.map(k => k.word)).toEqual(['brown', 'dog', 'fox']);
    });

    it('should handle empty array of texts', async () => {
      const keywords = await extractor.extractKeywordsFromMultiple([]);
      expect(keywords).toHaveLength(0);
    });

    it('should handle array with empty strings', async () => {
      const texts = ['', 'The quick brown fox', ''];
      const keywords = await extractor.extractKeywordsFromMultiple(texts);

      // Check that we have the expected keywords
      const expectedWords = ['quick', 'brown', 'fox'];
      keywords.forEach(k => {
        expect(expectedWords).toContain(k.word);
      });
    });

    it('should handle texts with different lengths', async () => {
      const texts = [
        'The quick brown fox jumps over the lazy dog.',
        'The fox is quick.',
        'A lazy dog sleeps in the sun.'
      ];
      const keywords = await extractor.extractKeywordsFromMultiple(texts);

      // Check that we have the expected keywords
      const expectedWords = ['quick', 'brown', 'fox', 'lazy', 'dog', 'sleeps', 'sun'];
      const receivedWords = keywords.map(k => k.word);
      expectedWords.forEach(word => {
        expect(receivedWords).toContain(word);
      });

      // Check that words appearing in multiple documents have higher relevance
      const foxKeyword = keywords.find(k => k.word === 'fox');
      const sunKeyword = keywords.find(k => k.word === 'sun');
      expect(foxKeyword).toBeDefined();
      expect(sunKeyword).toBeDefined();
      expect(foxKeyword!.relevance).toBeGreaterThan(sunKeyword!.relevance);
    });
  });

  describe('tokenize (private method)', () => {
    it('should convert text to lowercase', () => {
      const text = 'The Quick BROWN Fox';
      const tokens = (extractor as any).tokenize(text);
      expect(tokens).toEqual(['quick', 'brown', 'fox']);
    });

    it('should remove stop words', () => {
      const text = 'the quick brown fox jumps over the lazy dog';
      const tokens = (extractor as any).tokenize(text);
      expect(tokens).toEqual(['quick', 'brown', 'fox', 'jumps', 'lazy', 'dog']);
    });

    it('should remove short words', () => {
      const text = 'a the cat and dog';
      const tokens = (extractor as any).tokenize(text);
      expect(tokens).toEqual(['cat', 'dog']);
    });

    it('should remove non-alphabetic words', () => {
      const text = 'cat123 dog! cat';
      const tokens = (extractor as any).tokenize(text);
      expect(tokens).toEqual(['cat', 'dog', 'cat']);
    });
  });
}); 
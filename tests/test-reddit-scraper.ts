import { RedditScraper } from '../services/reddit-scraper.ts';

async function testScraper() {
  try {
    // Create a scraper instance for r/Portland
    const scraper = new RedditScraper('Portland');

    console.log('Testing RedditScraper for r/Portland...\n');

    // Test getting posts
    console.log('Fetching latest posts...');
    const posts = await scraper.getPosts(5);
    console.log(`Found ${posts.length} posts:`);
    posts.forEach((post, index) => {
      console.log(`\n${index + 1}. ${post.title}`);
      console.log(`   Score: ${post.score}`);
      console.log(`   Comments: ${post.commentCount}`);
      console.log(`   URL: ${post.url}`);
    });

    // Test getting comments for the first post
    if (posts.length > 0) {
      console.log('\nFetching comments for first post...');
      const comments = await scraper.getComments(posts[0].id);
      console.log(`Found ${comments.length} comments:`);
      comments.slice(0, 3).forEach((comment, index) => {
        console.log(`\n${index + 1}. Comment by ${comment.author}:`);
        console.log(`   Score: ${comment.score}`);
        console.log(`   Content: ${comment.content.substring(0, 100)}...`);
      });
    }

    // Test search
    console.log('\nTesting search functionality...');
    const searchResults = await scraper.searchSubreddit('food', 3);
    console.log(`Found ${searchResults.length} posts about food:`);
    searchResults.forEach((post, index) => {
      console.log(`\n${index + 1}. ${post.title}`);
      console.log(`   Score: ${post.score}`);
    });

  } catch (error) {
    console.error('Error during testing:', error);
  }
}

// Run the test
testScraper(); 
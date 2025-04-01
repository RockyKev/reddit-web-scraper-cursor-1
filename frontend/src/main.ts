import './style.css';

interface Post {
  id: string;
  subreddit_id: string;
  reddit_id: string;
  title: string;
  selftext: string;
  url: string;
  score: number;
  num_comments: number;
  created_at: string;
  updated_at: string;
  reddit_created_at: string;
  is_archived: boolean;
  is_locked: boolean;
  post_type: string;
  daily_rank: number;
  daily_score: number;
  author_id: string;
  keywords: string[];
  author_score: number;
  top_commenters: Array<{
    username: string;
    contribution_score: number;
  }>;
  summary: string | null;
  sentiment: any | null;
}

interface DigestData {
  date: string;
  summary: {
    total_posts: number;
    total_comments: number;
    top_subreddits: string[];
  };
  top_posts: Post[];
}

async function fetchDigest(): Promise<DigestData> {
  const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
  const response = await fetch(`${apiUrl}/api/digest`);
  if (!response.ok) {
    throw new Error('Failed to fetch digest data');
  }
  return response.json();
}

function formatDate(dateString: string): string {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

function createPostCard(post: Post): HTMLElement {
  const card = document.createElement('div');
  card.className = 'bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow duration-200';
  
  const header = document.createElement('div');
  header.className = 'flex justify-between items-start mb-4';
  
  const titleContainer = document.createElement('div');
  titleContainer.className = 'flex-1';
  
  const title = document.createElement('h2');
  title.className = 'text-xl font-semibold text-gray-800 mb-2';
  title.textContent = post.title;
  
  const subreddit = document.createElement('span');
  subreddit.className = 'text-sm text-blue-600 font-medium';
  subreddit.textContent = `r/${post.subreddit_id}`;
  
  titleContainer.appendChild(title);
  titleContainer.appendChild(subreddit);
  
  const score = document.createElement('div');
  score.className = 'text-sm text-gray-600';
  score.textContent = `Score: ${post.score} | Comments: ${post.num_comments}`;
  
  header.appendChild(titleContainer);
  header.appendChild(score);
  
  const content = document.createElement('p');
  content.className = 'text-gray-700 mb-4 line-clamp-3';
  content.textContent = post.selftext;
  
  const footer = document.createElement('div');
  footer.className = 'flex justify-between items-center text-sm text-gray-500';
  
  const author = document.createElement('span');
  author.textContent = `Posted by u/${post.author_id}`;
  
  const link = document.createElement('a');
  link.href = post.url;
  link.target = '_blank';
  link.className = 'text-blue-600 hover:text-blue-800';
  link.textContent = 'View on Reddit';
  
  footer.appendChild(author);
  footer.appendChild(link);
  
  card.appendChild(header);
  card.appendChild(content);
  card.appendChild(footer);
  
  return card;
}

async function initializeApp() {
  try {
    const digest = await fetchDigest();
    
    // Update date header
    const dateHeader = document.getElementById('date-header');
    if (dateHeader) {
      dateHeader.textContent = formatDate(digest.date);
      dateHeader.className = 'text-3xl font-bold mb-6 text-gray-800';
    }
    
    // Update summary
    const summary = document.getElementById('summary');
    if (summary) {
      summary.innerHTML = `
        <div class="bg-blue-50 rounded-lg p-6 mb-8">
          <h2 class="text-xl font-semibold text-gray-800 mb-4">Daily Summary</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="bg-white p-4 rounded-lg shadow">
              <div class="text-2xl font-bold text-blue-600">${digest.summary.total_posts}</div>
              <div class="text-gray-600">Total Posts</div>
            </div>
            <div class="bg-white p-4 rounded-lg shadow">
              <div class="text-2xl font-bold text-blue-600">${digest.summary.total_comments}</div>
              <div class="text-gray-600">Total Comments</div>
            </div>
            <div class="bg-white p-4 rounded-lg shadow">
              <div class="text-2xl font-bold text-blue-600">${digest.summary.top_subreddits.length}</div>
              <div class="text-gray-600">Top Subreddits</div>
            </div>
          </div>
        </div>
      `;
    }
    
    // Update posts
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      postsContainer.className = 'grid gap-6 md:grid-cols-2 lg:grid-cols-3';
      digest.top_posts.forEach(post => {
        postsContainer.appendChild(createPostCard(post));
      });
    }
  } catch (error) {
    console.error('Error initializing app:', error);
    const app = document.getElementById('app');
    if (app) {
      app.innerHTML = `
        <div class="bg-red-50 border border-red-200 rounded-lg p-6 text-red-700">
          <h2 class="text-xl font-semibold mb-2">Error Loading Data</h2>
          <p>Failed to load the digest data. Please try again later.</p>
        </div>
      `;
    }
  }
}

// Initialize the app when the DOM is loaded
document.addEventListener('DOMContentLoaded', initializeApp); 
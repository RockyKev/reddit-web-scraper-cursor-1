import './style.css';

interface Post {
  id: string;
  subreddit_id: string;
  reddit_id: string;
  title: string;
  content: string;
  permalink: string;
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
  author: {
    username: string;
    reddit_id: string;
    contribution_score: number;
  };
  keywords: string[];
  top_commenters: Array<{
    username: string;
    contribution_score: number;
  }>;
  summary: string | null;
  sentiment: any | null;
  subreddit: string;
}

interface DigestData {
  date: string;
  summary: {
    total_posts: number;
    total_comments: number;
    top_subreddits: Array<{
      name: string;
      post_count: number;
    }>;
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

function getPostTypeIcon(postType: string): string {
  switch (postType) {
    case 'text':
      return '📝';
    case 'link':
      return '🔗';
    case 'hosted:video':
      return '🎥';
    default:
      return '📄';
  }
}

function createTitleSection(post: Post): HTMLElement {
  const titleContainer = document.createElement('div');
  titleContainer.className = 'flex-1';
  
  const title = document.createElement('h2');
  title.className = 'text-xl font-semibold text-gray-800 mb-2';
  
  // Add post type icon
  const postTypeIcon = document.createElement('span');
  postTypeIcon.className = 'mr-2';
  postTypeIcon.textContent = getPostTypeIcon(post.post_type);
  
  title.textContent = post.title;
  
  const titleLink = document.createElement('a');
  titleLink.href = `https://www.reddit.com${post.permalink}`;
  titleLink.target = '_blank';
  titleLink.className = 'hover:text-blue-600 transition-colors duration-200 flex';
  titleLink.appendChild(postTypeIcon);
  titleLink.appendChild(title);
  
  const subreddit = document.createElement('span');
  subreddit.className = 'text-sm text-blue-600 font-medium';
  subreddit.textContent = `r/${post.subreddit}`;
  
  titleContainer.appendChild(titleLink);
  titleContainer.appendChild(subreddit);
  
  return titleContainer;
}

function createScoreSection(post: Post): HTMLElement {
  const score = document.createElement('div');
  score.className = 'text-sm text-gray-600';
  score.textContent = `Score: ${post.score} | Comments: ${post.num_comments}`;
  return score;
}

function createKeywordsSection(post: Post): HTMLElement | null {
  if (!post.keywords?.length) return null;
  
  const container = document.createElement('div');
  container.className = 'mb-4 flex items-center';
  
  const label = document.createElement('div');
  label.className = 'text-sm font-medium text-gray-600 pr-1';
  label.textContent = 'Key Topics: ';
  
  const list = document.createElement('div');
  list.className = 'flex flex-wrap gap-2';
  
  post.keywords.forEach(keyword => {
    const tag = document.createElement('span');
    tag.className = 'px-2 py-1 bg-gray-100 text-gray-700 text-sm rounded-full';
    tag.textContent = keyword;
    list.appendChild(tag);
  });
  
  container.appendChild(label);
  container.appendChild(list);
  return container;
}

function createTopCommentersSection(post: Post): HTMLElement {
  const container = document.createElement('div');
  container.className = 'mt-2 text-sm text-gray-600 flex';
  
  const label = document.createElement('div');
  label.className = 'font-medium mb-1 pr-1';
  label.textContent = 'Top Commenters: ';
  
  const commentersList = document.createElement('div');
  commentersList.className = 'flex flex-wrap gap-2';
  
  post.top_commenters.forEach(commenter => {
    const commenterLink = document.createElement('a');
    commenterLink.href = `https://www.reddit.com/user/${commenter.username}/`;
    commenterLink.target = '_blank';
    commenterLink.className = 'hover:text-blue-600 transition-colors duration-200';
    commenterLink.textContent = `u/${commenter.username} (${commenter.contribution_score})`;
    commentersList.appendChild(commenterLink);
  });
  
  container.appendChild(label);
  container.appendChild(commentersList);
  return container;
}

function createPostedBySection(post: Post): HTMLElement {
  const footer = document.createElement('div');
  footer.className = 'flex justify-between items-center text-sm text-gray-500';
  
  const author = document.createElement('a');
  author.href = `https://www.reddit.com/user/${post.author.username}/`;
  author.target = '_blank';
  author.className = 'hover:text-blue-600 transition-colors duration-200';
  author.textContent = `Posted by u/${post.author.username} (${post.author.contribution_score})`;
  
  footer.appendChild(author);
  return footer;
}

function createPostCard(post: Post): HTMLElement {
  const card = document.createElement('div');
  card.className = 'bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow duration-200';
  
  const header = document.createElement('div');
  header.className = 'flex justify-between items-start mb-4 gap-12';
  header.appendChild(createTitleSection(post));
  header.appendChild(createScoreSection(post));
  header.appendChild(createPostedBySection(post));

  const content = document.createElement('p');
  content.className = 'text-gray-700 mb-4 line-clamp-3';
  content.textContent = post.content;
  
  card.appendChild(header);

  card.appendChild(content);
  
  const keywordsSection = createKeywordsSection(post);
  if (keywordsSection) {
    card.appendChild(keywordsSection);
  }
  
  card.appendChild(createTopCommentersSection(post));

  
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
              <div class="text-gray-600">Subreddits</div>
              <div class="mt-2 text-sm text-gray-600">
                ${digest.summary.top_subreddits.map(sub => `r/${sub.name} (${sub.post_count})`).join(', ')}
              </div>
            </div>
          </div>
        </div>
      `;
    }
    
    // Update posts
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      postsContainer.className = 'grid gap-6 md:grid-cols-1';
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
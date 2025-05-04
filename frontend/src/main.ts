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

let currentDate = new Date();
let pageLoadStartTime = performance.now();
let apiFetchTime = 0;
let lastFetchTime: Date | null = null;

async function fetchDigest(date?: Date): Promise<DigestData> {
  const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
  const dateParam = date ? `?date=${date.toISOString().split('T')[0]}` : '';
  const fullUrl = `${apiUrl}/api/digest${dateParam}`;
  console.log('Making API request to:', fullUrl);
  
  const fetchStartTime = performance.now();
  try {
    const response = await fetch(fullUrl);
    console.log('API response status:', response.status);
    if (!response.ok) {
      throw new Error(`Failed to fetch digest data: ${response.status} ${response.statusText}`);
    }
    const data = await response.json();
    apiFetchTime = performance.now() - fetchStartTime;
    lastFetchTime = new Date();
    console.log('Received API data:', data);
    return data;
  } catch (error) {
    console.error('Error fetching digest:', error);
    throw error;
  }
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

function createContentSection(post: Post): HTMLElement {
  const content = document.createElement('div');
  content.className = 'text-gray-700 mb-4';

  // Check if content is a URL
  if (post.content.startsWith('http')) {
    // For image posts, show thumbnail
    if (post.post_type === 'image') {
      const img = document.createElement('img');
      img.src = post.content;
      img.alt = post.title;
      img.className = 'w-24 h-24 object-cover rounded-lg';
      content.appendChild(img);
    } else {
      // For other URLs, create a clickable link
      const link = document.createElement('a');
      link.href = post.content;
      link.target = '_blank';
      link.className = 'text-blue-600 hover:text-blue-800 hover:underline';
      link.textContent = post.content;
      content.appendChild(link);
    }
  } else {
    // For text content, show as is
    content.textContent = post.content;
  }

  return content;
}

function createPostCard(post: Post): HTMLElement {
  const card = document.createElement('div');
  card.className = 'bg-white rounded-lg shadow-md py-2 px-8 hover:shadow-lg transition-shadow duration-200 relative';
  
  // Add rank indicator
  const rankIndicator = document.createElement('div');
  rankIndicator.className = 'absolute -left-2 -top-2 bg-blue-600 text-white rounded-full w-6 h-6 flex items-center justify-center font-bold text-sm z-10';
  rankIndicator.textContent = post.daily_rank.toString();
  card.appendChild(rankIndicator);
  
  const header = document.createElement('div');
  header.className = 'flex justify-between items-start mb-4 gap-12';
  header.appendChild(createTitleSection(post));
  header.appendChild(createScoreSection(post));
  header.appendChild(createPostedBySection(post));

  card.appendChild(header);
  card.appendChild(createContentSection(post));
  
  const keywordsSection = createKeywordsSection(post);
  if (keywordsSection) {
    card.appendChild(keywordsSection);
  }
  
  card.appendChild(createTopCommentersSection(post));
  
  return card;
}

async function updateUI(date?: Date) {
  console.log('Updating UI for date:', date);
  try {
    const digest = await fetchDigest(date);
    console.log('Received digest data:', digest);
    
    // Update posts
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      postsContainer.innerHTML = '';
      digest.top_posts.forEach(post => {
        postsContainer.appendChild(createPostCard(post));
      });
    }

    // Update version info
    const versionInfo = document.getElementById('version-info');
    if (versionInfo) {
      const version = import.meta.env.VITE_PROJECT_VERSION || '6';
      const apiVersion = import.meta.env.VITE_PROJECT_VERSION_API || '6';
      const dbVersion = import.meta.env.VITE_PROJECT_VERSION_DATABASE || '6';
      const frontendVersion = import.meta.env.VITE_PROJECT_VERSION_FRONTEND || '6';
      versionInfo.textContent = `${version} (api: v${apiVersion}, db: ${dbVersion}, frontend: v${frontendVersion})`;
    }

    // Update last fetch time
    const lastFetch = document.getElementById('last-fetch');
    if (lastFetch && lastFetchTime) {
      lastFetch.textContent = lastFetchTime.toLocaleString();
    }
    
    // Update date header
    const dateHeader = document.getElementById('date-header');
    if (dateHeader) {
      const formattedDate = formatDate(digest.date);
      console.log('Setting date header to:', formattedDate);
      dateHeader.textContent = formattedDate;
    } else {
      console.error('Date header element not found!');
    }

    // Update summary
    const summary = document.getElementById('summary');
    if (summary) {
      summary.innerHTML = `
        <div class="bg-white rounded-lg shadow-md p-6">
          <h2 class="text-xl font-semibold mb-4">Daily Summary</h2>
          <div class="grid grid-cols-1 md:grid-cols-[20%_80%] gap-4">
            <div class="text-left">
              <div class="text-2xl font-bold text-blue-600">${digest.summary.total_posts}</div>
              <div class="text-gray-600">Total Posts</div>
              <div class="text-2xl font-bold text-blue-600">${digest.summary.total_comments}</div>
              <div class="text-gray-600">Total Comments</div>
              <div class="text-2xl font-bold text-blue-600">${digest.summary.top_subreddits.length}</div>
              <div class="text-gray-600">Total Subreddits</div>

              </div>
            <div class="text-left">
              <div class="mt-4">
                <div class="font-semibold text-gray-700 mb-2">Active Subreddits:</div>
                <div class="text-sm text-gray-600">
                  ${digest.summary.top_subreddits
                    .filter(sub => sub.post_count > 0)
                    .map(sub => `r/${sub.name} (${sub.post_count})`)
                    .join(', ')}
                </div>
              </div>

              <div class="mt-4">
                <div class="font-semibold text-gray-700 mb-2">Subreddits without any updates:</div>
                <div class="text-sm text-gray-600">
                  ${digest.summary.top_subreddits
                    .filter(sub => sub.post_count === 0)
                    .map(sub => `r/${sub.name}`)
                    .join(', ')}
                </div>
              </div>
            </div>
          </div>
        </div>
      `;
    }
  } catch (error) {
    console.error('Error updating UI:', error);
    // Show error message to user
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      postsContainer.innerHTML = `
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 text-red-700">
          Failed to load digest data. Please try again later.
        </div>
      `;
    }
  }
}

function setupDateNavigation() {
  const prevButton = document.getElementById('prev-date');
  const nextButton = document.getElementById('next-date');

  if (prevButton && nextButton) {
    prevButton.addEventListener('click', () => {
      console.log('Previous date clicked');
      currentDate.setDate(currentDate.getDate() - 1);
      console.log('New date:', currentDate);
      updateUI(currentDate);
    });

    nextButton.addEventListener('click', () => {
      console.log('Next date clicked');
      currentDate.setDate(currentDate.getDate() + 1);
      console.log('New date:', currentDate);
      updateUI(currentDate);
    });
  } else {
    console.error('Navigation buttons not found!');
  }
}

async function initializeApp() {
  setupDateNavigation();
  await updateUI();
}

// Start the application
initializeApp(); 
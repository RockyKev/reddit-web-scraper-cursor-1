import './style.css';
import { fetchDigest, getLastFetchTime } from './api';
import { formatDate } from './utils';
import { createPostCard } from './components';
import type { DigestData, Post } from './frontend-types';

let currentDate = new Date();

async function updateUI(date?: Date) {
  try {
    const digest = await fetchDigest(date);
    
    // Update date header
    const dateHeader = document.getElementById('date-header');
    if (dateHeader) {
      dateHeader.textContent = formatDate(digest.date);
    }

    // Update summary stats
    const elements = {
      totalPosts: document.getElementById('total-posts'),
      totalComments: document.getElementById('total-comments'),
      totalSubreddits: document.getElementById('total-subreddits'),
      activeSubreddits: document.getElementById('active-subreddits'),
      inactiveSubreddits: document.getElementById('inactive-subreddits'),
      versionInfo: document.getElementById('version-info'),
      lastFetch: document.getElementById('last-fetch')
    };

    // Update summary numbers
    if (elements.totalPosts) elements.totalPosts.textContent = digest.summary.total_posts.toString();
    if (elements.totalComments) elements.totalComments.textContent = digest.summary.total_comments.toString();
    if (elements.totalSubreddits) elements.totalSubreddits.textContent = digest.summary.top_subreddits.length.toString();
    
    // Update subreddit lists
    if (elements.activeSubreddits) {
      elements.activeSubreddits.textContent = digest.summary.top_subreddits
        .filter((sub: DigestData['summary']['top_subreddits'][0]) => sub.post_count > 0)
        .map((sub: DigestData['summary']['top_subreddits'][0]) => `r/${sub.name} (${sub.post_count})`)
        .join(', ');
    }
    
    if (elements.inactiveSubreddits) {
      elements.inactiveSubreddits.textContent = digest.summary.top_subreddits
        .filter((sub: DigestData['summary']['top_subreddits'][0]) => sub.post_count === 0)
        .map((sub: DigestData['summary']['top_subreddits'][0]) => `r/${sub.name}`)
        .join(', ');
    }

    // Update version info
    if (elements.versionInfo) {
      const version = import.meta.env.VITE_PROJECT_VERSION || '6';
      const apiVersion = import.meta.env.VITE_PROJECT_VERSION_API || '6';
      const dbVersion = import.meta.env.VITE_PROJECT_VERSION_DATABASE || '6';
      const frontendVersion = import.meta.env.VITE_PROJECT_VERSION_FRONTEND || '6';
      const buildTimestamp = new Date().toISOString();
      const commitHash = import.meta.env.VITE_GIT_COMMIT_HASH || 'unknown';
      
      elements.versionInfo.innerHTML = `
        <div class="text-sm text-gray-500">
          <div>Version ${version} (api: v${apiVersion}, db: ${dbVersion}, frontend: v${frontendVersion})</div>
          <div class="text-xs">Build: ${buildTimestamp}</div>
          <div class="text-xs">Commit: ${commitHash}</div>
        </div>
      `;
    }

    // Update last fetch time
    if (elements.lastFetch) {
      const lastFetchTime = getLastFetchTime();
      if (lastFetchTime) {
        elements.lastFetch.textContent = lastFetchTime.toLocaleString();
      }
    }

    // Update posts
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      postsContainer.innerHTML = '';
      digest.top_posts.forEach((post: Post) => {
        postsContainer.appendChild(createPostCard(post));
      });
    }
  } catch (error) {
    console.error('Error updating UI:', error);
    const postsContainer = document.getElementById('posts');
    if (postsContainer) {
      const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
      postsContainer.innerHTML = `
        <div class="bg-red-50 border border-red-200 rounded-lg p-6 text-red-700">
          <h3 class="text-lg font-semibold mb-2">Failed to load digest data</h3>
          <p class="mb-4">${errorMessage}</p>
          <button 
            onclick="window.location.reload()" 
            class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 transition-colors duration-200"
          >
            Retry
          </button>
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
      currentDate.setDate(currentDate.getDate() - 1);
      updateUI(currentDate);
    });

    nextButton.addEventListener('click', () => {
      currentDate.setDate(currentDate.getDate() + 1);
      updateUI(currentDate);
    });
  }
}

// Start the application
console.log('Frontend started:', {
  buildTime: new Date().toISOString(),
  commitHash: import.meta.env.VITE_GIT_COMMIT_HASH || 'unknown',
  apiUrl: import.meta.env.VITE_API_URL || 'http://localhost:3000'
});

setupDateNavigation();
updateUI(); 
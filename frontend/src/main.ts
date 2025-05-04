import './style.css';
import { fetchDigest, getApiFetchTime, getLastFetchTime } from './api';
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
      elements.versionInfo.textContent = `${version} (api: v${apiVersion}, db: ${dbVersion}, frontend: v${frontendVersion})`;
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
setupDateNavigation();
updateUI(); 
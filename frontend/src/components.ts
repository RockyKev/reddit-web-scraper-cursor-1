import type { Post } from './frontend-types';
import { getPostTypeIcon } from './utils';

export function createTitleSection(post: Post): HTMLElement {
  const titleContainer = document.createElement('div');
  titleContainer.className = 'flex-1';
  
  const title = document.createElement('h2');
  title.className = 'text-xl font-semibold text-gray-800 mb-2';
  
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

export function createScoreSection(post: Post): HTMLElement {
  const score = document.createElement('div');
  score.className = 'text-sm text-gray-600';
  score.textContent = `Score: ${post.score} | Comments: ${post.num_comments}`;
  return score;
}

export function createKeywordsSection(post: Post): HTMLElement | null {
  if (!post.keywords?.length) return null;
  
  const container = document.createElement('div');
  container.className = 'mb-4 flex items-center';
  
  const label = document.createElement('div');
  label.className = 'text-sm font-medium text-gray-600 pr-1';
  label.textContent = 'Key Topics: ';
  
  const list = document.createElement('div');
  list.className = 'flex flex-wrap gap-2';
  
  post.keywords.forEach((keyword: string) => {
    const tag = document.createElement('span');
    tag.className = 'px-2 py-1 bg-gray-100 text-gray-700 text-sm rounded-full';
    tag.textContent = keyword;
    list.appendChild(tag);
  });
  
  container.appendChild(label);
  container.appendChild(list);
  return container;
}

export function createTopCommentersSection(post: Post): HTMLElement {
  const container = document.createElement('div');
  container.className = 'mt-2 text-sm text-gray-600 flex';
  
  const label = document.createElement('div');
  label.className = 'font-medium mb-1 pr-1';
  label.textContent = 'Top Commenters: ';
  
  const commentersList = document.createElement('div');
  commentersList.className = 'flex flex-wrap gap-2';
  
  post.top_commenters.forEach((commenter: { username: string; contribution_score: number }) => {
    const commenterLink = document.createElement('a');
    commenterLink.href = `https://www.reddit.com/user/${commenter.username}/`;
    commenterLink.className = 'px-2 py-1 bg-gray-100 text-gray-700 text-sm rounded-full';
    commenterLink.textContent = `${commenter.username} (${commenter.contribution_score})`;
    commentersList.appendChild(commenterLink);
  });
  
  container.appendChild(label);
  container.appendChild(commentersList);
  return container;
}

export function createPostedBySection(post: Post): HTMLElement {
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

export function createContentSection(post: Post): HTMLElement {
  const content = document.createElement('div');
  content.className = 'text-gray-700 mb-4';

  // Check if content is a URL
  if (post.content.startsWith('http')) {
    // For image posts, show thumbnail with lazy loading
    if (post.post_type === 'image') {
      const img = document.createElement('img');
      img.src = post.content;
      img.alt = post.title;
      img.className = 'w-24 h-24 object-cover rounded-lg';
      img.loading = 'lazy'; // Add lazy loading
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

export function createPostCard(post: Post): HTMLElement {
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
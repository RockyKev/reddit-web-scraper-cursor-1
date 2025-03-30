export const mockUsers = [
  {
    id: 'user1',
    username: 'PDX_Dave',
    created_at: new Date()
  },
  {
    id: 'user2',
    username: 'CatLadySarah',
    created_at: new Date()
  },
  {
    id: 'user3',
    username: 'PortlandNative',
    created_at: new Date()
  }
];

export const mockPosts = [
  {
    id: 'post1',
    subreddit: 'r/Portland',
    title: 'Test Post 1',
    type: 'text',
    upvotes: 100,
    comment_count: 50,
    permalink: 'https://reddit.com/r/Portland/post1',
    selftext: 'This is a test text post',
    url: '',
    keywords: ['test', 'portland', 'text'],
    author_id: 'user1',
    created_at: new Date()
  },
  {
    id: 'post2',
    subreddit: 'r/askportland',
    title: 'Test Post 2',
    type: 'link',
    upvotes: 75,
    comment_count: 30,
    permalink: 'https://reddit.com/r/askportland/post2',
    selftext: '',
    url: 'https://example.com/image.jpg',
    keywords: ['test', 'portland', 'link'],
    author_id: 'user2',
    created_at: new Date()
  },
  {
    id: 'post3',
    subreddit: 'r/Portland',
    title: 'Test Post 3',
    type: 'image',
    upvotes: 50,
    comment_count: 20,
    permalink: 'https://reddit.com/r/Portland/post3',
    selftext: '',
    url: 'https://example.com/image2.jpg',
    keywords: ['test', 'portland', 'image'],
    author_id: 'user3',
    created_at: new Date()
  }
];

export const mockComments = [
  {
    id: 'comment1',
    post_id: 'post1',
    author_id: 'user2',
    body: 'Great post!',
    upvotes: 25,
    created_at: new Date()
  },
  {
    id: 'comment2',
    post_id: 'post1',
    author_id: 'user3',
    body: 'Interesting discussion',
    upvotes: 15,
    created_at: new Date()
  },
  {
    id: 'comment3',
    post_id: 'post2',
    author_id: 'user1',
    body: 'Thanks for sharing',
    upvotes: 10,
    created_at: new Date()
  }
]; 
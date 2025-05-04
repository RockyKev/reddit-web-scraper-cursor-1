export function formatDate(dateString: string): string {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

export function getPostTypeIcon(postType: string): string {
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
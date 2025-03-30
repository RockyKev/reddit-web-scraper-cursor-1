# AI Assistant Notes

## Project Overview
This is a Reddit PDX Digest application that aggregates and displays daily Reddit activity from Portland-related subreddits. The project uses a modern tech stack with TypeScript, Express, and a vanilla JavaScript frontend.

## Key Decisions

### Frontend Architecture
- Using vanilla JavaScript with TypeScript instead of React for simplicity and performance
- Vite for development and building
- Tailwind CSS for styling
- Responsive design with mobile-first approach

### Backend Architecture
- Express with TypeScript
- Mock data service for development
- CORS enabled for frontend development
- Environment-based configuration

### Data Management
- Currently using mock data for development
- PostgreSQL planned for future implementation
- Structured data format for posts and digests

## Best Practices

### Code Organization
- Clear separation of frontend and backend code
- TypeScript interfaces for type safety
- Modular service architecture
- Environment-based configuration

### Development Workflow
- Use environment variables for configuration
- Keep sensitive data out of version control
- Follow TypeScript best practices
- Maintain consistent code style

### API Design
- RESTful endpoints
- Clear error handling
- CORS configuration for development
- Mock data support

### Frontend Development
- Responsive design principles
- Progressive enhancement
- Accessibility considerations
- Performance optimization

## Current Status
- Basic frontend and backend setup complete
- Mock data service implemented
- CORS configuration added
- Environment variables configured
- Documentation updated

## Next Steps
- Implement database integration
- Add authentication
- Enhance error handling
- Add testing infrastructure
- Implement real Reddit API integration

## Project Structure

### Documentation Organization
- README.md serves as the main entry point and project overview
- Detailed documentation is split into focused guides:
  - architecture.md: System design and components
  - development.md: Development workflow and guidelines
  - database.md: Database setup and management
  - testing.md: Testing strategy and procedures
  - api.md: API endpoints and usage
  - data-collection.md: Reddit data collection process

### Database Management
- Currently using both custom migration system and node-pg-migrate (to be standardized in Version 5)
- Migration files follow timestamp-based naming: YYYYMMDDHHMMSS_migration_name.sql
- Each migration can include up and down sections
- Migrations are tracked in a dedicated migrations table
- Supports transaction-based rollbacks
- Note: Migration system choice will be finalized in Version 5

### Testing Framework
- Using Jest as the primary testing framework
- Mock implementations available in tests/mocks/
- Test files follow .test.ts naming convention
- Database tests use a separate test database

## Common Tasks

### Database Changes
1. Create new migration file with timestamp
2. Include both up and down migrations
3. Test migrations locally
4. Apply migrations using npm run migrate:up
5. Verify changes in database

### Testing
1. Write unit tests for new functionality
2. Use mock implementations for external dependencies
3. Follow Arrange-Act-Assert pattern
4. Run tests with npm test
5. Check coverage with npm run test:coverage

### Documentation
1. Keep README.md focused on high-level overview
2. Add detailed information to appropriate guide
3. Update API documentation for new endpoints
4. Include examples where helpful
5. Cross-reference related documentation

## Common Issues

### Database
- Check Docker status for connection issues
- Verify environment variables
- Monitor query performance
- Use appropriate indexes

### Reddit API
- Respect rate limits
- Implement retry logic
- Cache responses when possible
- Handle API errors gracefully

### Testing
- Clear test database between runs
- Check mock implementations
- Verify test environment
- Handle async operations properly

## Future Considerations

### Planned Features
- RSS feed generation
- Slack bot integration
- Email digest delivery
- Mobile app development
- AI-powered summaries
- Sentiment analysis

### Technical Debt
- Monitor test coverage
- Review and update dependencies
- Optimize database queries
- Improve error handling

## Notes for AI Assistants

1. Always check existing documentation before making changes
2. Keep documentation consistent across files
3. Update related documentation when making changes
4. Follow project conventions and best practices
5. Provide clear explanations and examples
6. Cross-reference related documentation
7. Keep the README.md focused and high-level
8. Use appropriate formatting and structure
9. Include code examples where helpful
10. Maintain backward compatibility

## PowerShell Console Issues
- The PowerShell console has issues with long commit messages, causing `System.ArgumentOutOfRangeException`
- Workaround: Use shorter commit messages or break them into multiple lines
- Example: Instead of "docs: move development phases to separate file and update Phase 1 progress", use "docs: move dev phases"

## Git Commands
- When committing changes, prefer shorter commit messages to avoid PowerShell console issues
- Use `git add *` to stage all changes when working with multiple files
- The repository is hosted at: https://github.com/robingamedev/reddit-web-scraper-cursor.git

## Project Structure
- The project uses TypeScript with Node.js
- Main source code is in `src/` directory
- Test files are in `tests/` directory
- Documentation is in `docs/` directory
- Scripts for various tasks are in `src/scripts/` directory

## Database
- Uses PostgreSQL
- Database management commands are available through npm scripts:
  - `npm run db:migrate-up` - Run migrations
  - `npm run db:migrate-down` - Rollback migrations
  - `npm run db:drop` - Drop the database
  - `npm run db:reset` - Drop and recreate the database

## Reddit API
- Rate limiting is important to respect
- Live data collection should be done with conservative delays between requests
- Post types and permalinks need to be properly handled to avoid null values

## Content Handling
- Reddit posts can be of different types:
  - `link`: External links to other websites
  - `self`: Text posts within Reddit
  - `image`: Image posts (can be single or multiple images)
  - `video`: Video posts (hosted on Reddit or external platforms)
  - `gallery`: Multiple image posts
  - `poll`: Reddit polls
  - `rich_video`: Rich media posts (e.g., YouTube embeds)
  - `crosspost`: Posts crossposted from other subreddits
- Each type requires specific handling:
  - `link`: Store the external URL and title
  - `self`: Store the text content and markdown formatting
  - `image`: Store image URLs and metadata
  - `video`: Store video URLs and playback information
  - `gallery`: Store multiple image URLs and gallery metadata
  - `poll`: Store poll options and voting data
  - `rich_video`: Store embed URLs and metadata
  - `crosspost`: Store original post reference and crosspost metadata
- Always verify post_type and permalink fields are populated
- Handle null values gracefully in the API response
- Consider content type when generating summaries or extracting keywords

## Common Fixes
1. Database Issues:
   - If database operations fail, try running `npm run db:reset`
   - Check for proper environment variables in `.env` file

2. TypeScript Issues:
   - Ensure proper type definitions in `src/types/`
   - Check for missing imports in service files

3. Reddit Data Collection:
   - Verify post_type and permalink fields are populated
   - Implement proper rate limiting between API calls
   - Use the live collection scripts for real-time data gathering

## Development Workflow
1. Make changes to source files
2. Test changes using appropriate npm scripts
3. Update documentation if needed
4. Commit changes with concise messages
5. Push to remote repository

## Useful npm Scripts
- `npm run dev` - Start development server
- `npm run collect:live` - Run live post collection
- `npm run test:unit` - Run unit tests
- `npm run test:db` - Test database operations
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

## Critical Mistakes and Learnings

### Environment Files and Destructive Commands
- NEVER use `git clean -fdx` or similar destructive commands without explicit warning and confirmation
- Environment files (.env) are typically not tracked in git for security reasons
- Always check what files will be affected before running any command
- Be especially careful with:
  - Environment files (.env)
  - Configuration files
  - Any files containing sensitive data
  - Local development filesC

### Test Organization
- Don't assume test files are Jest tests or direct ts-node tests without checking
- Don't reorganize test files without understanding the current structure
- Don't make changes to test organization without clear requirements

### General Guidelines
1. Before running any command:
   - Check what files will be affected
   - Warn about potential destructive actions
   - Ask for confirmation if there's any risk
2. When dealing with environment files:
   - Never delete or modify .env files without explicit permission
   - Always keep .env.example as a template
   - Document any changes to environment variables
3. When reorganizing files:
   - Understand the current structure first
   - Don't make assumptions about file organization
   - Get clear requirements before making changes

### Session Context
- User was working on a Reddit web scraper project
- Attempted to clean up test organization but made incorrect assumptions
- Accidentally deleted .env file using git clean
- Had to recreate .env from template
- User had to provide their own values for sensitive data

### Future Improvements
1. For destructive commands:
   - Always show what will be deleted first
   - Get explicit confirmation
   - Provide alternatives if available
2. For environment files:
   - Treat them as sensitive data
   - Never modify without explicit permission
   - Keep backups if making changes
3. For test organization:
   - Understand the current structure
   - Don't make assumptions about test frameworks
   - Get clear requirements before reorganizing 

## Response example with details

To see an example of the payload when scraping reddit, look at "data/testdata-reddit-portland-output.json"

### Example of a the response when visiting [example.com]/api/digest/2024-03-20

Note: `[example.com]/api/digest/` gives the current date.

```json
{
  "date": "2024-03-20",  // date selected
  "summary": {
    "total_posts": 150, // total count of posts in top_posts
    "total_comments": 1200, // total comments scraped from each posts.
    "top_subreddits": ["r/Portland", "r/askportland"]
  },
  "top_posts": [
    {
      "id": "abc123", // this is the ID from the reddit output.
      "subreddit": "r/Portland", // this is the subreddit
      "title": "Post Title", // this is the title from the reddit output.
      "type": "text", // this is the post_hint from the reddit output.
	   "content": "This is the content of the post", // read note 1
      "score": 100, // This is the score from the reddit output
      "score_ratio": 0.98, // This is the upvote_ratio from the reddit output.
      "comment_count": 100, // This is the num_comments from the reddit output.
      "daily_rank": 3, // This is a rank in the database we create
      "daily_score": 120, // This is a score in the database we create
      "permalink": "https://reddit.com/...",   // This is the permalink from the reddit output.
      "keywords": ["keyword1", "keyword2", "keyword3"], // Read note 2
      "locked": false, // This is the locked from the reddit output
      "author": {
         "username": "PDX_Dave",  // This is the author from the reddit output
         "fullname": "t2_123abc", // This is the author_fullname from the reddit output
         "contribution_score": 2, // This is the score in the database that we create
       },
      "top_commenters": [
        {
          "username": "CatLadySarah", 
          "contribution_score": 5, // This is the score in the database that we create
        },
         {
          "username": "Zesty Steve", // This is the score in the database that we create
          "contribution_score": 7,
        },
        {
          "username": "Banana123", // This is the score in the database that we create
          "contribution_score": 10,
        }
      ],
      "summary": null, // Future feature: This will be a AI summary of the post, once I can figure out how to do this.
      "sentiment": null // Future feature: This will be a AI sentiment value of the collected content and comments.
    }
  ]
}
```

Note 1: For "content" key --
* if `post_hint` is "link" OR "image" OR "hosted:video": get the "url" or "url_overridden_by_dest". They should be the same. If not, include both. Then follow up with the "selftext" if it exists.
* if `post_hint` is "self": get the "selftext".

If it's something else, review this document and update it.

Note 2: Keywords is generated by collecting a list of the top comments and pulling out some key words from the comments themselves.

## Database Migration Lessons
- Database migrations should be carefully planned and tested before implementation
- Avoid making database changes until the API structure is stable
- When working with migrations:
  - Always test migrations on a copy of the database first
  - Keep migrations atomic and focused
  - Document the purpose of each migration
  - Consider the impact on existing data
  - Have a clear rollback strategy

## Project Organization Lessons
- Focus on API stability before database optimization
- Avoid premature optimization
- When dealing with multiple components:
  - Ensure each component is fully functional before moving to the next
  - Test integrations thoroughly
  - Document dependencies between components
  - Keep track of what's been completed and what's pending

## Development Process
- Follow a clear order of operations:
  1. Design and document the API structure
  2. Implement core functionality
  3. Test thoroughly
  4. Optimize and refactor
  5. Add additional features
- Avoid making database changes until the API structure is stable
- Keep track of completed features and dependencies
- Document decisions and their rationale

## Post Ranking and Filtering
- Daily rank is determined by score count (upvotes)
- Posts are sorted by score in descending order
- Daily rank is assigned based on position in sorted list (highest score = rank 1)
- API filtering is controlled by POSTS_PER_SUBREDDIT environment variable
  - Example: If POSTS_PER_SUBREDDIT=20, only posts with daily_rank 1-20 are returned
  - Changing POSTS_PER_SUBREDDIT to 10 would return only posts with daily_rank 1-10
- This simple ranking system allows for efficient filtering and pagination

## Frontend and API Development
- Frontend and API are separate applications
- API runs on Express server (port 3000)
- Frontend runs on Vite dev server (port 5173)
- Development scripts:
  - `npm run api:start` - Start Express API server
  - `npm run frontend:dev` - Start Vite dev server
  - `npm run frontend:build` - Build frontend for production
- Frontend proxies API requests to backend during development
- Frontend is built as static files for production
- API endpoints:
  - `/api/digest` - Returns daily digest data
  - More endpoints to be added as needed

## Development Environment
- TypeScript for both frontend and backend
- No .js files in src/ directory (all TypeScript)
- ES modules for imports/exports
- Strict TypeScript configuration
- Separate package.json for frontend and backend
- Frontend uses Vite for development and building
- Backend uses Express for API server
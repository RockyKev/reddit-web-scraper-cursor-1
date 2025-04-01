# AI Assistant Notes

This document contains notes and guidelines for AI assistants working on the Reddit PDX Scraper project.

## Project Overview
This is a Reddit PDX Digest application that aggregates and displays daily Reddit activity from Portland-related subreddits. The project uses a modern tech stack with TypeScript, Express, and a vanilla JavaScript frontend.

## Documentation Organization
- README.md serves as the main entry point and project overview
- Detailed documentation is split into focused guides:
  - architecture.md: System design and components
  - development.md: Development workflow and guidelines
  - database.md: Database setup and management
  - testing.md: Testing strategy and procedures
  - api.md: API endpoints and usage
  - data-collection.md: Reddit data collection process

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
- Frontend: `frontend/` - Vite + vanilla JS + Tailwind CSS
- Backend: `backend/` - Node.js + Express + TypeScript
- Database: `database/` - PostgreSQL migrations and setup
- Tests: `tests/` - Jest test files
- Mock Data: `mock-data/` - Development data files
- Docs: `docs/` - Project documentation
- Scripts: `scripts/` - Utility scripts
- Config: `config/` - Configuration files

## Database Management
- Currently using both custom migration system and node-pg-migrate (to be standardized in Version 5)
- Migration files follow timestamp-based naming: YYYYMMDDHHMMSS_migration_name.sql
- Each migration can include up and down sections
- Migrations are tracked in a dedicated migrations table
- Supports transaction-based rollbacks
- Note: Migration system choice will be finalized in Version 5

## TypeScript Guidelines
1. File Extensions:
   - Use `.js` extension in import statements (e.g., `import { foo } from './bar.js'`)
   - This is required for ES modules at runtime, even though the source files are `.ts`
   - TypeScript will automatically resolve `.js` extensions to `.ts` files during compilation
   - This follows the Node.js ES modules specification

2. Module Resolution:
   - Project uses ES modules exclusively (package.json has "type": "module")
   - tsconfig.json is configured with "module": "NodeNext" and "moduleResolution": "NodeNext"
   - All imports should use relative paths (starting with ./ or ../)
   - Avoid using path aliases unless absolutely necessary

3. Running TypeScript:
   - Use `node --loader ts-node/esm` for running TypeScript files directly
   - For development with nodemon, use `nodemon --exec 'node --loader ts-node/esm'`
   - Build process uses `tsc` to compile to JavaScript

4. Type Definitions:
   - Keep type definitions in `backend/types/`
   - Use interfaces for object shapes
   - Use type aliases for complex types
   - Export all types that are used across multiple files

5. Project Organization:
   - Backend code goes in `backend/`
   - Frontend code goes in `frontend/`
   - Database migrations in `database/migrations/`
   - Test files mirror the source structure in `tests/`

## Frontend Guidelines
1. Vanilla JavaScript:
   - No framework dependencies
   - Use ES modules for code organization
   - Keep components in `frontend/components/`
   - Use Tailwind CSS for styling

2. State Management:
   - Use browser's localStorage for persistence
   - Keep state management simple and centralized
   - Avoid complex state management libraries

## Backend Guidelines
1. API Structure:
   - RESTful endpoints in `backend/api/routes/`
   - Services in `backend/services/`
   - Types in `backend/types/`
   - Utils in `backend/utils/`

2. Database:
   - Use migrations for schema changes
   - Keep database setup scripts in `database/setup/`
   - Use environment variables for configuration

## Testing Guidelines
1. Test Organization:
   - Unit tests in `tests/jest/`
   - API tests in `tests/api/`
   - Mock data in `tests/mocks/`
   - Test utilities in `tests/utils/`

2. Test Coverage:
   - Aim for high test coverage
   - Mock external dependencies
   - Use test databases for integration tests

## Development Workflow
1. Code Style:
   - Use TypeScript's strict mode
   - Follow ESLint rules
   - Use Prettier for formatting
   - Keep functions small and focused

2. Git Workflow:
   - Feature branches from main
   - PR reviews required
   - Squash merges preferred
   - Keep commits atomic

3. Environment:
   - Use .env for local development
   - Keep sensitive data out of version control
   - Document all environment variables

## Common Pitfalls to Avoid
1. TypeScript:
   - Don't use `any` type unless absolutely necessary
   - Don't mix `.js` and `.ts` extensions in imports
   - Don't ignore type errors
   - Don't use `require()` - use ES imports

2. Project Structure:
   - Don't put frontend code in backend
   - Don't mix concerns between layers
   - Don't duplicate type definitions
   - Don't ignore migration files

3. Testing:
   - Don't skip writing tests
   - Don't use production database for tests
   - Don't ignore test failures
   - Don't write brittle tests

## Future Considerations
1. Scalability:
   - Consider caching strategies
   - Plan for database sharding
   - Think about CDN usage
   - Consider rate limiting

2. Monitoring:
   - Add error tracking
   - Implement logging
   - Set up performance monitoring
   - Add health checks

3. Security:
   - Regular dependency updates
   - Security scanning
   - Input validation
   - Rate limiting

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
   - Ensure proper type definitions in `backend/types/`
   - Check for missing imports in service files
   - Don't use `any` type unless absolutely necessary
   - Don't mix `.js` and `.ts` extensions in imports
   - Don't ignore type errors
   - Don't use `require()` - use ES imports

3. Reddit Data Collection:
   - Verify post_type and permalink fields are populated
   - Implement proper rate limiting between API calls
   - Use the live collection scripts for real-time data gathering

## CommonJS vs ES Modules Issues

### Problem
When using ES Modules (indicated by `"type": "module"` in package.json), importing CommonJS modules (like `pg`) directly can cause issues:
```typescript
// This will fail:
import { Pool } from 'pg';  // Error: Named export 'Pool' not found
```

### Solution
For CommonJS modules, use the following pattern:
```typescript
// This works:
import pkg from 'pg';
const { Pool } = pkg;
```

### Common Modules That Need This Fix
- `pg` (PostgreSQL client)
- `express`
- Other older Node.js packages that haven't fully migrated to ES Modules

### Best Practices
1. Always check if a package is CommonJS or ES Module before importing
2. Use the `pkg` import pattern for CommonJS modules
3. Consider creating a central database connection file to avoid repeating this pattern
4. Document this pattern in project documentation for future reference

## Data Structure Guidelines

### Post Content Handling
1. Posts have multiple content-related fields:
   - `selftext`: Raw text content for text posts
   - `url`: Raw URL for link posts
   - `post_type`: Determines which field contains the main content
   - `content`: Frontend-friendly field derived from either selftext or url based on post_type

2. Content Field Rules:
   - For text posts: `content` is derived from `selftext`
   - For link posts: `content` is derived from `url`
   - The raw fields (`selftext`, `url`) are always included in the API response
   - Frontend should primarily use the `content` field for display

### Author Structure
1. Author information is returned as an object with three fields:
   - `username`: Clean, human-readable username for display
   - `reddit_id`: Reddit's database ID (t2_...)
   - `contribution_score`: Score based on frequency in our database

2. Author Data Rules:
   - Always include all three fields in the author object
   - Keep usernames clean and human-readable
   - Maintain Reddit's ID format for reddit_id
   - Calculate contribution_score based on user activity

### Documentation Requirements
1. Database Schema:
   - Document raw fields and their purposes
   - Include notes about field relationships
   - Specify which fields determine content type

2. API Documentation:
   - Show both raw and derived fields
   - Explain field relationships clearly
   - Provide examples of different content types

## Database Refactoring Experience

### Directory Structure Improvements
- Moved all database-related code from `backend/db` to the root `database` directory
- Consolidated database setup scripts into a single location
- Eliminated duplicate functionality between `backend/scripts/setup-database.ts` and `database/setup/setup-test-db.ts`

### Database Setup Improvements
1. Created a unified setup script (`database/setup.ts`) that:
   - Handles both test and production database setup
   - Uses a single schema file (`database/schema.sql`)
   - Properly handles SQL statement splitting with dollar-quoted strings
   - Gracefully handles existing tables (ignores "relation already exists" errors)
   - Provides clear logging and error messages

2. Database Connection Management:
   - Moved from callback-style to async/await for better error handling
   - Added explicit connection testing functionality
   - Improved connection pool management for tests
   - Added proper cleanup in test environment

### Test Suite Improvements
1. Test Setup:
   - Consolidated test database setup into a single approach
   - Added proper console output suppression during tests
   - Implemented proper database connection cleanup
   - Added appropriate timeouts for database operations

2. Test Structure:
   - Organized test data setup in `beforeAll` blocks
   - Added proper cleanup in `afterAll` blocks
   - Implemented comprehensive test cases for different scenarios
   - Added proper error handling for missing data

### NPM Scripts Organization
Consolidated and improved database-related npm scripts:
```json
{
  "db:setup": "tsx database/setup.ts",
  "db:setup:test": "tsx database/setup.ts --test",
  "db:migrate": "tsx database/migrate.ts up",
  "db:migrate:down": "tsx database/migrate.ts down",
  "db:migrate:status": "tsx database/migrate.ts status"
}
```

### Lessons Learned
1. SQL Statement Handling:
   - Need to properly handle dollar-quoted strings in PostgreSQL
   - Better to execute schema as individual statements
   - Important to handle existing relations gracefully

2. Test Environment:
   - Jest requires proper cleanup of database connections
   - Console output should be suppressed but restorable
   - Test database should be properly isolated
   - Important to test both success and error cases

3. Code Organization:
   - Keep database-related code in a single location
   - Use consistent import paths
   - Maintain clear separation between test and production code
   - Avoid duplicate functionality across different scripts

4. Error Handling:
   - Properly handle database connection errors
   - Add informative error messages
   - Include proper type checking for errors
   - Add graceful fallbacks where appropriate

### Future Improvements
1. Consider adding:
   - Database migration versioning
   - Automatic test database naming
   - More comprehensive error handling
   - Better logging and monitoring
   - Transaction support for test data setup
   - Database connection pooling configuration

2. Potential Optimizations:
   - Batch database operations
   - Improve schema loading performance
   - Add connection pooling metrics
   - Implement query timeout handling
   - Add retry mechanisms for transient failures


## Code Quality

Avoid wrapping every method in try/catch. Only catch errors when you intend to handle them meaningfully—such as logging, adding context, or recovering safely. Let unexpected errors propagate upward so they can be handled at a higher level or cause a controlled failure. Catching and suppressing errors (especially by returning default values) hides problems, making debugging harder and leading to misleading behavior. Prioritize visibility and traceability over silent recovery.
# AI Assistant Notes

This document contains learnings and quirks about the project that are helpful for AI assistance.

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
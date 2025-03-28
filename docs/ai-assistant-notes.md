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

## Critical Mistakes and Learnings

### Environment Files and Destructive Commands
- NEVER use `git clean -fdx` or similar destructive commands without explicit warning and confirmation
- Environment files (.env) are typically not tracked in git for security reasons
- Always check what files will be affected before running any command
- Be especially careful with:
  - Environment files (.env)
  - Configuration files
  - Any files containing sensitive data
  - Local development files

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
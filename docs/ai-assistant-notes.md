# AI Assistant Notes

This document contains notes and guidelines for AI assistants working on the Reddit PDX Scraper project.

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
- Using a custom migration system instead of node-pg-migrate
- Migration files follow timestamp-based naming: YYYYMMDDHHMMSS_migration_name.sql
- Each migration can include up and down sections
- Migrations are tracked in a dedicated migrations table
- Supports transaction-based rollbacks

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

## Best Practices

### Code Style
- Use TypeScript's strict mode
- Follow project naming conventions
- Document public APIs
- Keep files focused and small

### Testing
- Test each component in isolation
- Use mocks for external dependencies
- Clean up after tests
- Aim for high test coverage

### Documentation
- Keep it up to date
- Include examples
- Cross-reference related docs
- Use clear, concise language

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
import pkg from 'pg';
const { Pool } = pkg;
import { readFileSync, readdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const __dirname = dirname(fileURLToPath(import.meta.url));
const MIGRATIONS_DIR = join(__dirname, 'migrations');

interface Migration {
    name: string;
    up: string;
    down: string;
}

interface MigrationRow {
    name: string;
}

class MigrationRunner {
    private pool: InstanceType<typeof Pool>;
    private migrations: Migration[] = [];

    constructor(pool: InstanceType<typeof Pool>) {
        this.pool = pool;
    }

    async init() {
        // Create migrations table if it doesn't exist
        const createTableSQL = readFileSync(
            join(MIGRATIONS_DIR, '20240328000001_create_migrations_table.sql'),
            'utf-8'
        );
        await this.pool.query(createTableSQL);

        // Load all migration files
        const files = readdirSync(MIGRATIONS_DIR)
            .filter(file => file.endsWith('.sql'))
            .sort();

        for (const file of files) {
            const content = readFileSync(join(MIGRATIONS_DIR, file), 'utf-8');
            const [up, down] = this.splitMigration(content);
            
            this.migrations.push({
                name: file,
                up,
                down
            });
        }
    }

    private splitMigration(content: string): [string, string] {
        const parts = content.split('-- Down Migration');
        const up = parts[0].trim();
        const down = parts[1] ? parts[1].trim() : '';
        return [up, down];
    }

    async getAppliedMigrations(): Promise<string[]> {
        const result = await this.pool.query<MigrationRow>(
            'SELECT name FROM migrations ORDER BY id'
        );
        return result.rows.map(row => row.name);
    }

    async up() {
        const applied = await this.getAppliedMigrations();
        const pending = this.migrations.filter(m => !applied.includes(m.name));

        for (const migration of pending) {
            console.log(`Applying migration: ${migration.name}`);
            try {
                await this.pool.query('BEGIN');
                await this.pool.query(migration.up);
                await this.pool.query(
                    'INSERT INTO migrations (name) VALUES ($1)',
                    [migration.name]
                );
                await this.pool.query('COMMIT');
                console.log(`Successfully applied migration: ${migration.name}`);
            } catch (error) {
                await this.pool.query('ROLLBACK');
                console.error(`Error applying migration ${migration.name}:`, error);
                throw error;
            }
        }
    }

    async down(steps: number = 1) {
        const applied = await this.getAppliedMigrations();
        const toRollback = applied.slice(-steps);

        for (const migrationName of toRollback.reverse()) {
            const migration = this.migrations.find(m => m.name === migrationName);
            if (!migration || !migration.down) {
                console.warn(`No down migration found for: ${migrationName}`);
                continue;
            }

            console.log(`Rolling back migration: ${migrationName}`);
            try {
                await this.pool.query('BEGIN');
                await this.pool.query(migration.down);
                await this.pool.query(
                    'DELETE FROM migrations WHERE name = $1',
                    [migrationName]
                );
                await this.pool.query('COMMIT');
                console.log(`Successfully rolled back migration: ${migrationName}`);
            } catch (error) {
                await this.pool.query('ROLLBACK');
                console.error(`Error rolling back migration ${migrationName}:`, error);
                throw error;
            }
        }
    }

    async status() {
        const applied = await this.getAppliedMigrations();
        const pending = this.migrations.filter(m => !applied.includes(m.name));

        console.log('\nMigration Status:');
        console.log('-----------------');
        console.log(`Applied: ${applied.length}`);
        console.log(`Pending: ${pending.length}`);
        
        if (pending.length > 0) {
            console.log('\nPending Migrations:');
            pending.forEach(m => console.log(`- ${m.name}`));
        }
    }
}

// CLI interface
async function main() {
    const pool = new Pool({
        connectionString: process.env.DATABASE_URL
    });

    const runner = new MigrationRunner(pool);
    await runner.init();

    const command = process.argv[2];
    const steps = parseInt(process.argv[3] || '1');

    try {
        switch (command) {
            case 'up':
                await runner.up();
                break;
            case 'down':
                await runner.down(steps);
                break;
            case 'status':
                await runner.status();
                break;
            default:
                console.log(`
Usage:
    npm run migrate up        # Apply all pending migrations
    npm run migrate down [n]  # Roll back n migrations (default: 1)
    npm run migrate status    # Show migration status
                `);
        }
    } finally {
        await pool.end();
    }
}

main().catch(console.error); 
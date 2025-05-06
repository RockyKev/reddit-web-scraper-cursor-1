import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Get the directory name in ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Get git commit hash
const commitHash = execSync('git rev-parse --short HEAD').toString().trim();

// Create .env file with git info
const envContent = `VITE_GIT_COMMIT_HASH=${commitHash}\n`;
fs.writeFileSync(path.join(__dirname, '.env'), envContent);

console.log(`Build info:
Commit Hash: ${commitHash}
Timestamp: ${new Date().toISOString()}
`); 
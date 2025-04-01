import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  setupFilesAfterEnv: ['<rootDir>/tests/jest/setup.ts'],
  moduleNameMapper: {
    '^(\\.{1,2}/.*)\\.js$': '$1',
  },
  transform: {
    '^.+\\.tsx?$': [
      'ts-jest',
      {
        useESM: true,
        tsconfig: 'tsconfig.json'
      },
    ],
  },
  extensionsToTreatAsEsm: ['.ts'],
  testMatch: ['**/*.test.ts'],
  moduleFileExtensions: ['ts', 'js', 'json', 'node'],
  transformIgnorePatterns: [
    'node_modules/(?!(dotenv|pg|pg-pool|pg-protocol|pg-types|postgres-array|postgres-date|postgres-interval|postgres-range)/)'
  ]
};

export default config; 
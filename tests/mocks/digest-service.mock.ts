import { DigestService } from '../../backend/services/digest-service.js';
import { getPool } from '../../backend/config/database.js';

export class MockDigestService extends DigestService {
  constructor() {
    super();
  }

  // Add any mock methods here if needed
} 
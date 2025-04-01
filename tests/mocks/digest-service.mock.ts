import { DigestService } from '../../backend/services/digest-service.js';
import { db } from '../../database/index.js';

export class MockDigestService extends DigestService {
  constructor() {
    super();
  }

  // Add any mock methods here if needed
} 
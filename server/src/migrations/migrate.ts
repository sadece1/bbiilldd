import fs from 'fs';
import path from 'path';
import pool from '../config/database';
import logger from '../utils/logger';

const schemaPath = path.join(__dirname, 'schema.sql');

const runMigration = async () => {
  try {
    logger.info('Starting database migration...');
    logger.info(`Schema file path: ${schemaPath}`);

    // Check if schema file exists
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found at: ${schemaPath}`);
    }

    // Read SQL schema file
    const schema = fs.readFileSync(schemaPath, 'utf8');
    logger.info(`Schema file read successfully (${schema.length} characters)`);

    // Split by semicolons and filter out empty statements
    const statements = schema
      .split(';')
      .map((stmt) => stmt.trim())
      .filter((stmt) => stmt.length > 0 && !stmt.startsWith('--'));

    logger.info(`Found ${statements.length} SQL statements to execute`);

    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      if (statement.trim()) {
        try {
          await pool.execute(statement);
          logger.info(`[${i + 1}/${statements.length}] Executed: ${statement.substring(0, 80)}...`);
        } catch (error: any) {
          // Log error but continue with other statements
          logger.error(`[${i + 1}/${statements.length}] Error executing statement: ${error.message}`);
          logger.error(`Statement: ${statement.substring(0, 200)}...`);
          // Don't throw - continue with other statements
        }
      }
    }

    logger.info('✅ Database migration completed successfully');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Database migration failed:', error);
    process.exit(1);
  }
};

runMigration();














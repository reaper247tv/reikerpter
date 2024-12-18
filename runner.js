const { exec } = require('child_process');
const fs = require('fs');
require('dotenv').config();

// Helper function to run shell commands
function runCommand(command, description) {
  return new Promise((resolve, reject) => {
    console.log(`\n[INFO] ${description}...`);
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`[ERROR] ${description} failed:\n`, stderr);
        return reject(error);
      }
      console.log(`[SUCCESS] ${description} completed:\n`, stdout);
      resolve(stdout);
    });
  });
}

// Main function to automate deployment
(async () => {
  try {
    // Generate application key
    await runCommand('php artisan key:generate', 'Generating application key');

    // Run migrations
    await runCommand('php artisan migrate --force', 'Running database migrations');

    // Seed the database
    await runCommand('php artisan db:seed --force', 'Seeding the database');

    // Create admin user
    const adminEmail = process.env.ADMIN_EMAIL || 'admin@example.com';
    const adminPassword = process.env.ADMIN_PASSWORD || 'password';
    const adminFirstName = process.env.ADMIN_FIRST_NAME || 'Admin';
    const adminLastName = process.env.ADMIN_LAST_NAME || 'User';
    await runCommand(
      `php artisan p:user:make --email=${adminEmail} --username=admin --password=${adminPassword} --name="${adminFirstName} ${adminLastName}"`,
      'Creating admin user'
    );

    console.log('[INFO] Deployment completed successfully.');
  } catch (error) {
    console.error('[FATAL] Deployment failed:', error);
    process.exit(1);
  }
})();
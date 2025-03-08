import mysql.connector
from mysql.connector import errorcode
import logging

class DatabaseMigration:
    def __init__(self, config):
        self.config = config
        self.logger = logging.getLogger('DatabaseMigration')
        
    def connect(self):
        try:
            connection = mysql.connector.connect(**self.config)
            return connection
        except mysql.connector.Error as err:
            if err.errno == errorcode.CR_CONN_HOST_ERROR:
                self.logger.critical(f"Database connection failed: {err}")
            raise
    
    def migrate(self, migration_scripts):
        connection = self.connect()
        cursor = connection.cursor()
        
        try:
            for script in migration_scripts:
                with open(script, 'r') as file:
                    sql_script = file.read()
                    cursor.execute(sql_script)
                    connection.commit()
                    self.logger.info(f"Successfully executed migration: {script}")
        
        except mysql.connector.Error as err:
            self.logger.error(f"Migration error: {err}")
            connection.rollback()
        
        finally:
            cursor.close()
            connection.close()

# Usage example
migration_config = {
    'host': 'localhost',
    'user': 'migration_user',
    'password': 'secure_migration_pass',
    'database': 'samfon_db'
}

migration = DatabaseMigration(migration_config)
migration.migrate([
    'schema_v1.sql',
    'schema_v2.sql',
    'data_migration.sql'
])
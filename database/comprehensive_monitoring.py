import psutil
import mysql.connector
import schedule
import time
import logging
from datetime import datetime

class ComprehensiveMonitoring:
    def __init__(self, db_config):
        self.db_config = db_config
        logging.basicConfig(
            filename='/var/log/database_monitoring.log', 
            level=logging.INFO
        )
    
    def check_system_resources(self):
        # CPU Usage
        cpu_usage = psutil.cpu_percent(interval=1)
        
        # Memory Usage
        memory = psutil.virtual_memory()
        memory_usage = memory.percent
        
        # Disk Usage
        disk = psutil.disk_usage('/')
        disk_usage = disk.percent
        
        return {
            'cpu_usage': cpu_usage,
            'memory_usage': memory_usage,
            'disk_usage': disk_usage
        }
    
    def check_database_connections(self):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()
            
            # Active Connections
            cursor.execute("SHOW PROCESSLIST")
            active_connections = len(cursor.fetchall())
            
            # Replication Status
            cursor.execute("SHOW SLAVE STATUS")
            replication_status = cursor.fetchone()
            
            cursor.close()
            connection.close()
            
            return {
                'active_connections': active_connections,
                'replication_healthy': replication_status is not None
            }
        
        except Exception as e:
            logging.error(f"Database Connection Error: {e}")
            return None
    
    def alert_if_critical(self, metrics):
        alerts = []
        
        if metrics['system']['cpu_usage'] > 90:
            alerts.append("HIGH CPU USAGE ALERT")
        
        if metrics['system']['memory_usage'] > 85:
            alerts.append("HIGH MEMORY USAGE ALERT")
        
        if metrics['database']['active_connections'] > 100:
            alerts.append("HIGH DATABASE CONNECTIONS ALERT")
        
        if alerts:
            self.send_alert(alerts)
    
    def send_alert(self, alerts):
        # Implement alert mechanisms:
        # - Email
        # - SMS
        # - Slack Notification
        logging.critical("\n".join(alerts))
    
    def run_monitoring(self):
        system_metrics = self.check_system_resources()
        database_metrics = self.check_database_connections()
        
        metrics = {
            'timestamp': datetime.now(),
            'system': system_metrics,
            'database': database_metrics
        }
        
        # Log Metrics
        logging.info(f"Monitoring Metrics: {metrics}")
        
        # Check for Critical Conditions
        self.alert_if_critical(metrics)
        
        return metrics

    def start_scheduled_monitoring(self):
        # Run system and database checks every 5 minutes
        schedule.every(5).minutes.do(self.run_monitoring)
        
        while True:
            schedule.run_pending()
            time.sleep(1)

# Main Monitoring Configuration
db_monitor_config = {
    'host': 'localhost',
    'user': 'monitoring_agent',
    'password': 'secure_monitoring_password',
    'database': 'samfon_db'
}

# Instantiate and Start Monitoring
if __name__ == "__main__":
    monitor = ComprehensiveMonitoring(db_monitor_config)
    monitor.start_scheduled_monitoring()
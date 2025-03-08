#!/bin/bash

# MySQL Performance Monitoring Script

# Database Connection Details
DB_USER="monitoring_user"
DB_PASS="secure_monitoring_password"
DB_HOST="localhost"

# Performance Metrics Collection
collect_metrics() {
    echo "Collecting MySQL Performance Metrics..."
    
    # Active Connections
    mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -e "SHOW PROCESSLIST" > /var/log/mysql/active_connections.log
    
    # Query Performance
    mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -e "SHOW FULL PROCESSLIST" | grep -v "Sleep" > /var/log/mysql/running_queries.log
    
    # Slow Query Log Analysis
    mysqldumpslow /var/log/mysql/slow-query.log > /var/log/mysql/slow_query_summary.log
    
    # Disk I/O Statistics
    iostat -x > /var/log/system/disk_io_stats.log
    
    # Memory Usage
    free -m >> /var/log/system/memory_usage.log
}

# Main Execution
main() {
    # Run every 5 minutes
    while true; do
        collect_metrics
        sleep 300
    done
}

# Execute
main
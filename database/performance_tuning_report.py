import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt

class DatabasePerformanceAnalyzer:
    def __init__(self, connection_params):
        self.connection = mysql.connector.connect(**connection_params)
    
    def analyze_slow_queries(self):
        query = """
        SELECT 
            query, 
            avg_time, 
            exec_count,
            round(avg_time * exec_count, 2) as total_time
        FROM performance_schema.events_statements_summary_by_digest
        WHERE avg_time > 1000 -- Queries taking more than 1ms
        ORDER BY total_time DESC
        LIMIT 10
        """
        
        df = pd.read_sql(query, self.connection)
        
        # Visualize Slow Queries
        plt.figure(figsize=(10, 6))
        plt.bar(df['query'], df['total_time'])
        plt.title('Top 10 Slow Queries')
        plt.xlabel('Query')
        plt.ylabel('Total Execution Time (ms)')
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig('slow_queries_report.png')
        
        return df

    def generate_index_recommendations(self):
        query = """
        SELECT 
            object_schema,
            object_name,
            index_name
        FROM performance_schema.table_io_waits_summary_by_index_usage
        WHERE index_name IS NOT NULL
          AND count_star = 0
        """
        
        unused_indexes = pd.read_sql(query, self.connection)
        return unused_indexes

# Configuration
db_config = {
    'host': 'localhost',
    'user': 'performance_analyst',
    'password': 'secure_analysis_pass',
    'database': 'samfon_db'
}

# Main Execution
try:
    analyzer = DatabasePerformanceAnalyzer(db_config)
    
    # Analyze Slow Queries
    slow_queries_df = analyzer.analyze_slow_queries()
    print("Slow Queries Report:")
    print(slow_queries_df)
    
    # Generate Index Recommendations
    unused_indexes = analyzer.generate_index_recommendations()
    print("\nUnused Indexes:")
    print(unused_indexes)
    
    # Generate Comprehensive Report
    with open('performance_analysis_report.md', 'w') as report:
        report.write("# Database Performance Analysis Report\n\n")
        
        report.write("## Slow Queries\n")
        report.write(slow_queries_df.to_markdown())
        
        report.write("\n\n## Unused Indexes\n")
        report.write(unused_indexes.to_markdown())
        
        report.write("\n\n## Recommendations\n")
        report.write("1. Optimize slow queries\n")
        report.write("2. Drop unused indexes\n")
        report.write("3. Review query execution plans\n")

except Exception as e:
    print(f"Analysis Error: {e}")
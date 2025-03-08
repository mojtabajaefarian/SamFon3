-- Security Audit Procedures

DELIMITER //

CREATE PROCEDURE SecurityAudit()
BEGIN
    DECLARE potential_threats INT;
    
    -- Check unauthorized login attempts
    SELECT COUNT(*) INTO potential_threats
    FROM system_logs
    WHERE 
        log_type = 'security' AND 
        severity IN ('high', 'critical') AND
        created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR);
    
    -- Log high-risk activities
    IF potential_threats > 10 THEN
        INSERT INTO system_logs 
        (log_type, action, severity)
        VALUES 
        ('security', 
         CONCAT('CRITICAL: ', potential_threats, ' potential security threats detected'),
         'critical');
    END IF;
    
    -- Check for weak passwords
    SELECT 
        id, mobile, 
        'Weak Password Risk' AS risk_type
    FROM users
    WHERE 
        LENGTH(password) < 8 OR 
        password REGEXP '^[0-9]+$' OR 
        password REGEXP '^[a-zA-Z]+$';
END //

DELIMITER ;
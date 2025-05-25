#!/bin/bash

# Database management script for PostgreSQL dev environment

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="devdb"
DB_USER="devuser"
DB_PASS="devpass123"

case "$1" in
    "start")
        echo "Starting PostgreSQL services..."
        docker-compose up -d
        echo "Waiting for database to be ready..."
        sleep 10
        echo "PostgreSQL is running!"
        echo "- Database: postgresql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME"
        echo "- Adminer: http://localhost:8080"
        ;;
    "stop")
        echo "Stopping PostgreSQL services..."
        docker-compose down
        ;;
    "restart")
        echo "Restarting PostgreSQL services..."
        docker-compose restart
        ;;
    "logs")
        docker-compose logs -f postgres
        ;;
    "connect")
        echo "Connecting to PostgreSQL..."
        docker exec -it dev-postgres psql -U $DB_USER -d $DB_NAME
        ;;
    "status")
        echo "Checking service status..."
        docker-compose ps
        ;;
    "reset")
        echo "⚠️  WARNING: This will delete all data! ⚠️"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Resetting database..."
            docker-compose down -v
            docker-compose up -d
            echo "Database reset complete!"
        else
            echo "Reset cancelled."
        fi
        ;;
    *)
        echo "PostgreSQL Dev Environment Manager"
        echo ""
        echo "Usage: $0 {start|stop|restart|logs|connect|status|reset}"
        echo ""
        echo "Commands:"
        echo "  start    - Start PostgreSQL and Adminer services"
        echo "  stop     - Stop all services"
        echo "  restart  - Restart all services"
        echo "  logs     - Show PostgreSQL logs"
        echo "  connect  - Connect to PostgreSQL via psql"
        echo "  status   - Show service status"
        echo "  reset    - Reset database (deletes all data)"
        echo ""
        echo "Connection details:"
        echo "  Host: $DB_HOST"
        echo "  Port: $DB_PORT"
        echo "  Database: $DB_NAME"
        echo "  Username: $DB_USER"
        echo "  Password: $DB_PASS"
        ;;
esac
# PostgreSQL Dev Environment

A simple PostgreSQL development environment designed for GitHub Codespaces with persistent data and limited internet access.

You can use this for:
* Learning Postgres commands
* App development with Postgres

You can do your development locally in the Codespace VSCode IDE or you can use Gihub SSH Port Forwarding to connect your local machine to Postgres.

You cannot connect to it from a Database connector in an SaaS App as Codespace only exposes HTTP/S and not TCP, which is required for Postgres remote connections.

## Features

- **PostgreSQL 15** database server
- **Persistent data** across Codespace restarts
- **Internet accessible** database (through Codespace port forwarding)
- **Adminer** web interface for database management
- **Sample data** automatically created on first run
- **Health checks** to ensure database is ready

## Quick Start

1. **Fork this repository**
1. **Create a Codespace** from the forked repository
2. **Wait for setup** - The PostgreSQL database will start automatically during postCreate
3. **Verify services are running**: `./db.sh status` (run `chmod +x db.sh` first)
4. **Access your database** using the connection details below

![codespace](images/codepace-main-1.png)
![Imgur](images/codepace-main-2.png)

If the database didn't start automatically, run: `./db.sh start`

## Database Connection Details

- **Host**: `localhost` (or your Codespace's forwarded port URL)
- **Port**: `5432`
- **Database**: `devdb`
- **Username**: `devuser`
- **Password**: `devpass123`

## Accessing the Database

If it's the first time spinning up the Codespace

`chmod +x db.sh`

### From within the Codespace:
```bash
# Using the management script
./db.sh connect

# Or connect using psql directly
psql -h localhost -p 5432 -U devuser -d devdb

# Or use the connection string
postgresql://devuser:devpass123@localhost:5432/devdb
```

## Management Script

The project includes a convenient `db.sh` script for managing your database:

```bash
# Start services
./db.sh start

# Stop services  
./db.sh stop

# View logs
./db.sh logs

# Connect to database
./db.sh connect

# Check status
./db.sh status

# Reset database (WARNING: deletes all data)
./db.sh reset
```

If it's the first time spinning up the Codespace

`chmod +x db.sh`

### From the internet (NOT WORKING AS CODESPACE ONLY EXPOSE HTTPS AND NOT TCP AS REQUIRED BY POSTGRES):
1. Go to the **Ports** tab in your Codespace
2. Find port `5432` and copy the forwarded URL
3. Use that URL as your host in your database client

### Web Admin Interface:
- Access Adminer at port `8080` (also forwarded publicly)
- Login with the database credentials above but specify the Postgres service name (`postgres`) for the host

![Webadminer](images/launch-webadminer-1.png)
![Webadminer](images/launch-webadminer-2.png)
![Webadminer](images/launch-webadminer-3.png)

## Sample Data

The database comes pre-populated with sample tables:
- `users` - Sample user accounts
- `products` - Sample product catalog

A useful Postgres command cheat sheet can be found [here](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546).

For example:
* `\l` - List databases
* `\c __database__` - Connect to a database (e.g. `\c postgres`)

## Customization

### Adding New Tables
Add SQL files to the `init-scripts/` directory. They will run automatically when the database is first created.

### Changing Database Settings
Modify the environment variables in `docker-compose.yml`:
- `POSTGRES_DB` - Database name
- `POSTGRES_USER` - Username
- `POSTGRES_PASSWORD` - Password

### Security Note
The default credentials are for development only. Change them for any production use.

## Persistence

Data is stored in a Docker volume named `postgres_data` which persists across Codespace sessions. Your data will be maintained even if you stop and restart your Codespace.

## Troubleshooting

### Database not starting?
Check the container logs:
```bash
docker-compose logs postgres
```

### Can't connect from outside?
Ensure port 5432 is set to "Public" visibility in the Ports tab of your Codespace.

### Need to reset the database?
Remove the volume and restart:
```bash
docker-compose down -v
docker-compose up -d
```

## SSH Port Forwarding

## Modified Command for Postgres
```bash
gh codespace ssh --codespace <your-codespace-name> -- -N -L 5432:localhost:5432
```

## Finding Your Codespace Name
First, list your codespaces to get the exact name:
```bash
gh codespace list
```

This will show output like:
```
NAME                    REPOSITORY          BRANCH    STATE
username-repo-abc123    username/repo       main      Available
```

Use the name from the NAME column.

## Complete Example
If your codespace name is `username-repo-abc123`:
```bash
gh codespace ssh --codespace username-repo-abc123 -- -N -L 5432:localhost:5432
```

## Alternative: Use Different Local Port
If you already have Postgres running locally on port 5432, forward to a different local port:
```bash
gh codespace ssh --codespace username-repo-abc123 -- -N -L 15432:localhost:5432
```

Then connect to `localhost:15432` instead.

## Connecting to Postgres
After the tunnel is established, connect from your local machine:
```bash
psql -h localhost -p 5432 -U your_username -d your_database
```

Or if using the alternative port:
```bash
psql -h localhost -p 15432 -U your_username -d your_database
```

The tunnel will stay active until you stop the command (Ctrl+C).

You can also use a Database Client App like TablePlus to connect

![tableplus](image/tableplus-1.png)
![tableplus](image/tableplus-2.png)
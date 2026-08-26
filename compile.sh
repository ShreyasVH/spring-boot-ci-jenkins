export VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec)

docker compose -f docker-compose.yml build --no-cache

docker compose -f docker-compose-dev.yml build --no-cache
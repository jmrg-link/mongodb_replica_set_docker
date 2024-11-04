# Configuración de MongoDB Replica Set con Docker Compose

## Descripción

Este proyecto implementa un cluster de MongoDB con replica set utilizando Docker Compose. Consiste en un nodo primario, dos nodos secundarios y un árbitro, proporcionando alta disponibilidad y redundancia de datos.

## Estructura del Proyecto

```text
mongodb-replica-set/
├── .env                    # Variables de entorno
├── docker-compose.yml      # Configuración de Docker Compose
└── scripts/
    ├── setup.sh           # Script de inicialización
    └── mongo-replica.key  # Clave de autenticación para el replica set
```

## Configuración

### Variables de Entorno (.env)

```dotenv
# MongoDB Configuration
MONGO_VERSION=8.0.1
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=PassWorD_2024_
MONGO_REPLICA_SET_NAME=rs0
MONGO_PORT=27017

# Node Names
MONGO_PRIMARY=mongo-1
MONGO_SECONDARY_1=mongo-2
MONGO_SECONDARY_2=mongo-3
MONGO_ARBITER=mongo-4

# Priorities
MONGO_PRIMARY_PRIORITY=3
MONGO_SECONDARY_PRIORITY=2
MONGO_ARBITER_PRIORITY=0
```

## Requisitos Previos

- Docker y Docker Compose instalados
- OpenSSL para generar la clave de réplica
- Acceso a puertos necesarios (27017)

## Instalación y Configuración

### 1. Generar Clave de Réplica

```bash
# Crear directorio scripts si no existe
mkdir -p scripts

# Generar clave de réplica
openssl rand -base64 756 > scripts/mongo-replica.key
chmod 400 scripts/mongo-replica.key
```

### 2. Configurar Hosts

Agregar las siguientes entradas al archivo hosts:

- **Windows:** `C:\Windows\System32\drivers\etc\hosts`
- **Linux/Mac:** `/etc/hosts`

```text
127.0.0.1 mongo-1 mongo-2 mongo-3 mongo-4
```

### 3. Iniciar el Cluster

```bash
# Iniciar servicios
docker-compose up -d

# Verificar estado de los contenedores
docker-compose ps
```

## Verificación del Cluster

### 1. Verificar Estado del Replica Set

```bash
docker exec -it mongo-1 mongosh --host mongo-1:27017 -u admin -p PassWorD_2024_ --eval "rs.status()"
```

### 2. Conectar desde MongoDB Compass

URI de conexión:

```text
mongodb://admin:PassWorD_2024_@mongo-1:27017,mongo-2:27017,mongo-3:27017,mongo-4:27017/admin?replicaSet=rs0
```

## Arquitectura del Cluster

### Componentes

1. **Nodo Primario (mongo-1)**
   - Prioridad: 3
   - Puerto expuesto: 27017
   - Maneja todas las operaciones de escritura

2. **Nodos Secundarios (mongo-2, mongo-3)**
   - Prioridad: 2
   - Réplicas sincronizadas del primario
   - Proporcionan redundancia y alta disponibilidad

3. **Árbitro (mongo-4)**
   - Prioridad: 0
   - No almacena datos
   - Participa en elecciones de nodo primario

### Volúmenes

- Cada nodo tiene volúmenes separados para:
  - Datos (`mongo_db_[1-4]`)
  - Configuración (`mongo_configdb_[1-4]`)

## Administración

### Comandos Útiles

1. **Iniciar el Cluster**

    ```bash
    docker-compose up -d
    ```

1. **Detener el Cluster**

    ```bash
    docker-compose down
    ```

1. **Ver Logs**

    ```bash
    docker-compose logs -f
    ```

1. **Acceder al Shell de MongoDB**

    ```bash
    docker exec -it mongo-1 mongosh --host mongo-1:27017 -u admin -p PassWorD_2024_
    ```

   1. **Acceder al Shell de MongoDB Config**

      ```bash
      docker logs -f mongo-setup
      ```

4.1 **Acceder al shell de MongoDB Config**

```bash
docker logs -f mongo-setup
```

- **Texto:** Log de inicialización de mongodb.

```text
###### Esperando el inicio de la instancia mongo-1.....
###### Instancia mongo-1 en funcionamiento, iniciando configuración de usuario e inicializando el  conjunto de réplicas..
Current Mongosh Log ID: 6728d7b7aa9d79ee0afe6910
Connecting to:          mongodb://mongo-1:27017/?directConnection=true&appName=mongosh+2.3.2
Using MongoDB:          8.0.1
Using Mongosh:          2.3.2

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

test> 
test> 
test> 
test> { ok: 1 }
test> ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
test> { ok: 1 }
test> {
  set: 'rs0',
  date: ISODate('2024-11-04T14:18:32.122Z'),
  myState: 2,
  term: Long('0'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 3,
  writeMajorityCount: 3,
  votingMembersCount: 4,
  writableVotingMembersCount: 3,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
    lastCommittedWallTime: ISODate('2024-11-04T14:18:31.992Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
    appliedOpTime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
    durableOpTime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
    writtenOpTime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
    lastAppliedWallTime: ISODate('2024-11-04T14:18:31.992Z'),
    lastDurableWallTime: ISODate('2024-11-04T14:18:31.992Z'),
    lastWrittenWallTime: ISODate('2024-11-04T14:18:31.992Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1730729911, i: 1 }),
  members: [
    {
      _id: 0,
      name: 'mongo-1:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 3,
      optime: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
      optimeDate: ISODate('2024-11-04T14:18:31.000Z'),
      optimeWritten: { ts: Timestamp({ t: 1730729911, i: 1 }), t: Long('-1') },
      optimeWrittenDate: ISODate('2024-11-04T14:18:31.000Z'),
      lastAppliedWallTime: ISODate('2024-11-04T14:18:31.992Z'),
      lastDurableWallTime: ISODate('2024-11-04T14:18:31.992Z'),
      lastWrittenWallTime: ISODate('2024-11-04T14:18:31.992Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 1,
      configTerm: 0,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'mongo-2:27017',
      health: 1,
      state: 0,
      stateStr: 'STARTUP',
      uptime: 0,
      optime: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDurable: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeWritten: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeDurableDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeWrittenDate: ISODate('1970-01-01T00:00:00.000Z'),
      lastAppliedWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastDurableWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastWrittenWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastHeartbeat: ISODate('2024-11-04T14:18:32.063Z'),
      lastHeartbeatRecv: ISODate('1970-01-01T00:00:00.000Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: -2,
      configTerm: -1
    },
    {
      _id: 2,
      name: 'mongo-3:27017',
      health: 1,
      state: 0,
      stateStr: 'STARTUP',
      uptime: 0,
      optime: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDurable: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeWritten: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeDurableDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeWrittenDate: ISODate('1970-01-01T00:00:00.000Z'),
      lastAppliedWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastDurableWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastWrittenWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastHeartbeat: ISODate('2024-11-04T14:18:32.063Z'),
      lastHeartbeatRecv: ISODate('1970-01-01T00:00:00.000Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: -2,
      configTerm: -1
    },
    {
      _id: 3,
      name: 'mongo-4:27017',
      health: 1,
      state: 0,
      stateStr: 'STARTUP',
      uptime: 0,
      lastHeartbeat: ISODate('2024-11-04T14:18:32.063Z'),
      lastHeartbeatRecv: ISODate('1970-01-01T00:00:00.000Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: -2,
      configTerm: -1
    }
  ],
  ok: 1
}
test> Configuración completada...
```

### Comandos de Mantenimiento

1.**Verificar Configuración del Replica Set**

```javascript
rs.conf()
```

2.**Verificar Estado del Cluster**

```javascript
rs.status()
```

3.**Verificar Nodo Primario**

```javascript
rs.isMaster()
```

### Comandos de Mantenimiento desde Docker

- Ver el estado del miembro actual

```bash
docker exec -it rs_mongo1 mongosh -u {user} -p {password} --eval "rs.isMaster()"
```

- Ver información más detallada del replicaset

```bash
docker exec -it rs_mongo1 mongosh -u {user} -p {password} --eval "rs.status()"
```

- Ver la configuración actual del replicaset

```bash
docker exec -it rs_mongo1 mongosh -u {user} -p {password} --eval "rs.conf()"
```

## Seguridad

- Autenticación habilitada con usuario y contraseña
- Comunicación entre nodos asegurada con keyfile
- Acceso restringido a puertos necesarios

## Respaldo y Restauración

### Crear Backup

```bash
docker exec mongo-1 mongodump --host mongo-1:27017 -u admin -p PassWorD_2024_ --out /backup
```

### Restaurar Backup

```bash
docker exec mongo-1 mongorestore --host mongo-1:27017 -u admin -p PassWorD_2024_ /backup
```

### Conexion MongoDB Compass

```bash
mongodb://{user}:{password}_@mongo-1:27017,mongo-2:27017,mongo-3:27017,mongo-4:27017/admin?replicaSet=rs0
```

### Conexion MongoDB Terminal

```bash
mongosh "mongodb://{user}:{password}_@mongo-1:27017,mongo-2:27017,mongo-3:27017,mongo-4:27017/admin?replicaSet=rs0"
```

## Monitoreo

- Estado del replica set mediante `rs.status()`
- Logs de contenedores con `docker-compose logs`
- Métricas de MongoDB a través de MongoDB Compass

## Solución de Problemas

1. **Error de Conexión**
   - Verificar estado de contenedores
   - Comprobar archivo hosts
   - Verificar permisos de mongo-replica.key

2. **Problemas de Sincronización**
   - Revisar logs de contenedores
   - Verificar conectividad entre nodos
   - Comprobar estado del replica set

3. **Error de Autenticación**
   - Verificar credenciales
   - Comprobar permisos de mongo-replica.key
   - Verificar configuración de autenticación

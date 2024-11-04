#!/bin/bash
m1=mongo-1
m2=mongo-2
m3=mongo-3
m4=mongo-4
port=27017

echo "###### Esperando el inicio de la instancia ${m1}.."
until mongosh --host ${m1}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1
done
echo "###### Instancia ${m1} en funcionamiento, iniciando configuración de usuario e inicializando el conjunto de réplicas.."

# Recuperar variables de entorno
rootUser="${MONGO_INITDB_ROOT_USERNAME}"
rootPassword="${MONGO_INITDB_ROOT_PASSWORD}"
replicaSetName="${MONGO_REPLICA_SET_NAME}"
primaryPriority="${MONGO_PRIMARY_PRIORITY}"
secondaryPriority="${MONGO_SECONDARY_PRIORITY}"
arbiterPriority="${MONGO_ARBITER_PRIORITY}"

# Configurar usuario y contraseña e inicializar conjuntos de réplicas
mongosh --host ${m1}:${port} <<EOF
var rootUser = '$rootUser';
var rootPassword = '$rootPassword';
var admin = db.getSiblingDB('admin');
admin.auth(rootUser, rootPassword);
var config = {
    "_id": "$replicaSetName",
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": "${m1}:${port}",
            "priority": $primaryPriority
        },
        {
            "_id": 1,
            "host": "${m2}:${port}",
            "priority": $secondaryPriority
        },
        {
            "_id": 2,
            "host": "${m3}:${port}",
            "priority": $secondaryPriority
        },
        {
            "_id": 3,
            "host": "${m4}:${port}",
            "arbiterOnly": true,
            "priority": $arbiterPriority
        }
    ]
};
rs.initiate(config, { force: true });
rs.status();
EOF
echo "Configuración completada..."

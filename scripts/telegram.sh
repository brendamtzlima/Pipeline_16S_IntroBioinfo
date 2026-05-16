#!/bin/bash

#------------------------------------------
#-- Script para enviar mensajes a Telegram
#------------------------------------------
# Brenda Martínez Lima
# Mayo 2026

# Cargar credenciales
source "$(dirname "$0")/../.env"

# Mensaje recibido
MENSAJE="$1"

# Enviar mensaje
curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="$MENSAJE"
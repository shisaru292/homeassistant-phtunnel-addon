#!/usr/bin/with-contenv bashio
# Timezone configuration
bashio::log.info "Setting up timezone($TZ)..."
if [ -f /etc/localtime ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

# Use bashio for log output to keep multi-line qrcode logs intact
bashio::log.info "Setting up logging via named pipe..."
# 1. Create a named pipe
LOG_PIPE=/tmp/log_pipe.log
mkfifo $LOG_PIPE

# 2. Read logs from pipe in background and send to bashio
while read -r line; do
  # Simple log level classification based on content
  if [[ "$line" == *"ERROR:"* ]]; then
    bashio::log.error "${line}"
  elif [[ "$line" == *"WARNING:"* ]]; then
    bashio::log.warning "${line}"
  else
    bashio::log.info "${line}"
  fi
done < $LOG_PIPE &

bashio::log.info "Starting the main application..."

# 3. Start the application with log output redirected to named pipe
#    Use /data/ path for persistence
#    Note: Program must run in foreground (do not use &)
exec /usr/bin/phtunnel --log $LOG_PIPE --config /data/phtunnel.json
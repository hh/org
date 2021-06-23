

# Stop the database

if [ "${ASN_DATA_PIPELINE_RETAIN}" = true ]; then
    exit 0
fi

(
  until [ "$(cat /proc/1/cmdline | tr '\0' '\n' | head -n 1)" = "postgres" ]; do
    sleep 1s
  done
  pg_ctl kill QUIT 1
) &



# Stop the database

if [ ! "${ASN_DATA_PIPELINE_RETAIN:-}" = true ]; then
    # in the Postgres container image,
    # the command run changes to "postgres" once it's completed loading up
    # and is in a ready state
    #
    # here we wait for that state and attempt to exit cleanly, without error
    (
        until [ "$(cat /proc/$PPID/cmdline | tr '\0' '\n' | head -n 1)" = "postgres" ]; do
            sleep 1s
        done
        # exit Postgres with a code of 0
        pg_ctl kill QUIT 1
    ) &
fi

#!/bin/bash

# set -ex

# Remove lingering GPG lock file
# Otherwise DB will stay locked when running entrypoint.sh multiple times
rm -f /root/.gnupg/public-keys.d/pubring.db.lock

# Initialize
if [[ $1 == "init" ]]; then
    cat > gpgparams <<EOF
        %no-protection
        %echo Generating a basic OpenPGP key
        Key-Type: RSA
        Key-Length: 4096
        Name-Real: pass-key
        Expire-Date: 0
        %commit
        %echo done
EOF

    # Initialize pass
    gpg --generate-key --batch gpgparams
    pass init pass-key
    rm gpgparams
    
    # Kill the other instance as only one can be running at a time.
    # This allows users to run entrypoint init inside a running conainter
    # which is useful in a k8s environment.
    # || true to make sure this would not fail in case there is no running instance.
    pkill protonmail-bridge || true

    # Login
    /protonmail/proton-bridge --cli "$@"

else

    # socat will make the conn appear to come from 127.0.0.1
    # ProtonMail Bridge currently expects that.
    # It also allows us to bind to the real ports :)
    socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
    socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

    # Start protonmail
    # Fake a terminal, so it does not quit because of EOF...
    rm -f faketty
    mkfifo faketty
    cat faketty | /protonmail/proton-bridge --cli "$@"
fi
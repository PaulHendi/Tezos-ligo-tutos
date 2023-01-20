PROTOCOL=ProtoALphaALphaALphaALphaALphaALphaALphaALphaDdp3zK
MOCKUP_DIR=/tmp/mockup
FILENAME=increment
INITIAL_STORAGE=10


compile() {

    ligo compile contract ${FILENAME}.mligo -o ${FILENAME}.tz

}

param_to_michelson(){

    ligo compile parameter ${FILENAME}.mligo $1         # Ex : "Increment(32)"

}

start_mockup() {

    octez-client --protocol $PROTOCOL --base-dir $MOCKUP_DIR --mode mockup create mockup

} 

originate() {

    octez-client --protocol $PROTOCOL --base-dir $MOCKUP_DIR --mode mockup \
                originate contract mockup_testme \
                                  transferring 0 from bootstrap1 \
                                  running ${LIGO_FILE}.tz \
                                  --init $INITIAL_STORAGE --burn-cap 0.1

}


query() {

    octez-client --protocol $PROTOCOL --base-dir $MOCKUP_DIR --mode mockup get contract storage for mockup_testme

}




transaction() {

    octez-client --protocol $PROTOCOL --base-dir $MOCKUP_DIR --mode mockup \
                 transfer 0 from bootstrap2 \
                 to mockup_testme \
                 --arg $1 --burn-cap 0.01    # Ex : "(Left (Right 32))"


}

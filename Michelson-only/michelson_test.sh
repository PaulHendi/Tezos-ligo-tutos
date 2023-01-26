PROTOCOL=ProtoALphaALphaALphaALphaALphaALphaALphaALphaDdp3zK
MOCKUP_DIR=tmp/mockup
FILENAME=todo_list
INITIAL_STORAGE=("", "False")



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




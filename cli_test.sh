LIGO_FILE=increment.mligo

run() {

    ligo run interpret $1 --init-file ${LIGO_FILE} # Ex : "add(10,32)"

}

dry_run() {

    ligo run dry-run ${LIGO_FILE} $1 $2            #Ex : "Increment(32)" "10"

}






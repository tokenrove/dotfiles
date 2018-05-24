# stolen from https://github.com/fsaintjacques/dot -- thanks FSJ!
set history save
set confirm off
set verbose off
set print pretty on
set print array off
set print array-indexes on
set python print-stack full
set disassembly-flavor intel

# make cmocka raise SIGABRT on failed asserts when debuging
set environment CMOCKA_TEST_ABORT=1

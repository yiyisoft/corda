set (EXE "amqp-test")

set (amqp-test-sources
        main.cxx
        Map.cxx
        Pair.cxx
        List.cxx
        Single.cxx
        TestUtils.cxx
        RestrictedDescriptor.cxx
        OrderedTypeNotationTest.cxx
)

link_directories (${BLOB-INSPECTOR_BINARY_DIR}/src/amqp)

add_executable (${EXE} ${amqp-test-sources})

target_link_libraries (${EXE} gtest amqp)

if (UNIX)
    target_link_libraries (${EXE} pthread qpid-proton proton)
endif (UNIX)

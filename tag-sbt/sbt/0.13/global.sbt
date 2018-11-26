cancelable in Global := true

target := baseDirectory { file("/tmp/sbt/") / _.toString }.value

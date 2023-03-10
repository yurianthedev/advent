ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.2.1"

lazy val root = (project in file("."))
  .settings(
    name := "aoc_scala",
    libraryDependencies ++= Seq(
      "org.typelevel" %% "cats-core"   % "2.6.1",
      "org.typelevel" %% "cats-effect" % "3.2.8",
      "co.fs2"        %% "fs2-core"    % "3.2.2",
      "co.fs2"        %% "fs2-io"      % "3.2.2"
    )
  )

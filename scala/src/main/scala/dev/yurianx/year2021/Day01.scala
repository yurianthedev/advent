package dev.yurianx.year2021

import cats.Applicative
import cats.effect.{ExitCode, IO, IOApp}
import cats.implicits.*
import dev.yurianx.utils.IOUtils

import scala.annotation.tailrec

object Day01 extends IOApp {

  override def run(args: List[String]): IO[ExitCode] = (for {
    solve1 <- solve
    solve2 <- solveSecondStar
    _      <- IO.println(solve1)
    _      <- IO.println(solve2)
  } yield ()).as(ExitCode.Success)


  def solve: IO[Int] = for {
    filePath <- IOUtils.getPath[IO]("day01_input.txt")
    lines    <- IOUtils.readFile(filePath)
    count    <-
      countIncreases[IO](
        lines.map(_.toInt)
      )
  } yield count

  def solveSecondStar: IO[Int] = for {
    filePath <- IOUtils.getPath[IO]("day01_input.txt")
    lines    <- IOUtils.readFile(filePath)

    triples = mapTriples(lines.map(_.toInt))

    count <-
      countIncreases[IO](
        triples
      )
  } yield count

  def countIncreases[F[_]: Applicative](
      depthsList: Seq[Int]
  ): F[Int] =
    depthsList
      .zip(depthsList.tail)
      .foldRight(0) { (pair, acc) =>
        if (pair._1 < pair._2) acc + 1
        else acc
      }
      .pure

  def mapTriples(depthLists: Seq[Int]): Seq[Int] = {

    @tailrec
    def exec(
        res: Seq[Int],
        pending: Seq[Int]
    ): Seq[Int] = pending match {
      case Seq(x, y, z)     => res :+ (x + y + z)
      case Seq(x, y, z, _*) => exec(res :+ (x + y + z), pending.tail)
      case xs               => throw Exception(s"xs has less than 3 elements $xs")
    }

    exec(Vector(), depthLists)
  }
}

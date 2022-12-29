package dev.yurianx.year2021

import cats.Applicative
import cats.effect.{ExitCode, IO, IOApp}
import cats.implicits.*
import dev.yurianx.utils.IOUtils

object Day02 extends IOApp {

  type InstructionLine = (Instruction, Int)

  override def run(args: List[String]): IO[ExitCode] =
    (for {
      res <- solve
      _   <- IO.println(res)
    } yield ()).as(ExitCode.Success)

  def solve: IO[Int] = for {
    filePath    <- IOUtils.getPath[IO]("day02_input.txt")
    lines       <- IOUtils.readFile(filePath)
    mappedLines <- mapLineToInstructionLine[IO](lines)
    pos         <- findPos[IO](mappedLines)
    posWithAim  <- findPosWithAim[IO](mappedLines)
  } yield posWithAim._1 * posWithAim._2

  def findPos[F[_]: Applicative](list: Seq[InstructionLine]): F[(Int, Int)] =
    list
      .foldRight((0, 0)) {
        case ((Instruction.Forward, v), acc) => (acc._1 + v, acc._2)
        case ((Instruction.Down, v), acc)    => (acc._1, acc._2 + v)
        case ((Instruction.Up, v), acc)      => (acc._1, acc._2 - v)
      }
      .pure

  def findPosWithAim[F[_]: Applicative](
                                         list: Seq[InstructionLine]
                                       ): F[(Int, Int, Int)] = {
    println(list)

    list
      .foldLeft((0, 0, 0)) {
        case ((horizontal, depth, aim), (Instruction.Forward, v)) =>
          (horizontal + v, depth + (aim * v), aim)
        case ((horizontal, depth, aim), (Instruction.Down, v))    =>
          (horizontal, depth, aim + v)
        case ((horizontal, depth, aim), (Instruction.Up, v))      =>
          (horizontal, depth, aim - v)
      }
      .pure
  }

  def mapLineToInstructionLine[F[_]: Applicative](
                                                   list: Seq[String]
                                                 ): F[Seq[InstructionLine]] =
    list.map { s =>
      val ss = s.split(' ')
      (Instruction.valueOf(ss(0).capitalize), ss(1).toInt)
    }.pure

  enum Instruction {
    case Forward
    case Down
    case Up
  }
}

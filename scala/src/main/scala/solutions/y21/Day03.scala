package land.yurian
package solutions.y21

import cats.Applicative
import cats.effect.ExitCode
import cats.effect.IO
import cats.effect.IOApp
import cats.implicits.*

import scala.annotation.tailrec

import utils.IOUtils

object Day03 extends IOApp {

  type Binary = Seq[Byte]

  override def run(args: List[String]): IO[ExitCode] = (for {
    sample <- solve("day03_sample_input.txt")
    _      <- IO.println(sample._1 == 198)
    _      <- IO.println(sample._2 == 230)
    _      <- IO.println(sample)
    real   <- solve("day03_input.txt")
    _      <- IO.println(real)
  } yield ()).as(ExitCode.Success)

  def solve(fileName: String): IO[(Int, Int)] = for {
    filePath      <- IOUtils.getPath[IO](fileName)
    lines         <- IOUtils.readFile(filePath)
    binaries      <- convertToBinary[IO](lines)
    processedList <- process[IO](binaries)
    gamma          = genGamma(processedList)
    epsilon        = genEpsilon(gamma)
    gammaInt       = binaryToInt(gamma)
    epsilonInt     = binaryToInt(epsilon)
    or             = genOxygenRating(processedList, binaries)
    orInt          = binaryToInt(or)
    co2            = genCO2Rating(processedList, binaries)
    co2Int         = binaryToInt(co2)
  } yield (gammaInt * epsilonInt, orInt * co2Int)

  def convertToBinary[F[_]: Applicative](lines: Seq[String]): F[Seq[Binary]] =
    lines.map(_.map(_.asDigit.toByte)).pure

  def binaryToInt(binary: Binary): Int = Integer.parseInt(binary.mkString, 2)

  def process[F[_]: Applicative](seq: Seq[Binary]): F[Seq[Seq[Byte]]] =
    seq.transpose.pure

  def mostRepeated(list: Seq[Byte]): Byte =
    val values    = list.groupBy(identity).values
    val valuesLen = values.map(_.length)

    if (valuesLen.forall(_ == valuesLen.head)) 1.toByte
    else values.maxBy(_.length).head

  def inverseByte(byte: Byte): Byte = byte match {
    case 1 => 0
    case 0 => 1
  }

  def genGamma(processedList: Seq[Seq[Byte]]): Binary =
    processedList.map(mostRepeated)

  def genEpsilon(gamma: Binary): Binary =
    gamma.map(inverseByte)

  def genRating(
      transposed: Seq[Seq[Byte]],
      binaries: Seq[Binary],
      transformation: Byte => Byte
  ): Binary =
    transposed
      .foldLeft((0, binaries)) { case ((pos, candidates), _) =>
        (
          pos + 1, {
            val filteredCandidates = candidates.filter(b =>
              val ct = candidates.transpose
              b(pos) == transformation(mostRepeated(ct(pos)))
            )
            if (candidates.sizeIs > 1 && filteredCandidates.sizeIs > 0)
              filteredCandidates
            else candidates
          }
        )
      }
      ._2
      .head

  def genOxygenRating(
      transposed: Seq[Seq[Byte]],
      binaries: Seq[Binary]
  ): Binary = genRating(transposed, binaries, identity)

  def genCO2Rating(
      transposed: Seq[Seq[Byte]],
      binaries: Seq[Binary]
  ): Binary = genRating(transposed, binaries, inverseByte)
}

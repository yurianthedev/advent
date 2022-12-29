package land.yurian
package utils

import cats.Applicative
import cats.effect.IO
import cats.effect.Resource
import cats.implicits.*

import java.io.*
import scala.io.Source

object IOUtils {

  def getPath[F[_]: Applicative](fileName: String): F[String] =
    this.getClass.getClassLoader.getResource(fileName).getPath.pure

  def readFile(filePath: String): IO[Seq[String]] = {
    IO(Source.fromFile(filePath)).bracket { source =>
      IO((for (line <- source.getLines) yield line).toVector)
    } { source =>
      IO(source.close())
    }
  }
}

class Bob {
  sealed abstract class Prompt
  case object Silence  extends Prompt
  case object Yell     extends Prompt
  case object Question extends Prompt
  case object Other    extends Prompt

  def hey(statement: String): String = response(classify(statement))

  def response(prompt: Prompt): String = prompt match {
    case Silence  => "Fine. Be that way!"
    case Yell     => "Woah, chill out!"
    case Question => "Sure."
    case Other    => "Whatever."
  }

  // No lower case letters with at least one upper case letter
  val yellingRE = "^[^\\p{Lower}]*\\p{Upper}[^\\p{Lower}]*$".r
  def classify(statement: String): Prompt = if (statement.trim == "") {
    Silence
  } else if (!yellingRE.findFirstMatchIn(statement).isEmpty) {
    Yell
  } else if (statement.endsWith("?")) {
    Question
  } else {
    Other
  }
}

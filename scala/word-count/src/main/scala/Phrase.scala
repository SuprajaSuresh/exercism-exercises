class Phrase(phrase:String) {
  private val findLowerWords = "['\\p{Lower}\\d]+".r.findAllIn(_)
  def wordCount:Map[String, Int] =
    findLowerWords(phrase.toLowerCase).foldLeft(Map.empty[String, Int]) {
      (m, word) => m + ((word, m.getOrElse(word, 0) + 1))
    }
}

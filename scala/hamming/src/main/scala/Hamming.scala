package object Hamming {
  def compute(a: String, b: String): Int =
    (0 until a.length.min(b.length)).foldLeft(0)(
      (acc, i) => if (a(i) != b(i)) 1 + acc else acc
    )
}

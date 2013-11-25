package object Hamming {
  def compute(a: String, b: String): Int =
    (0 until a.length.min(b.length)).count(i => a(i) != b(i))
}

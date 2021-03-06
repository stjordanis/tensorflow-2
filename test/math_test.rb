require_relative "test_helper"

class MathTest < Minitest::Test
  def test_abs
    assert_equal 1, Tf.abs(Tf.constant(-1)).value
    assert_equal 1, Tf::Math.abs(Tf.constant(-1)).value
  end

  def test_add
    a = Tf.constant(2)
    b = Tf.constant(3)
    assert_equal 5, (a + b).value
    assert_equal 5, Tf.add(a, b).value
    assert_equal 5, Tf::Math.add(a, b).value
  end

  def test_divide
    a = Tf.constant(3.0)
    b = Tf.constant(2.0)
    assert_in_delta 1.5, (a / b).value
    assert_in_delta 1.5, Tf.divide(a, b).value
    assert_in_delta 1.5, Tf::Math.divide(a, b).value
  end

  def test_equal
    x = Tf.constant([2, 4])
    y = Tf.constant(2)
    assert_equal [true, false], Tf.equal(x, y).value
    assert_equal [true, false], Tf::Math.equal(x, y).value

    x = Tf.constant([2, 4])
    y = Tf.constant([2, 4])
    assert_equal [true, true], Tf.equal(x, y).value
    assert_equal [true, true], Tf::Math.equal(x, y).value
  end

  def test_logical_xor
    x = Tf.constant([false, false, true, true])
    y = Tf.constant([false, true, false, true])
    assert_equal [false, true, true, false], Tf::Math.logical_xor(x, y).value
  end

  def test_log_sigmoid
    assert_in_delta -0.31326166, Tf::Math.log_sigmoid(1.0).value
  end

  def test_multiply
    a = Tf.constant(2)
    b = Tf.constant(3)
    assert_equal 6, (a * b).value
    assert_equal 6, Tf.multiply(a, b).value
    assert_equal 6, Tf::Math.multiply(a, b).value

    a = Tf.constant([[1, 2], [3, 4]])
    b = Tf.add(a, 1)
    assert_equal [[2, 6], [12, 20]], (a * b).value
  end

  def test_negative
    assert_equal [-1, -2], Tf.negative([1, 2]).value
  end

  def test_reduce_any
    x = Tf.constant([[true, true], [false, false]])
    assert_equal true, Tf.reduce_any(x).value
    assert_equal [true, true], Tf.reduce_any(x, axis: 0).value
    assert_equal [true, false], Tf.reduce_any(x, axis: 1).value
  end

  def test_reduce_max
    x = Tf.constant([[1, 2], [3, 4]])
    assert_equal 4, Tf.reduce_max(x).value
    assert_equal [3, 4], Tf.reduce_max(x, axis: 0).value
    assert_equal [2, 4], Tf.reduce_max(x, axis: 1).value
  end

  def test_reduce_mean
    x = Tf.constant([[1.0, 1.0], [2.0, 2.0]])
    assert_equal 1.5, Tf.reduce_mean(x).value
    assert_equal [1.5, 1.5], Tf.reduce_mean(x, axis: 0).value
    assert_equal [1.0, 2.0], Tf.reduce_mean(x, axis: 1).value
  end

  def test_reduce_min
    x = Tf.constant([[1, 2], [3, 4]])
    assert_equal 1, Tf.reduce_min(x).value
    assert_equal [1, 2], Tf.reduce_min(x, axis: 0).value
    assert_equal [1, 3], Tf.reduce_min(x, axis: 1).value
  end

  def test_reduce_prod
    x = Tf.constant([[1, 2], [3, 4]])
    assert_equal 24, Tf.reduce_prod(x).value
    assert_equal [3, 8], Tf.reduce_prod(x, axis: 0).value
    assert_equal [2, 12], Tf.reduce_prod(x, axis: 1).value
  end

  def test_reduce_std
    x = Tf.constant([[1.0, 2.0], [3.0, 4.0]])
    assert_in_delta 1.1180339887498949, Tf::Math.reduce_std(x).value
    assert_equal [1.0, 1.0], Tf::Math.reduce_std(x, axis: 0).value
    assert_equal [0.5, 0.5], Tf::Math.reduce_std(x, axis: 1).value
  end

  def test_reduce_sum
    x = Tf.constant([[1, 1, 1], [1, 1, 1]])
    assert_equal 6, Tf.reduce_sum(x).value
    assert_equal [2, 2, 2], Tf.reduce_sum(x, axis: 0).value
    assert_equal [3, 3], Tf.reduce_sum(x, axis: 1).value
    assert_equal [[3], [3]], Tf.reduce_sum(x, axis: 1, keepdims: true).value
    assert_equal 6, Tf.reduce_sum(x, axis: [0, 1]).value
  end

  def test_reduce_variance
    x = Tf.constant([[1.0, 2.0], [3.0, 4.0]])
    assert_equal 1.25, Tf::Math.reduce_variance(x).value
    assert_equal [1, 1], Tf::Math.reduce_variance(x, axis: 0).value
    assert_equal [0.25, 0.25], Tf::Math.reduce_variance(x, axis: 1).value
  end

  def test_sin
    assert_equal [0, 1], Tf.sin([0.0, 0.5 * Math::PI]).value
    assert_equal [0, 1], Tf::Math.sin([0.0, 0.5 * Math::PI]).value
  end

  def test_sqrt
    assert_equal [2.0, 3.0], Tf.sqrt([4.0, 9.0]).value
    assert_equal [2.0, 3.0], Tf::Math.sqrt([4.0, 9.0]).value
  end

  def test_subtract
    a = Tf.constant(2)
    b = Tf.constant(3)
    assert_equal -1, (a - b).value
    assert_equal -1, Tf.subtract(a, b).value
    assert_equal -1, Tf::Math.subtract(a, b).value
  end
end

require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def score(dice)
  score = 0
  # if dice.empty? then return score end
  # initialise counter hash
  counter = Hash.new

  i = 1
  while i <= dice.length
    # determine array position of current dice value
    array_index = i - 1

    # and select hash key from current dice value
    key = dice[array_index].to_s

    # create hash key if it doesn't exist
    counter[key] || counter[key] = 0

    # increment corresponding hash key to count
    counter[key] += 1
    i += 1
  end

  # after creating counting hash, tally scores
  counter.each do |key, value|
    remainder = 0
    three_or_more = value >= 3 ? true : false
    # add set scores
    if three_or_more
      remainder = value % 3
      counter[key] -= 3
      if key == '1'
        score += 1000
      else
        score += key.to_i * 100
      end
    end
    # add remainder from sets to score
    if remainder > 0
      if key == '1'
        score += remainder * 100
      elsif key == '5'
        score += remainder * 50
      end
      counter[key] -= remainder
    elsif counter[key] > 0
      if key == '1'
        score += key.to_i * 100 * counter[key]
      elsif key == '5'
        score += key.to_i * 10 * counter[key]
      end
    end
  end
  
  score
end



# alternative solutions
# create a hash that stores the value as a key, and the value as a counter (more elegant?)
# store in an array using the value as position
# use native array methods to count identical dice and score
# use native array methods to remove counted dice from remaining array
# use modulo to determine sets and then additional scores of same number

class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
    assert_equal 1100, score([1,1,1,1])
    assert_equal 1200, score([1,1,1,1,1])
    assert_equal 1150, score([1,1,1,5,1])
  end

end

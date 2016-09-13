require 'test_helper'

# Tests for reviewstatus model
class ReviewStatusTest < ActiveSupport::TestCase
  def setup
    @review_status = review_statuses(:never)
  end

  test 'should be valid' do
    assert @review_status.valid?
  end

  test 'name should be present' do
    @review_status.name = '  '
    assert_not @review_status.valid?
  end

  test 'request type without associated records can be deleted' do
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      @review_status.destroy
    end
  end

  test 'request type with associated records cannot be deleted' do
    review_status = review_statuses(:started)
    assert_raise ActiveRecord::DeleteRestrictionError do
      review_status.destroy
    end
  end
end

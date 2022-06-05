require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:thoughts) }
  it { should validate_presence_of(:rating) }

  it { should validate_length_of(:title).is_at_least(3).is_at_most(25) }
  it { should validate_length_of(:thoughts).is_at_least(5).is_at_most(100) }
  it { should validate_inclusion_of(:rating).in_array([1, 2, 3, 4, 5]) }
end

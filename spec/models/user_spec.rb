require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:movies) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('nonuser@domain.com').for(:email) }
  it { should_not allow_value('john2example.com', 'john@examplecom').for(:email) }
end

require 'rails_helper'

describe Classroom do
  it { should have_many :students }
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :name }
end

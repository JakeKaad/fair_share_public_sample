require 'rails_helper'

describe Student do
  it { should belong_to :family }
  it { should belong_to :classroom }
  it { should have_many(:members).through(:family) }
  it { should have_and_belong_to_many(:school_years) }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }


  describe "Student#parse_students" do
    it "should create an array of one student when family only has one student" do
      expect(Student.parse_student_names("Jon Doe")).to eq ["Jon Doe"]
    end

    it "should create an array of two students when family has one student" do
      expect(Student.parse_student_names("Jon Doe and Jane Doe")).to eq ["Jon Doe", "Jane Doe"]
    end

    it "should create an array of three students when family has three students" do
      expect(Student.parse_student_names("Jon Doe, James Doe and Jane Doe")).to eq ["Jon Doe", "James Doe", "Jane Doe"]
    end

    it "should create an array of four students when family has four students" do
      expect(Student.parse_student_names("Jean Doe, Jon Doe, James Doe and Jane Doe")).to eq ["Jean Doe", "Jon Doe", "James Doe", "Jane Doe"]
    end
  end

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:student) }
    let(:archivable) { Student }
  end
end

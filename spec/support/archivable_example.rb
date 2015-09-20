shared_examples "archivable" do
  it "is archived by default" do
    expect(object.archived).to be_falsey
  end

  it "toggles archived to true" do
    object.toggle_archived
    expect(object.reload.archived).to be_truthy
  end

  it "toggles archived to false" do
    object.toggle_archived
    object.toggle_archived
    expect(object.reload.archived).to be_falsey
  end

  it "has the active scope" do
    expect(archivable.active).to eq [object]
  end

  it "has the archived scope" do
    object.toggle_archived
    expect(archivable.archived).to eq [object]
  end
end

shared_examples "archive_path" do
  it "redirects back" do
      action
      expect(response).to redirect_to redirect_path
    end

    it "sets the family archived to true" do
      action
      expect(object.reload.archived).to be_truthy
    end

    it "unarchives an archived family" do
      object.toggle_archived
      action
      expect(object.reload.archived).to be_falsey
    end

    it "archives members in family when family is archived" do
      if object.class == Family
        member = FactoryGirl.create(:member)
        object.members.push(member)
        action
        expect(member.reload.archived).to be_truthy
      end
    end

    it "archives students in family when family is archived" do
      if object.class == Family
        student = FactoryGirl.create(:student)
        object.students.push(student)
        action
        expect(student.reload.archived).to be_truthy
      end
    end
end

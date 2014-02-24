FactoryGirl.define do

  factory :tag do
    tagger_id nil
    taggee_id nil
    claimed Time.now
  end

end

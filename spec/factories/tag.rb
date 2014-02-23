FactoryGirl.define do

  factory :tag do
    tagger_id 1
    taggee_id 2
    claimed Time.now
  end

end

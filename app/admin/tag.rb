ActiveAdmin.register Tag do

  permit_params :tagger_id, :taggee_id, :claimed
  filter :claimed

  index do
    column :tagger
    column :taggee
    column :claimed
    column :source
  end

  controller do
    def new
      super do |format|
        @tag.source = :admin
      end
    end
    def edit
      super do |format|
        @tag.source = :admin
      end
    end
  end

end
class EntityTagConnection < ActiveRecord::Base

  belongs_to :taggable_entity, :polymorphic => true
  belongs_to :tag

end

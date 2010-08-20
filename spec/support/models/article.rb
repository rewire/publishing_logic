class Article < ActiveRecord::Base
  include PublishingLogic::ModelLogic
end

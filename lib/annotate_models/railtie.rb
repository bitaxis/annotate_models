require "annotate_models"
require "rails"

module AnnotateModels
  class Railtie < Rails::Railtie
    railtie_name :annotate_models
    rake_tasks do
      load "tasks/annotate_models.rake"
    end
  end
end

require "annotate_models/model_annotation_generator"

#-----
# Ruby tasks
#-----

task annotate: "annotate:all"

namespace :annotate do
  
  desc "Annotate everything"
  task :all => [:factories, :fixtures, :models, "test:models"]
  
  desc "Annotate factories"
  task :factories => :environment do
    puts "Annotating factories..."
    am = AnnotateModels::ModelAnnotationGenerator.new
    am.generate
    am.apply_to_factories
  end

  desc "Annotate fixtures"
  task :fixtures => :environment do
    puts "Annotating fixtures..."
    am = AnnotateModels::ModelAnnotationGenerator.new
    am.generate
    am.apply_to_fixtures
  end

  desc "Annotate ActiveRecord models"
  task :models => :environment do
    puts "Annotating models..."
    am = AnnotateModels::ModelAnnotationGenerator.new
    am.generate
    am.apply_to_models
  end
  
  desc "Print annotations"
  task :print => :environment do
    am = AnnotateModels::ModelAnnotationGenerator.new
    am.generate
    am.print
  end
  
  namespace :test do
    desc "Annotate model tests"
    task :models => :environment do
      puts "Annotating model tests..."
      am = AnnotateModels::ModelAnnotationGenerator.new
      am.generate
      am.apply_to_model_tests
    end
  end

end

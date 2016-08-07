module AnnotateModels

  ##
  # Class contains the Ruby code to generate the annotations
  #

  class ModelAnnotationGenerator
    
    def initialize
      @annotations = {}
    end

    ##
    # Apply annotations to a file
    # 
    # @param path [String] Relative path (from root of application) of directory to apply annotations to.
    # @param suffix [String] Optionally specify suffix of files to apply annotation to (e.g. "<model.name>_<suffix>.rb").
    # @param extension [String] Optionally specify extension of files to apply annotaations to (e.g. "<model.name>_<suffix>.<extension>").
    
    def apply_annotation(path, suffix=nil, extension="rb", plural=false)
      pn_models = Pathname.new(path)
      return unless pn_models.exist?
      suffix = "_#{suffix}" unless suffix == nil
      extension = (extension == nil) ? "" : ".#{extension}"
      @annotations.each do |model, annotation|
        prefix = (plural) ? model.name.pluralize : model.name
        pn = pn_models + "#{ActiveSupport::Inflector.underscore(prefix)}#{suffix}#{extension}"
        text = File.open(pn.to_path) { |fp| fp.read }
        re = Regexp.new("^#-(?:--)+-\n# #{model.name}.*\n(?:#.+\n)+#-(?:--)+-\n", Regexp::MULTILINE)
        if re =~ text
          text = text.sub(re, annotation)
        else
          text = "#{text}\n#{annotation}"
        end
        File.open(pn.to_path, "w") { |fp| fp.write(text) }
        puts "  Annotated #{pn.to_path}."
      end
    end
    
    def apply_to_factories
      self.apply_annotation("test/factories", suffix="factory")
    end
    
    def apply_to_fixtures
      self.apply_annotation("test/fixtures", suffix=nil, extension="yml", plural=true)
    end
    
    def apply_to_models
      self.apply_annotation("app/models")
    end
    
    def apply_to_model_tests
      self.apply_annotation("test/models", suffix="test")
    end
    
    ##
    # Gather model classes and generate annotation for each one.

    def generate
      Dir["app/models/*.rb"].each do |path|
        result = File.basename(path).scan(/^(.+)\.rb/)[0][0]
        model = eval(ActiveSupport::Inflector.camelize(result))
        next if model.respond_to?(:abstract_class) && model.abstract_class
        next unless model < ActiveRecord::Base
        @annotations[model] = generate_annotation(model) unless @annotations.keys.include?(model)
      end
    end

    ##
    # Print out the annotation text.
    
    def print
      @annotations.values.sort.each do |annotation|
        puts annotation
        puts
      end
    end
    
    private
      
    ##
    # Generate annotation text.
    # @param model [Class] An ActiveRecord model class.

    def generate_annotation(model)
      max_column_length = model.columns.collect { |c| c.name.length }.max
      annotation = []
      annotation << "#-#{'--' * 38}-"
      annotation << "# #{model.name}"
      annotation << "#"
      annotation << sprintf("# %-#{max_column_length}s SQL Type             Null    Default Primary", "Name")
      annotation << sprintf("# %s -------------------- ------- ------- -------", "-" * max_column_length)
      format = "# %-#{max_column_length}s %-20s %-7s %-7s %-7s"
      model.columns.each do |column|
        annotation << sprintf(
          format,
          column.name,
          column.sql_type,
          column.null,
          (column.default || ""),
          column.name == model.primary_key
          )
      end
      annotation << "#"
      annotation << "#-#{'--' * 38}-"
      annotation.join("\n") + "\n"
    end
    
  end

end

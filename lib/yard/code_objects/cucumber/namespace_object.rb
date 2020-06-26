module YARD::CodeObjects::Cucumber
  class NamespaceObject < YARD::CodeObjects::NamespaceObject
    include LocationHelper

    def value;
      nil;
    end
  end

  class Requirements < NamespaceObject;
  end
  class FeatureTags < NamespaceObject;
  end
  class StepTransformers < NamespaceObject;
  end

  class FeatureDirectory < YARD::CodeObjects::NamespaceObject

    attr_accessor :description

    def initialize(namespace, name)
      super(namespace, name)
      @description = ""
    end

    def location
      files.first.first if files && !files.empty?
    end

    def expanded_path
      to_s.split('::')[1..-1].join('/')
    end

    def value;
      name;
    end

    def features
      children.find_all { |d| d.is_a?(Feature) }
    end

    def subdirectories
      subdirectories = children.find_all { |d| d.is_a?(FeatureDirectory) }
      subdirectories + subdirectories.collect { |s| s.subdirectories }.flatten
    end

  end

  CUCUMBER_NAMESPACE = Requirements.new(:root, "requirements") unless defined?(CUCUMBER_NAMESPACE)

  CUCUMBER_TAG_NAMESPACE = FeatureTags.new(CUCUMBER_NAMESPACE, "tags") unless defined?(CUCUMBER_TAG_NAMESPACE)

  CUCUMBER_STEPTRANSFORM_NAMESPACE = StepTransformers.new(CUCUMBER_NAMESPACE, "step_transformers") unless defined?(CUCUMBER_STEPTRANSFORM_NAMESPACE)

end

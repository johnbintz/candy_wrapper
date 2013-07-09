require 'delegate'

module CandyWrapper
  class ModelWrapper < SimpleDelegator
    def self.inherited(klass)
      klass.send(:extend, ClassMethods)

      if klass.name && original = klass.name[/^(.*)FormObject$/, 1]
        klass.wraps original.constantize
      end
    end

    module ClassMethods
      def wraps(klass = nil)
        if klass
          @__wraps__ = klass
        else
          @__wraps__
        end
      end

      def before_wrapped_save(*args)
        @__before_wrapped_save__ ||= []

        if args.empty?
          @__before_wrapped_save__
        else
          @__before_wrapped_save__ += args
        end
      end
    end

    def __wraps__
      self.class.wraps
    end

    def initialize(object, params = {})
      @__object__ = object

      assign_attributes(params)
    end

    def __getobj__
      @__object__
    end

    def assign_attributes(attributes)
      @__params__ = attributes.dup
    end

    def update_attributes(attributes)
      assign_attributes(attributes)

      save
    end

    def save
      self.class.before_wrapped_save.each do |before|
        send("#{before}=", @__object__, @__params__[before])
      end

      @__object__.assign_attributes(__object_params__)

      if result = @__object__.save
        setters_and_setter_params.each do |setter, setter_param|
          send(setter, @__object__, @__params__[setter_param])
        end
      end
    end

    def __object_params__
      object_params = @__params__.dup
      setter_params.each { |key| object_params.delete(key) }
      object_params
    end

    def setter_params
      @__setter_params__ ||= setters.collect { |param| param.gsub('=', '').to_sym }
    end

    def setters
      @__setters__ ||= (my_instance_methods.collect(&:to_s).find_all { |param| param[/=\Z/] } - self.class.before_wrapped_save)
    end

    def setters_and_setter_params
      setters.zip(setter_params)
    end

    def my_instance_methods
      @my_instance_methods ||= (self.class.instance_methods - ModelWrapper.instance_methods)
    end
  end
end


require 'active_support/concern'

module CandyWrapper
  module InheritedResources
    extend ActiveSupport::Concern

    module ClassMethods
      def __candy_wrapper__
        @__candy_wrapper__
      end

      def wrap_in_form_object(options = {})
        @__candy_wrapper__ = {
          with: resource_class.name + "FormObject",
          only: [ :create, :update ]
        }.merge(options)
      end

      def wrap_in_form_object!(*args)
        wrap_in_form_object(*args)
      end
    end

    protected
    def build_resource
      get_resource_ivar || set_resource_ivar(
        if self.class.__candy_wrapper__[:only].include?(action_name.to_sym)
          object = end_of_association_chain.send(method_for_build)
        else
          super
        end
      )
    end

    def create_resource(object)
      if self.class.__candy_wrapper__[:only].include?(action_name.to_sym)
        wrapped_object = candy_wrapper_class.new(object, *resource_params)

        wrapped_object.save
      else
        super
      end
    end

    def update_resource(object, attributes)
      if self.class.__candy_wrapper__[:only].include?(action_name.to_sym)
        wrapped_object = candy_wrapper_class.new(object)
        wrapped_object.update_attributes(*attributes)
      else
        super
      end
    end

    def candy_wrapper_class
      @__candy_wrapper_class__ ||= self.class.__candy_wrapper__[:with].constantize
    end
  end
end


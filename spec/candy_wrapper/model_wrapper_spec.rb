require 'spec_helper'
require 'candy_wrapper/model_wrapper'

describe CandyWrapper::ModelWrapper do
  describe '#update_attributes' do
    let(:model_class) {
      Class.new do
        attr_reader :saved, :attributes

        def save
          @saved = true
        end

        def assign_attributes(attributes)
          @attributes = attributes
        end
      end
    }

    let(:wrap_class) {
      klass = Class.new(CandyWrapper::ModelWrapper) do
        attr_reader :resource, :value

        def setter=(resource, value)
          @resource, @value = resource, value
        end
      end

      klass.send(:wraps, model_class)
      klass
    }

    let(:setter_value) { 'setter value' }
    let(:base_attributes) { { :base => 'base' } }
    let(:attributes) { { :setter => setter_value }.merge(base_attributes) }

    it 'should save the model and trigger the setters on the wrapper' do
      model = model_class.new
      wrap = wrap_class.new(model)

      wrap.update_attributes(attributes)

      model.saved.should be_true
      model.attributes.should be == base_attributes

      wrap.resource.should == model
      wrap.value.should == setter_value
    end
  end
end


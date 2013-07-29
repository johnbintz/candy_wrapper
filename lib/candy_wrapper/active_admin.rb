class ActiveAdmin::DSL
  def wrap_in_form_object
    controller do
      include CandyWrapper::InheritedResources

      wrap_in_form_object!
    end
  end
end

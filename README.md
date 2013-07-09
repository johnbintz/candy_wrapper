# CANDY WRAPPER

Use form objects with ease. Plugs into `inherited_resources` easily:

``` ruby
# app/models/database_object.rb
class DatabaseObject < Persistence::Base
  # ... persistence and relationships only ...
end
```

``` ruby
# app/controllers/database_objects_controller.rb

class DatabaseObjectsController < ApplicationController
  inherit_resources

  # for the parts of inherited_resources that actually persist models,
  # ensure that persistence takes placed within a CandyWrapper::ModelWrapper
  # form object. Those respond to save, assign_attributes, and update_attributes.
  wrap_in_form_object!
end
```

``` ruby
# app/form_objects/database_object_form_object.rb

class DatabaseObjectFormObject < CandyWrapper::ModelWrapper
  def complex_parameter=(database_object, parameter_value)
    # do complex formatting here, probably for nested objects
    # database_object will be saved by this point
  end

  # perform these actions before database_object is saved
  before_wrapped_save :process_first_parameter

  def process_first_parameter=(database_object, parameter_value)
    # use normal accessors to set properties on database_object, it will be
    # saved when all before_wrapped_saved methods are run
  end

  # there is no guarantee in the order that these will run, don't make them
  # depend on each other!
end
```

## Coming soon!

* Form objects that hang off of models as if they were relationships
* A better readme!


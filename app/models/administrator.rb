class Administrator < ActiveRecord::Base
  include Trestle::Auth::ModelMethods
  include Trestle::Auth::ModelMethods::Rememberable
end

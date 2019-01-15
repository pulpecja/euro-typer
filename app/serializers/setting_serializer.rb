class SettingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :value
end

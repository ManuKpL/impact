ActiveAdmin.register Candidate do
  permit_params :name, :screen_name, :party
  index do
    selectable_column
    column :id
    column :name
    column :party
    column :screen_name
    column :description
    column :picture
    actions
  end
end

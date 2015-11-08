ActiveAdmin.register Candidate do
  permit_params :name, :screen_name, :party
  index do
    selectable_column
    column :id
    column :name
    column :party
    column :screen_name
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    inputs 'Details' do
      input :name
      input :screen_name
      input :party
    end
    actions
  end
end

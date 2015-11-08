ActiveAdmin.register User do
  permit_params :email, :admin

  index do
    selectable_column
    column :email
    column :admin
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    inputs 'Details' do
      input :email
      input :admin
    end
    actions
  end

  def name
    email
  end
end
